Module:    dylan-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Reference: https://curl.se/libcurl/c/simple.html

define test test-dylan-curl-easy-simple-http-page-with-setopt ()
  local
    method curl-handle()
      make(<curl-easy>,
           url: "http://example.com/",
           followlocation: 1)
    end;    
  block ()
    with-curl-global ()
      with-curl-easy (curl = curl-handle())
        curl-easy-perform(curl);
        assert-equal(200, curl.curl-easy-response-code);
      end
    end
  exception (err :: <curl-error>)
    format-err("%s\n", err.curl-error-message)
  end block;
end test;
