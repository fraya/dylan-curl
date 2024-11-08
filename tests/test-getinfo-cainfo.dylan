Module:    curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.

define test test-getinfo-cainfo ()
  curl-global-init($curl-global-default);
  block ()
    let curl = make(<curl-easy>);
    curl.curl-cainfo := "/etc/ssl/certs/SecureTrust_CA.pem";
    let cainfo = curl.curl-cainfo;
    format-out("default ca info path: '%s'\n", cainfo);
    assert-true(#t);
  cleanup
    curl-global-cleanup();
  exception (err :: <curl-error>)
    format-out("cainfo failed: %s\n", err.curl-error-message)
  end block;
end test;
