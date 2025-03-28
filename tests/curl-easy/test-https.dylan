Module:     curl-easy-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Reference:  https://curl.se/libcurl/c/https.html
Reference:  https://curl.se/libcurl/c/CURLOPT_SSL_VERIFYPEER.html
Reference:  https://curl.se/libcurl/c/CURLOPT_SSL_VERIFYHOST.html
Reference:  https://curl.se/libcurl/c/CURLOPT_CA_CACHE_TIMEOUT.html

define test test-https (tags: #("io", "slow"))
  local method curl-easy-handler()
          make(<curl-easy>,
               url: "https://example.org",
               ssl-verifypeer: #f,
               ssl-verifyhost: 1,
               ca-cache-timeout: 604800)
        end;

  block ()
    with-curl-global ($curl-global-default)
      with-curl-easy (curl = curl-easy-handler())
        curl-easy-perform(curl);
        assert-true(#t);
      end with-curl-easy;
    end with-curl-global;
  exception (err :: <curl-error>)
      format-err("Curl error: %s\n", err.curl-error-message)
  end block;
end test;
