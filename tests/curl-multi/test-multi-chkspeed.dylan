Module:     curl-multi-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.

define constant $urls
  = #["https://example.net", "https://example.com"];
        
define test test-multi-chkspeed (tags: #("io", "slow"))
  block ()
    with-curl-global ($curl-global-default)
      with-curl-multi (multi = make(<curl-multi>))
        for (url in $urls)
          let handle = make(<curl-easy>, url: url);
          curl-multi-add!(multi, handle);
        end;
      end;
      assert-true(#t);
    end;
  exception (err :: <error>)
    format-err("Error: %s\n", err);
    force-out();
    assert-true(#f);
  end block;
end test;
