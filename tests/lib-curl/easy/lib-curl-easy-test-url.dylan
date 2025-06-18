Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Reference: https://curl.se/libcurl/c/curl_url.html

define test test-lib-curl-url ()
  with-curl-global ()
    let curlu1 :: false-or(<curlu*>) = #f;
    let curlu2 :: false-or(<curlu*>) = #f;
    block ()
      curlu1 := curl-url();
      curlu2 := curl-url-dup(curlu1);
      assert-no-errors(curlu1);
    cleanup
      unless (curlu1)
        curl-url-cleanup(curlu1)
      end;
      unless (curlu2)
        curl-url-cleanup(curlu2)
      end;
    end block;
  end
end test;
