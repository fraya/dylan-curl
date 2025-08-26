Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Reference: https://curl.se/libcurl/c/curl_ws_send.html

define constant $wss-url =
  "wss://demo.piesocket.com/v3/channel_123?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self";

define constant $wss-payload =
  "Hello Websocket!";

define test test-lib-curl-ws-send ()
  with-curl-global ()
    with-curl-easy-handle (curl)
      curl-easy-setopt-url(curl, $wss-url);
      curl-easy-setopt-connect-only(curl, 2);
      let code = curl-easy-perform(curl);
      assert-equal($curle-ok, code, curl-easy-strerror(code));

      let payload = $wss-payload;
      let n = payload.size;
      let offset = 0;

      format-out("\nWebsocket: %s\n", $wss-url);
      format-out("Websocket: Sending %d bytes\n", n);
      force-out();

      let buffer = payload;
      block (finished)
        while (#t)
          let (send-code, sent) =
            curl-ws-send(curl, buffer, n - offset, 0, $curlws-text);

          assert-true(sent >= 0, "Negative data sent");

          offset := offset + sent;
          assert-true(offset <= n);

          format-out("Websocket: %s - sent %d bytes\n",
                     curl-easy-strerror(send-code), sent);
          force-out();

          select (send-code)
            $curle-ok =>
              unless (offset < n) finished() end;
            $curle-again =>
              ; // loop again
            otherwise =>
              error(curl-easy-strerror(send-code));
          end select;
        end while;
      end block;
    end with-curl-easy-handle;
  end with-curl-global;
end test;
