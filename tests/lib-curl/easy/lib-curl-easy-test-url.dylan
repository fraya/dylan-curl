Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Reference: https://curl.se/libcurl/c/curl_url.html

define test test-lib-curl-url ()
  with-curl-global ()
    let curlu = #f;
    block ()
      curlu := curl-url();
      assert-no-errors(curlu);
    cleanup
      unless (curlu)
        curl-url-cleanup(curlu)
      end
    end block;
  end
end test;
