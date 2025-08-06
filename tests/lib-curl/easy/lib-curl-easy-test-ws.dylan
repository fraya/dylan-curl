Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Reference: https://curl.se/libcurl/c/curl_ws_send.html

define test test-lib-curl-easy-share-ws ()
  with-curl-global ()
    with-curl-easy-handle (curl)
      curl-easy-setopt-url(curl, "wss://echo.websocket.org/");
      curl-easy-setopt-connect-only(curl, 2);
      let code = curl-easy-perform(curl);
      assert-equal($curle-ok, code, curl-easy-strerror(code));

      let payload = "PAYLOAD";
      let n       = payload.size;
      let offset  = 0;
      let res     = $curle-ok;

      register-c-dylan-object(payload);
      let buffer = export-c-dylan-object(payload);
      while (res = $curle-ok)
        let (res, sent) =
          curl-ws-send(curl, buffer, n - offset, 0, $curlws-text);
        offset := offset + sent;
      end while;
      unregister-c-dylan-object(payload);
    end with-curl-easy-handle;
  end with-curl-global;
end test;
