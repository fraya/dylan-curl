Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.

define test test-getinfo-cainfo ()
  block()
    with-curl-global ()
      with-curl-easy-handle (curl)
        curl-easy-setopt-cainfo(curl, "/etc/ssl/certs/SecureTrust_CA.pem");
        let cainfo = curl-easy-getinfo-cainfo(curl);
        format-out("default ca info path: '%s'\n", cainfo);
        assert-true(#t);
      end
    end
  exception (err :: <curl-error>)
      format-out("cainfo failed: %s\n", err.curl-error-message)
  end block;
end test;
