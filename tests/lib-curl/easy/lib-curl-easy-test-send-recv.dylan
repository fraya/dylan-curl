Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Reference: https://curl.se/libcurl/c/curl_easy_recv.html

define test test-lib-curl-easy-recv ()
  with-curl-global ()
    with-curl-easy-handle (curl)
      curl-easy-setopt-url(curl, "http://example.org");
      /* Do not do the transfer - only connect to host */
      curl-easy-setopt-connect-only(curl, 1);

      let res = curl-easy-perform(curl);
      assert-equal($curle-ok, res);

      let buffer = make(<string>, size: 100, fill: '*');
      register-c-dylan-object(buffer);
      let c-buffer = export-c-dylan-object(buffer);
      let (nread, res) = curl-easy-recv(curl, c-buffer, buffer.size);
      assert-equal($curle-ok, res);
      assert-true(nread >= 0);
      unregister-C-Dylan-object(buffer);

      format-out("\nbytes read: %d buffer\n", nread);
      format-out("Buffer(%d): %s\n", buffer.size, buffer);
    end
  end
end test;
