Module:     curl-multi-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Reference:  https://curl.se/libcurl/c/10-at-a-time.html
Comments:   I changed <https://www.mysql.com> for <https://www.example.com> 
            because it slows the test from 2 seconds to 2 minutes in my 
            computer. 

define constant $urls
  = #["https://www.microsoft.com",
      "https://opensource.org",
      "https://www.google.com",
      "https://www.yahoo.com",
      "https://www.ibm.com",
      // "https://www.mysql.com",
      "https://www.example.com",
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

define function debug 
    (format-string :: <string>, #rest format-args) => ()
  apply(format-err, concatenate("DEBUG> ", format-string), format-args);
  force-err();
end;

define class <downloads> (<curl-multi>)
  slot downloads-pending              :: <deque> = make(<deque>);
  constant slot downloads-in-progress :: <deque> = make(<deque>);
end;

define function next-in-progress!
    (downloads :: <downloads>) => ()
  let url = pop(downloads.downloads-pending);
  debug("In progress <%s>\n", url);
  push-last(downloads.downloads-in-progress, url);
  curl-multi-add!(downloads, make(<curl-easy>, url: url, private: url));
end;

define method finished!
    (downloads :: <downloads>, url :: <string>) => ()
  remove!(downloads.downloads-in-progress, url, test: \=);
end;

define method finished!
    (downloads :: <downloads>, download :: <curl-easy>) => ()
  curl-multi-remove!(downloads, download);
  curl-easy-cleanup(download);
end;

define function finished?
    (downloads :: <downloads>) => (_ :: <boolean>)
  empty?(downloads.downloads-in-progress)
end;

define function process-messages
  (downloads :: <downloads>) => (_ :: <boolean>)
  block (exit)
    while(#t)
      let (msg, msgs-left) = curl-multi-info-read(downloads);
      if (~msg) exit(#t) end;
      if (curlmsg-done?(msg))
        let handle   = msg.curlmsg-easy-handle;
        let download = make(<curl-easy>, handle: handle);
        let url      = download.curl-private;
        let status   = curlmsg-result(msg);
        finished!(downloads, download);
        finished!(downloads, url);
        debug("FINISHED - %s <%s>\n", status, url);
      else
        debug("CURLMsg (%d)\n", msg.curlmsg-msg);
      end if;
      if (~empty?(downloads.downloads-pending))
        next-in-progress!(downloads)
      end if;
    end while;
  end block;
end function;

define benchmark test-multi-chkspeed (tags: #("io", "slow"))
  block ()
    with-curl-global ($curl-global-default)
      with-curl-multi (downloads = make(<downloads>))
        downloads.curl-multi-maxconnects := $max-parallel;
        downloads.downloads-pending      := as(<deque>, $urls);

        let max-in-progress = min($max-parallel, $urls.size);
        for (i from 0 below max-in-progress)
          next-in-progress!(downloads);
        end;
 
        while (~finished?(downloads))
          let still-alive = curl-multi-perform(downloads);
          process-messages(downloads);               
          if (~empty?(downloads.downloads-in-progress))
            curl-multi-wait(downloads, timeout-ms: 1000);
          end;
        end while;
      end with-curl-multi;
    end with-curl-global;
  exception (err :: <error>)
    format-err("Houston, we have an error!> %s\n", err);
    force-out();
  end block;
end benchmark;
