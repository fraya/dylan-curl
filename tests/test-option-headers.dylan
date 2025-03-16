Module:     curl-easy-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.

define test test-option-headers (tags: #("io", "httpbin"))
  with-curl-global($curl-global-default)
    with-curl-easy (curl = make(<curl-easy>),
                    url = httpbin("/headers"),
                    header = "Content-Type: application/json")
      curl.curl-header := "Authorization: Bearer your_token_here";
      curl.curl-header := "X-friend: Foo";
      add-header!(curl,
                  "X-Custom-Header: Chucho",
                  "Another-Header: Good");
      curl-easy-perform(curl);
      assert-true(#t);
    end with-curl-easy;
  end with-curl-global;
end test;
