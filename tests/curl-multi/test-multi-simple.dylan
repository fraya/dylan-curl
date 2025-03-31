Module:     curl-multi-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Reference:  https://curl.se/libcurl/c/10-at-a-time.html

define test test-multi-simple (tags: #("io", "slow"))
  local method debug (format-string, #rest format-args)
          apply(format-err, concatenate("DEBUG> ", format-string), format-args);
          force-err();
        end,
        method make-curl-easy(url)
          make(<curl-easy>,
               url: url)
        end;
  
  let urls = #["https://example.net", "https://example.com"];

  block ()
    with-curl-global ($curl-global-default)
      with-curl-multi (multi = make(<curl-multi>))

        for (url in urls)
          curl-multi-add!(multi, make-curl-easy(url));
        end for;
        
        let requests-alive = curl-multi-perform(multi);
        debug("%d requests alive\n", requests-alive);

        while (requests-alive > 0)
          requests-alive := curl-multi-perform(multi);
        end while;
      end with-curl-multi;
      assert-true(#t, "Download finished");
    end with-curl-global;
  exception (err :: <error>)
    format-err("Houston, we have an error!> %s\n", as(<string>, err));
    force-out();
  end block;
end test;
