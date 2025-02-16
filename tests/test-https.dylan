Module:     curl-easy-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Reference:  https://curl.se/libcurl/c/https.html

define test test-https (tags: #("io", "slow"))
  block () 
    with-curl-global ($curl-global-default)
      with-curl-easy (curl)
	curl.curl-url := "https://example.org";
	curl.curl-ssl-verifypeer := 1;
	curl.curl-ssl-verifyhost := 1;
	curl.curl-ca-cache-timeout := 604800;
	curl-easy-perform(curl);
	assert-true(#t);
      end with-curl-easy;
    end with-curl-global;
  exception (err :: <curl-error>)
    format-err("Curl error: %s\n", err.curl-error-message)
  end block;
end test;
