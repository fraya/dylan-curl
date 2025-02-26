Module:    curl-easy-test-suite
Copyright: Copyright (C) 2024, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.

define constant $httpbin = "httpbin.org";
define constant $httpbin_port = "80";

define function httpbin
    (path :: <string>) => (url :: <string>)
  let site = environment-variable("HTTPBIN") | $httpbin;
  let port = environment-variable("HTTPBIN_PORT") | $httpbin_port;
  concatenate("http://", site, ":", port, path);
end;

define suite curl-easy-test-suite ()
  suite suite-httpbin;
end suite;

// Use `_build/bin/easy-curl-test-suite --help` to see options.
run-test-application()
