Module:     curl-multi-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Comments:   Shared by all tests

define constant $user-agent
  = "libcurl-agent/1.0";

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

define function debug
    (format-string :: <string>, #rest format-args) => ()
  apply(format-err, concatenate("DEBUG> ", format-string), format-args);
  force-err();
end;
