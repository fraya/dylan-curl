Module:     curl-easy-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.

define test test-option-headers (tags: #("io", "httpbin"))
  with-curl-global($curl-global-default)
    with-curl-easy (curl = make(<curl-easy>,
                                url: httpbin("/headers")))
      add-header!(curl,
                  "Content-Type: application/json",
                  "Authorization: Bearer your_token_here",
                  "X-friend: Foo",
                  "X-Custom-Header: Chucho",
                  "Another-Header: Good");
      curl-easy-perform(curl);
      assert-true(#t);
    end with-curl-easy;
  end with-curl-global;
end test;
