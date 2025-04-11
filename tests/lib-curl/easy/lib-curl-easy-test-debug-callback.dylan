Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
Reference: https://curl.se/libcurl/c/CURLOPT_DEBUGFUNCTION.html
Reference: https://curl.se/libcurl/c/CURLOPT_VERBOSE.html

define function dump-debug-callback
    (handle :: <c-void*>,
     type :: <integer>,
     data :: <string>,
     size :: <integer>,
     clientp :: <C-Dylan-object>)
 => (code :: <integer>)
  local method dump(message, data)
          format-out("%s\n%s", message, data);
          force-out();
        end,
        method send(what, data)
          dump(concatenate(">> SEND ", what), data)
        end,
        method recv(what, data)
          dump(concatenate("<< RECV ", what), data)
        end;
  let transmit = select (type)
                   $curlinfo-text
                     => curry(recv, "data");
                   $curlinfo-header-in
                     => curry(send, "data");
                   $curlinfo-header-out
                     => curry(send, "header");
                   $curlinfo-data-in
                     => curry(recv, "header");
                   $curlinfo-data-out
                     => curry(send, "header");
                   $curlinfo-ssl-data-in
                     => curry(recv, "SSL data");
                   $curlinfo-ssl-data-out
                     => curry(send, "SSL data");
                   otherwise
                     => error("Invalid curl info type: %d", type);
                 end select;
  transmit(data);
  0
end function;

define test test-lib-curl-easy-debug-callback ()
  block ()
    with-curl-global ()
      with-curl-easy-handle (curl)

        curl-easy-setopt-url(curl, "https://example.com/");
        curl-easy-setopt-verbose(curl, #t);
        curl-easy-setopt-debugfunction(curl, $curl-debug-callback);
        
        dynamic-bind (*curl-debug-callback* = dump-debug-callback)
          let code = curl-easy-perform(curl);
          assert-equal($curle-ok, code);
        end

      end
    end
  exception (err :: <curl-error>)
    format-err("Curl error: %s", err.curl-error-message)
  end
end test;
