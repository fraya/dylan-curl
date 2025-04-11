Module:     lib-curl-easy-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Reference:  https://curl.se/libcurl/c/https.html
Reference:  https://curl.se/libcurl/c/CURLOPT_SSL_VERIFYPEER.html
Reference:  https://curl.se/libcurl/c/CURLOPT_SSL_VERIFYHOST.html
Reference:  https://curl.se/libcurl/c/CURLOPT_CA_CACHE_TIMEOUT.html

define test test-https (tags: #("io", "slow"))
  block ()
    with-curl-global ()
      with-curl-easy-handle (curl)
        curl-easy-setopt-url(curl, "https://example.org");
        curl-easy-setopt-ssl-verifypeer(curl, #f);
        curl-easy-setopt-ssl-verifyhost(curl, 1);
        curl-easy-setopt-ca-cache-timeout(curl, 604800);
        let curl-code = curl-easy-perform(curl);
        assert-equal($curle-ok, curl-code);
      end;
    end;
  exception (err :: <curl-error>)
      format-err("Curl error: %s\n", err.curl-error-message)
  end block;
end test;
