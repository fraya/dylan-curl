Module:    curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
Reference: https://curl.se/libcurl/c/CURLOPT_DEBUGFUNCTION.html
Reference: https://curl.se/libcurl/c/CURLOPT_VERBOSE.html

define function dump-debug-callback
    (handle :: <c-void*>,
     type :: <integer>,
     data :: <string>,
     size :: <integer>,
     clientp :: <c-void*>)
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

define test test-debug-callback (tags: #("io"))
  local method curl-easy-handle()
          make(<curl-easy>,
               url: "https://example.com/",
               verbose: #t,  // verbose to use debug-callback
               debugfunction: $curl-debug-callback)
        end;

  block ()
    with-curl-global ($curl-global-default)
      with-curl-easy (curl = curl-easy-handle())
        dynamic-bind (*curl-debug-callback* = dump-debug-callback)
          curl-easy-perform(curl);
        end dynamic-bind;
        assert-true(#t);
      end with-curl-easy;
    end with-curl-global;
  exception (curl-error :: <curl-error>)
    format-err("Curl error: %s", as(<string>, curl-error))
  end block;
end test;
