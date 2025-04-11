Module:    dylan-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
Reference: https://curl.se/libcurl/c/CURLOPT_DEBUGFUNCTION.html
Reference: https://curl.se/libcurl/c/CURLOPT_VERBOSE.html

define function dump-debug-callback
    (handle :: <curl-easy-handle>,
     type :: <integer>,
     data :: <string>,
     size :: <integer>,
     clientp :: <C-Dylan-object>)
 => (code :: <integer>)
  local
    method transmission (type)
      select (type)
        $curlinfo-text => 
          "== Info:";
        $curlinfo-header-out => 
          "=> Send header";
        $curlinfo-data-out => 
          "=> Send data";
        $curlinfo-ssl-data-out =>
          "=> Send SSL data";
        $curlinfo-header-in =>
          "<= Recv header";
        $curlinfo-data-in =>
          "<= Recv data";
        $curlinfo-ssl-data-in =>
          "<= Recv SSL data";
        otherwise
          => "Curlinfo end";
      end
    end;
  format-err("%s\n%s", transmission(type), data);
  force-out();
  0
end function;

define test dylan-curl-easy-test-debug-callback ()
  with-curl-global ()
    with-curl-easy (curl = "https://example.com/",
                    verbose: #t,
                    debug-callback: dump-debug-callback)
      assert-no-errors(curl.curl-easy-perform);
    end
  end
end test;
