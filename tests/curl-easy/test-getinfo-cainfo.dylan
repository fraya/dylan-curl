Module:    curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.

define test test-getinfo-cainfo ()
  local method curl-easy-handler()
          make(<curl-easy>,
               cainfo: "/etc/ssl/certs/SecureTrust_CA.pem")
        end;

  block()
    with-curl-global ($curl-global-default)
      with-curl-easy (curl = curl-easy-handler())
        let cainfo = curl.curl-cainfo;
        format-out("default ca info path: '%s'\n", cainfo);
        assert-true(#t);
      end with-curl-easy;
    end with-curl-global;
  exception (err :: <curl-error>)
      format-out("cainfo failed: %s\n", err.curl-error-message)
  end block;
end test;
