Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Reference: https://curl.se/libcurl/c/simple.html

define test test-lib-curl-easy-simple-http-page ()
  with-curl-global ()
    with-curl-easy-handle (curl)
      curl-easy-setopt-url(curl, "http://example.com");
      curl-easy-setopt-followlocation(curl, 1);

      let res = curl-easy-perform(curl);
      if (res ~= $curle-ok)
        format-err("curl-easy-perform() failed: %s\n",
                   curl-easy-strerror(res))
      end;
      assert-true(#t);
    end
  end
end test;
