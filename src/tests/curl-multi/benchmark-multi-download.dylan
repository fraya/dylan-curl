Module:     curl-multi-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Reference:  https://curl.se/libcurl/c/10-at-a-time.html
Comments:   time _build/bin/curl-multi-test-suite --tag benchmark > output.txt 2> debug.txt

define constant $user-agent
  = "libcurl-agent/1.0";

define constant $wait-timeout-ms
  = 1000;

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
      "https://www.fujitsu.com",
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
      "https://www.nbc.com",
      "https://slashdot.org",
      "https://www.informationweek.com",
      "https://apache.org",
      "https://www.un.org"];

define function debug
    (format-string :: <string>, #rest format-args) => ()
  apply(format-err, concatenate("DEBUG> ", format-string), format-args);
  force-err();
end;

define function c-string-to-string
    (c :: <C-string>) => (s :: <string>)
  let s = make(<string>, size: c.size, fill: ' ');
  for (i from 0 below c.size) s[i] := c[i] end;
  s
end;

define constant $max-parallel = 10;

//////////////////////////////////////////////////////////////////////////////
//
// <curl-easy-download>
//
//////////////////////////////////////////////////////////////////////////////

define class <curl-easy-download> (<curl-easy>)
  constant slot curl-stream :: <stream> = *standard-output*,
    init-keyword: stream:;
end;

define method initialize
    (handle :: <curl-easy-download>, #key url :: <string>, stream :: <stream>)
 => (handle :: <curl-easy-download>)
  next-method();
  handle.curl-private       := url;
  handle.curl-useragent     := $user-agent;
  handle.curl-writefunction := $curl-write-callback;
  // register object must be done before curl-writedata ??
  register-C-dylan-object(stream);  // 'userdata' in 'curl-write-callback'
  handle.curl-writedata     := export-c-dylan-object(stream);
  handle;
end;

define method curl-easy-cleanup
    (handle :: <curl-easy-download>) => ()
  next-method();
  unregister-C-dylan-object(handle.curl-stream);
  close(handle.curl-stream);
end;

//////////////////////////////////////////////////////////////////////////////
//
// <downloads>
//
//////////////////////////////////////////////////////////////////////////////

define class <downloads> (<curl-multi>, <deque>)
  constant slot downloads-pending :: <deque>
    = make(<deque>);
  constant slot downloads-running :: <table>
    = make(<case-insensitive-string-table>);
end;

define method initialize
    (downloads :: <downloads>, #key maxconnects = $max-parallel)
 => (#rest objects)
  next-method();
  downloads.curl-multi-maxconnects := maxconnects;
end;

define generic add-download!
  (downloads :: <downloads>, object :: <object>) => (_ :: <downloads>);

define method add-download!
    (downloads :: <downloads>, handle :: <curl-easy-download>)
 => (downloads :: <downloads>)
  push-last(downloads.downloads-pending, handle);
  downloads
end;

define method add-download!
    (downloads :: <downloads>, url :: <string>)
 => (downloads :: <downloads>)
  local
    method url-as-filename(url)
      let url-loc  = as(<https-server>, url);
      concatenate(url-loc.locator-host, ".html")
    end,
    method file-stream!(url)
          make(<file-stream>,
               locator: url-as-filename(url),
               direction: #"output",
               if-exists: #"overwrite")
    end,
    method easy-download(url)
      make(<curl-easy-download>,
           url: url,
           stream: file-stream!(url))
    end;
  add-download!(downloads, easy-download(url))
end;

define method add-download!
    (downloads :: <downloads>, urls :: <sequence>)
 => (downloads :: <downloads>)
  for (url in urls)
    add-download!(downloads, url)
  end;
  downloads
end;

define function finished?
    (downloads :: <downloads>) => (_ :: <boolean>)
  downloads.downloads-pending.size.zero? &
  downloads.downloads-running.size.zero?
end;

define function prepare!
   (downloads :: <downloads>, #key count = 1)
=> (downloads :: <downloads>)
  if (count > 0 & ~empty?(downloads.downloads-pending))
    let handle = pop(downloads.downloads-pending);
    let url    = c-string-to-string(handle.curl-private);
    downloads.downloads-running[url] := handle;
    curl-multi-add!(downloads, handle);
    prepare!(downloads, count: count - 1)
  end;
  downloads
end;

define function finished!
    (downloads :: <downloads>, url :: <string>)
 => (downloads :: <downloads>)
  debug("finished! %=\n", url);
  let kurl = c-string-to-string(url);
  let handle = downloads.downloads-running[kurl];
  remove-key!(downloads.downloads-running, kurl);
  curl-multi-remove!(downloads, handle);
  curl-easy-cleanup(handle);
  downloads
end;

define function process-messages
    (downloads :: <downloads>) => ()
  debug("Processing messages\n");
  block (exit)
    while(#t)
      let (msg, msgs-left) = curl-multi-info-read(downloads);
      if (~msg) exit(#t) end;
      if (curlmsg-done?(msg))
        let handle   = msg.curlmsg-easy-handle;
        let download = make(<curl-easy>, handle: handle);
        let url      = download.curl-private;
        let status   = curlmsg-result(msg);
        finished!(downloads, url);
        debug("FINISHED - %s <%s>\n", status, url);
      else
        debug("CURLMsg (%d)\n", msg.curlmsg-msg);
      end if;
      prepare!(downloads);
    end while;
  end block;
end;

define function run!
    (downloads :: <downloads>) => ()
  while (~finished?(downloads))
    curl-multi-perform(downloads);
    process-messages(downloads);
    if (downloads.downloads-running.size > 0)
      curl-multi-wait(downloads, timeout-ms: $wait-timeout-ms);
    end
  end while;
end;

define test benchmark-multi-download (tags: #("io", "slow"))
  local method downloads!(parallel)
          make(<downloads>,
               maxconnect: parallel)
        end,
        method handle-download(ptr, size, nmemb, userdata)
          let stream = import-c-dylan-object(userdata);
          let bytes = size * nmemb;
          write(stream, ptr, end: bytes);
          bytes
       end;

  block ()
    debug("Benchmark multi download\n");
    with-curl-global ($curl-global-default)
      with-curl-multi (downloads = downloads!($max-parallel))
        assert-true(downloads.downloads-pending.size.zero?);
        add-download!(downloads, $urls);
        debug("%d URLs loaded\n", $urls.size);
        assert-equal($urls.size, downloads.downloads-pending.size);
        debug("Preparing %d downloads\n", $max-parallel);
        prepare!(downloads, count: $max-parallel);
        assert-equal($max-parallel, downloads.downloads-running.size);
        debug("Run!\n");
        dynamic-bind(*curl-write-callback* = handle-download)
          run!(downloads);
        end;
      end;
    end;
  exception (err :: <error>)
    format-err("ERROR> %s\n", as(<string>, err));
    force-out();
  end block;
end test;
