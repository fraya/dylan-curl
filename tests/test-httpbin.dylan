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
  with-curl-easy (curl = make(<curl-easy>,
                              url: httpbin("/post"),
                              postfields: "name=daniel&project=curl"))
    curl-easy-perform(curl);
    assert-equal(200, curl.curl-response-code);
  end with-curl-easy;
end test;

define test test-http-methods (tags: #("io", "httpbin"))
  with-curl-easy (curl = make(<curl-easy>))
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
  with-curl-easy (curl = make(<curl-easy>,
                              url: httpbin("/basic-auth/admin/hunter42"),
                              username: "admin",
                              password: "hunter42"))
    curl.curl-easy-perform;
    assert-equal(200, curl.curl-response-code);
  end with-curl-easy;
end test;

define test test-auth-bearer (tags: #("io", "httpbin"))
  let bearer = "hunter42";
  with-curl-easy (curl = make(<curl-easy>,
                              url: httpbin("/bearer"),
                              header: concatenate("Authorization: Bearer ", bearer)))
    curl-easy-perform(curl);
    assert-equal(200, curl.curl-response-code);
  end with-curl-easy;
end test test-auth-bearer;

define test test-auth-digest (tags: #("io", "httpbin"))
  with-curl-easy (curl = make(<curl-easy>,
                              url: httpbin("/digest-auth/auth/user/passwd"),
                              verbose: #f,
                              userpwd: "user:passwd",
                              httpauth: $curlauth-digest))
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
