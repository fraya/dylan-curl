Module:     curl-easy-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.

define test test-option-headers (tags: #("io", "httpbin"))
  with-curl-global($curl-global-default)
    with-curl-easy (curl)
      curl.curl-url := httpbin("/headers");
      let headers = null-pointer(<curlopt-slistpoint>);
      headers := curl-slist-append(headers, "X-Custom-Header: Chucho");
      headers := curl-slist-append(headers, "Another-Header: Good");
      curl.curl-httpheader := headers;
      curl-easy-perform(curl);
      curl-slist-free-all(headers);
      assert-true(#t);
    end with-curl-easy;
  end with-curl-global;
end test;
