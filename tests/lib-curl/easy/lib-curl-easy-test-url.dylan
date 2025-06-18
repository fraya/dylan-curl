Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Reference: https://curl.se/libcurl/c/curl_url.html

define test test-lib-curl-url ()
  with-curl-global ()
    let curlu :: false-or(<curlu*>) = #f;
    block ()
      curlu := curl-url();
      assert-no-errors(curlu);
    cleanup
      unless (curlu)
        curl-url-cleanup(curlu)
      end;
    end block;
  end
end test;

define test test-lib-curl-url-dup ()
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

define test test-lib-curl-url-set ()
  with-curl-global ()
    let curlu :: false-or(<curlu*>) = #f;
    block ()
      curlu := curl-url();
      let rc = curl-url-set(curlu, $curlupart-url, "https://example.org", 0);
      assert-equal($curlue-ok, rc);
      
      // change it to a Ftp Url
      rc := curl-url-set(curlu, $curlupart-scheme, "ftp", 0);
      assert-equal($curlue-ok, rc);
        
      rc := curl-url-set(curlu, -1, "foo", 0);
      assert-not-equal($curle-ok, rc);
    cleanup
      unless (curlu)
        curl-url-cleanup(curlu)
      end
    end block;
  end
end test;

define test test-lib-curl-url-get ()
  with-curl-global ()
    let curlu :: false-or(<curlu*>) = #f;
    block ()
      curlu := curl-url();
      let rc = curl-url-set(curlu, $curlupart-url, "https://example.org", 0);
      assert-equal($curlue-ok, rc);
      
      let (scheme, rc) = curl-url-get(curlu, $curlupart-scheme, 0);
      // assert-equal($curlue-ok, rc);
      // assert-equal("https", scheme);

    cleanup
      unless (curlu)
        curl-url-cleanup(curlu)
      end
    end block;
  end
end test;