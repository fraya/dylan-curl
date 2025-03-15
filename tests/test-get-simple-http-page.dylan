Module:    curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.

// Example translated from: https://curl.se/libcurl/c/simple.html

define test test-get-simple-http-page (tags: #("io"))
  block ()
    with-curl-global ($curl-global-default)
      with-curl-easy (curl = make(<curl-easy>),
                      url = "https://example.com",
                      followlocation = 1)
	      curl-easy-perform(curl);
	      assert-true(#t);
      end with-curl-easy;
    end with-curl-global;
  exception (err :: <curl-error>)
    format-out("Curl failed: %s\n", err.curl-error-message);
  end block;
end test;
