Module:      lib-curl-easy-test-suite
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
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

define test test-postfields (tags: #("httpbin"))
  with-curl-easy-handle (curl)
    curl-easy-setopt-url(curl, httpbin("/post"));
    curl-easy-setopt-postfields(curl, "name=daniel&project=curl");
    let curl-code = curl-easy-perform(curl);
    assert-equal($curle-ok, curl-code);
    assert-equal(200, curl-easy-getinfo-response-code(curl));
  end;
end test;

define test test-http-methods (tags: #("io", "httpbin"))
  with-curl-easy-handle (curl)
    let http-methods = list("delete", "get", "patch", "post", "put");
    for (http-method in http-methods)
      let url = concatenate(httpbin("/"), http-method);
      curl-easy-setopt-url(curl, url);
      curl-easy-setopt-customrequest(curl, uppercase(http-method));
      let curl-code = curl-easy-perform(curl);
      assert-equal($curle-ok, curl-code);
      assert-equal(200, curl-easy-getinfo-response-code(curl));
    end;
  end;
end test;

define test test-auth-basic (tags: #("io", "httpbin"))
  with-curl-easy-handle (curl)
    curl-easy-setopt-url(curl, httpbin("/basic-auth/admin/hunter42"));
    curl-easy-setopt-username(curl, "admin");
    curl-easy-setopt-password(curl, "hunter42");
    let curl-code = curl.curl-easy-perform;
    assert-equal($curle-ok, curl-code);
    assert-equal(200, curl-easy-getinfo-response-code(curl));
  end;
end test;

define test test-auth-bearer (tags: #("io", "httpbin"))
  let headers = null-pointer(<curl-slist*>);
  let url = httpbin("/bearer");
  let token = "hunter42";
  let auth-header = concatenate("Authorization: Bearer ", token);
  block ()
    with-curl-easy-handle (curl)
      curl-easy-setopt-url(curl, url);
      headers := curl-slist-append(headers, auth-header);
      curl-easy-setopt-httpheader(curl, headers);
      let curl-code = curl-easy-perform(curl);
      assert-equal($curle-ok, curl-code);
      assert-equal(200, curl-easy-getinfo-response-code(curl));
    end;
  cleanup
    curl-slist-free-all(headers);
  end block;  
end test;

define test test-auth-digest (tags: #("io", "httpbin"))
  with-curl-easy-handle (curl)
    curl-easy-setopt-url(curl, httpbin("/digest-auth/auth/user/passwd"));
    curl-easy-setopt-userpwd(curl, "user:passwd");
    curl-easy-setopt-httpauth(curl, $curlauth-digest);
    let curl-code = curl-easy-perform(curl);
    assert-equal($curle-ok, curl-code);
    assert-equal(200, curl-easy-getinfo-response-code(curl));
  end;
end test test-auth-digest;

define test test-option-headers (tags: #("io", "httpbin"))
  let headers = null-pointer(<curl-slist*>);
  block ()
    with-curl-easy-handle (curl)
      curl-easy-setopt-url(curl, httpbin("/headers"));
      headers := curl-slist-append(headers, "Content-Type: application/json");
      headers := curl-slist-append(headers, "Authorization: Bearer your_token_here");
      headers := curl-slist-append(headers, "X-friend: Foo");
      headers := curl-slist-append(headers, "X-Custom-Header: Chucho");
      headers := curl-slist-append(headers, "Another-Header: Good");
      curl-easy-setopt-httpheader(curl, headers);
      let curl-code = curl-easy-perform(curl);
      assert-equal($curle-ok, curl-code);
      assert-equal(200, curl-easy-getinfo-response-code(curl));
    end;
  cleanup
    curl-slist-free-all(headers);
  end block;
end test;

define suite suite-httpbin
    (setup-function: 
      curry(curl-global-init, $curl-global-default),
     cleanup-function: 
      curl-global-cleanup)
  test test-postfields;
  test test-http-methods;
  test test-auth-basic;
  test test-auth-bearer;
  test test-auth-digest;
  test test-option-headers;
end suite;


