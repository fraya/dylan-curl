Module:     curl-easy-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.

define test test-option-headers (tags: #("io", "httpbin"))
  curl-global-init($curl-global-default);
  let headers = null-pointer(<curlopt-slistpoint>);
  block ()
    with-curl-easy (curl)
      curl.curl-url := httpbin("/headers");

      headers := curl-slist-append(headers, "X-Custom-Header: Chucho");
      headers := curl-slist-append(headers, "Another-Header: Good");
      curl.curl-httpheader := headers;
      curl-easy-perform(curl);
      assert-true(#t);
    end with-curl-easy;
  cleanup
    curl-slist-free-all(headers);
    curl-global-cleanup();
  end block;
end test;
