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

define inline function download!
    (url :: <string>) => (_ :: <curl-easy>)
  make(<curl-easy>,
       // verbose: #t, // shows connection details
       url: url,
       private: url)
end;

define class <downloads> (<curl-multi>)
  constant slot downloads-max-parallel :: <integer>,
    required-init-keyword: max-parallel:;
  constant slot downloads-pending :: <deque>,
    required-init-keyword: pending:;
  slot downloads-left :: <integer> = 0;
end;

define method initialize
    (downloads :: <downloads>, #key) => (#rest objects)
  next-method();
  downloads.curl-multi-maxconnects := downloads.downloads-max-parallel;
end;

define function forth!
    (downloads :: <downloads>) => ()
  let url = pop(downloads.downloads-pending);
  curl-multi-add!(downloads, download!(url));
  downloads.downloads-left := downloads.downloads-left + 1;
end;

define function prepare!
    (downloads :: <downloads>) => ()
  let n = min(downloads.downloads-max-parallel, 
              downloads.downloads-pending.size);
  for (i from 0 below n)
    forth!(downloads);
  end;
end;

define function finished!
    (downloads :: <downloads>, download :: <curl-easy>) => ()
  curl-multi-remove!(downloads, download);
  curl-easy-cleanup(download);
  downloads.downloads-left := downloads.downloads-left - 1;
end;

define function process-messages 
    (downloads :: <downloads>) => ()
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
        debug("FINISHED - %s <%s>\n", status, url);
      else
        debug("CURLMsg (%d)\n", msg.curlmsg-msg);
      end if;
      if (~empty?(downloads.downloads-pending))
        forth!(downloads)
      end if;
    end while;
  end block;
end;

define function perform!
    (downloads :: <downloads>) => ()
  while (downloads.downloads-left > 0)
    curl-multi-perform(downloads);
    process-messages(downloads);               
    if (downloads.downloads-left > 0)
      curl-multi-wait(downloads, timeout-ms: 1000);
    end;
  end while;
end;

define benchmark test-multi-chkspeed (tags: #("io", "slow"))
  local method downloads!(urls, max-parallel)
          make(<downloads>, 
                max-parallel: max-parallel,
                pending: as(<deque>, urls))
        end;
  block ()
    with-curl-global ($curl-global-default)
      with-curl-multi (downloads = downloads!($urls, $max-parallel))
        prepare!(downloads);
        perform!(downloads);
      end with-curl-multi;
    end with-curl-global;
  exception (err :: <error>)
    format-err("ERROR> %s\n", as(<string>, err));
    force-out();
  end block;
end benchmark;
