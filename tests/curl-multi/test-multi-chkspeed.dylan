Module:     curl-multi-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Reference:  https://curl.se/libcurl/c/10-at-a-time.html

define constant $urls
  = #["https://www.microsoft.com",
      "https://opensource.org",
      "https://www.google.com",
      "https://www.yahoo.com",
      "https://www.ibm.com",
      "https://www.mysql.com",
      "https://www.oracle.com",
      "https://www.ripe.net",
      "https://www.iana.org",
      "https://www.amazon.com",
      "https://www.netcraft.com",
      "https://www.heise.de",
      "https://www.chip.de",
      "https://www.ca.com",
      "https://www.cnet.com",
      "https://www.mozilla.org",
      "https://www.cnn.com",
      "https://www.wikipedia.org",
      "https://www.dell.com",
      "https://www.hp.com",
      "https://www.cert.org",
      "https://www.mit.edu",
      "https://www.nist.gov",
      "https://www.ebay.com",
      "https://www.playstation.com",
      "https://www.uefa.com",
      "https://www.ieee.org",
      "https://www.apple.com",
      "https://www.symantec.com",
      "https://www.zdnet.com",
      "https://www.fujitsu.com/global/",
      "https://www.supermicro.com",
      "https://www.hotmail.com",
      "https://www.ietf.org",
      "https://www.bbc.co.uk",
      "https://news.google.com",
      "https://www.foxnews.com",
      "https://www.msn.com",
      "https://www.wired.com",
      "https://www.sky.com",
      "https://www.usatoday.com",
      "https://www.cbs.com",
      "https://www.nbc.com/",
      "https://slashdot.org",
      "https://www.informationweek.com",
      "https://apache.org",
      "https://www.un.org"];
        
define constant $max-parallel = 10;

define test test-multi-chkspeed (tags: #("io", "slow"))
  local method debug (format-string, #rest format-args)
          apply(format-err, concatenate("DEBUG> ", format-string), format-args);
          force-err();
        end,
        method make-curl-easy(url)
          make(<curl-easy>,
               url: url,
               private: url,
               verbose: #t)
        end;

  let transfers = 0;
  let msgs-left = -1;

  block ()
    with-curl-global ($curl-global-default)
      with-curl-multi (multi = make(<curl-multi>))
        multi.curl-multi-maxconnects := $max-parallel;
        debug("Max parallel connections is %d\n", $max-parallel);

        let max-handlers = min($max-parallel, $urls.size);
        debug("Max number of handlers is %d\n", max-handlers);

        let left = 0;
        for (i from 0 below max-handlers)
          let handle = make-curl-easy($urls[i]);
          curl-multi-add!(multi, handle);
          debug("Added %= %s\n", handle, $urls[i]);
          transfers := i;
          left := left + 1;
        end for;

        let finished? = #f;
        while (~finished?)

          let still-alive = curl-multi-perform(multi);
          debug("%d connections still alive\n", still-alive);
          
          let (message, messages-left) 
            = curl-multi-info-read(multi);
          debug("%d messages left\n", messages-left);
          debug("Message %=\n", message);
          
          while (message)
            if (curlmsg-done?(message))
              debug("Curl message DONE\n");
              let easy   = curlmsg-curl-easy(message);
              debug("Message easy handle> %=\n", easy);
              let url    = easy.curl-private();
              let data   = message.curlmsg-data;
              let result = data.curlmsg-data-result; 
              format-out("R> %d - %s <%s>\n", 
                         result,
                         curl-easy-strerror(result),
                         url);
              force-out();
              left := left - 1;
            else
              format-err("E> CURLMsg (%d)\n", message.curlmsg-msg)
            end if;

            if (transfers < $urls.size)
              transfers := transfers + 1;
              curl-multi-add!(multi, make-curl-easy($urls[transfers]));
              left := left + 1;
            end if;

            let (message, messages-left) = curl-multi-info-read(multi);
            
          end while;
          
          if (left > 0)
            let numfds = curl-multi-wait(multi, timeout-ms: 1000);
            ignore(numfds);
          else
            finished? := #t;
          end;
        end while;
      end with-curl-multi;
      assert-true(#t, "Download finished");
    end with-curl-global;
  exception (err :: <error>)
    format-err("Houston, we have an error!> %s\n", as(<string>, err));
    force-out();
  end block;
end test;
