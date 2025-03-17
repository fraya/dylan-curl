Module:    curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.

define function dump-debug-callback
    (handle :: <c-void*>,
     type :: <integer>,
     data :: <string>,
     size :: <integer>,
     clientp :: <c-void*>)
 => (code :: <integer>)
  local method dump(message, data)
          format-out("\n%s\n%s", message, data)
        end method;
  select (type)
    $curlinfo-text
      => dump("<= Recv data", data);
    $curlinfo-header-in
      => dump("=> Send data", data);
    $curlinfo-header-out
      => dump("=> Send header", data);
    $curlinfo-data-in
      => dump("<= Recv header", data);
    $curlinfo-data-out
      => dump("=> Send header", data);
    $curlinfo-ssl-data-in
      => dump("<= Recv SSL data", data);
    $curlinfo-ssl-data-out
      => dump("=> Send SSL data", data);
    otherwise
      => format-out("Invalid curl info type: %d", type);
  end select;
  0
end function;

define test test-debug-callback (tags: #("io"))
  block ()
    with-curl-global ($curl-global-default)
      with-curl-easy (curl = make(<curl-easy>,
                                  url: "https://example.com/",
                                  verbose: #t,  // verbose to use debug-callback
                                  debugfunction: $curl-debug-callback))
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
