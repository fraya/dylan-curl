Module:    curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.

// Example translated from: https://curl.se/libcurl/c/simple.html

define test test-get-simple-http-page (tags: #("io"))
  block ()
    curl-global-init($curl-global-default);
    let curl = make(<curl-easy>);
    curl.curl-url := "https://example.com/";
    curl.curl-followlocation := 1;
    curl-easy-perform(curl);
    assert-true(#t);
  cleanup
    curl-global-cleanup();
  exception (err :: <curl-error>)
    format-out("Curl failed: %s\n", err.curl-error-message);
  end block;
end test;
