Module:     curl-easy-test-suite
Copyright:  Copyright (C) 2024, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.

define test test-postfields (tags: #("io"))
  block()
    curl-global-init($curl-global-default);
    let curl = make(<curl-easy>);
    curl.curl-url := httpbin("/post");
    curl.curl-postfields := "name=daniel&project=curl";
    curl-easy-perform(curl);
    assert-equal(200, curl.curl-response-code);
  cleanup
    curl-global-cleanup();
  end block;
end test;

define test test-http-methods (tags: #("io", "httpbin"))
  block ()
    curl-global-init($curl-global-default);
    let curl = make(<curl-easy>);
    let http-methods = list("delete", "get", "patch", "post", "put");
    for (http-method in http-methods)
      curl.curl-url := concatenate(httpbin("/"), http-method);
      curl.curl-customrequest := uppercase(http-method);
      curl-easy-perform(curl);
      assert-equal(200, curl.curl-response-code);
    end for;
  cleanup
    curl-global-cleanup();
  end block;
end test;

define test test-auth-basic (tags: #("io", "httpbin"))
  block ()
    curl-global-init($curl-global-default);
    let curl = make(<curl-easy>);
    curl.curl-url := httpbin("/basic-auth/admin/hunter42");
    curl.curl-username := "admin";
    curl.curl-password := "hunter42";
    curl.curl-easy-perform;
    assert-equal(200, curl.curl-response-code);
  cleanup
    curl-global-cleanup();
  end block;
end test;

define test test-auth-bearer (tags: #("io", "httpbin"))
  let headers = null-pointer(<curlopt-slistpoint>);
  block ()
    curl-global-init($curl-global-default);
    let curl = make(<curl-easy>);
    curl.curl-url := httpbin("/bearer");
    let bearer = "hunter42";
    headers := curl-slist-append(headers, concatenate("Authorization: Bearer ", bearer));
    curl.curl-httpheader := headers;
    curl-easy-perform(curl);
    assert-equal(200, curl.curl-response-code);
  cleanup
    curl-slist-free-all(headers);
    curl-global-cleanup();
  end block;
end test test-auth-bearer;

define test test-auth-digest (tags: #("io", "httpbin"))
  block ()
    curl-global-init($curl-global-default);
    let curl = make(<curl-easy>);
    let url = httpbin("/digest-auth/auth/user/passwd");
    curl.curl-url := url;
    curl.curl-verbose := 0;
    curl.curl-userpwd := "user:passwd";
    curl.curl-httpauth := $curlauth-digest;
    curl-easy-perform(curl);
    assert-equal(200, curl.curl-response-code);
  cleanup
    curl-global-cleanup();
  end block;
end test test-auth-digest;
