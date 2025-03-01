Module:      curl-easy-test-suite
Copyright:   Copyright (C) 2024, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.
Description: Tests using 'httpbin.org'. To use a local container
             use the environment variables 'HTTPBIN' and 'HTTPBIN_PORT'.
             See README.md in this directory.

define constant $httpbin-default-site = "httpbin.org";
define constant $httpbin-default-port = "80";

define function httpbin
    (path :: <string>) => (url :: <string>)
  let site = environment-variable("HTTPBIN") | $httpbin-default-site;
  let port = environment-variable("HTTPBIN_PORT") | $httpbin-default-port;
  concatenate("http://", site, ":", port, path);
end;

define test test-postfields (tags: #("io"))
  with-curl-easy (curl)
    curl.curl-url := httpbin("/post");
    curl.curl-postfields := "name=daniel&project=curl";
    curl-easy-perform(curl);
    assert-equal(200, curl.curl-response-code);
  end with-curl-easy;
end test;

define test test-http-methods (tags: #("io", "httpbin"))
  with-curl-easy (curl)
    let http-methods = list("delete", "get", "patch", "post", "put");
    for (http-method in http-methods)
      curl.curl-url := concatenate(httpbin("/"), http-method);
      curl.curl-customrequest := uppercase(http-method);
      curl-easy-perform(curl);
      assert-equal(200, curl.curl-response-code);
    end for;
  end with-curl-easy;
end test;

define test test-auth-basic (tags: #("io", "httpbin"))
  with-curl-easy (curl)
    curl.curl-url := httpbin("/basic-auth/admin/hunter42");
    curl.curl-username := "admin";
    curl.curl-password := "hunter42";
    curl.curl-easy-perform;
    assert-equal(200, curl.curl-response-code);
  end with-curl-easy;
end test;

define test test-auth-bearer (tags: #("io", "httpbin"))
  let headers = null-pointer(<curlopt-slistpoint>);
  block ()
    with-curl-easy (curl)
      curl.curl-url := httpbin("/bearer");
      let bearer = "hunter42";
      headers := curl-slist-append(headers, concatenate("Authorization: Bearer ", bearer));
      curl.curl-httpheader := headers;
      curl-easy-perform(curl);
      assert-equal(200, curl.curl-response-code);
    end with-curl-easy;      
  cleanup
      curl-slist-free-all(headers);
  end block;
end test test-auth-bearer;

define test test-auth-digest (tags: #("io", "httpbin"))
  with-curl-easy (curl)
    let url = httpbin("/digest-auth/auth/user/passwd");
    curl.curl-url := url;
    curl.curl-verbose := 0;
    curl.curl-userpwd := "user:passwd";
    curl.curl-httpauth := $curlauth-digest;
    curl-easy-perform(curl);
    assert-equal(200, curl.curl-response-code);
  end with-curl-easy;
end test test-auth-digest;

define suite suite-httpbin
    (setup-function: curl-library-setup,
     cleanup-function: curl-library-cleanup)
  test test-postfields;
  test test-http-methods;
  test test-auth-basic;
  test test-auth-bearer;
  test test-auth-digest
end suite;
