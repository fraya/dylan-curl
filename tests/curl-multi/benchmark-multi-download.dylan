Module:     curl-multi-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Reference:  https://curl.se/libcurl/c/10-at-a-time.html
Comments:   time _build/bin/curl-multi-test-suite --tag benchmark > output.txt 2> debug.txt

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
  handle.curl-writedata     := export-c-dylan-object(stream);
  handle.curl-writefunction := $curl-write-callback;
  handle.curl-useragent     := $user-agent;
  register-C-dylan-object(stream);  // 'userdata' in 'curl-write-callback'
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

define class <downloads> (<curl-multi>)
  constant slot downloads-pending :: <deque>
    = make(<deque>);
  constant slot downloads-running :: <table>
    = make(<table>, test: \=);
end;

define method initialize
    (downloads :: <downloads>, #key maxconnects = $max-parallel)
 => (#rest objects)
  next-method();
  downloads.curl-multi-maxconnects := maxconnects;
end;

define method add-download!
    (downloads :: <downloads>, handle :: <curl-easy-download>)
 => (downloads :: <downloads>)
  push-last(downloads.downloads-pending, handle);
  downloads
end;

define method add-download!
    (downloads :: <downloads>, url :: <string>)
 => (downloads :: <downloads>)
  local method file-stream!(url)
          make(<file-stream>,
               locator: locator-name(url),
               direction: #"output",
               if-exists: #"overwrite",
               if-does-not-exist: #"create")
        end;
  add!(downloads,
       make(<curl-easy-download>,
            url: url,
            stream: file-stream!(url)))
end;

define method add-download!
    (downloads :: <downloads>, urls :: <sequence>)
 => (downloads :: <downloads>)
  apply(curry, add!, urls);
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
    downloads.downloads-running[handle.curl-private] := handle;
    curl-multi-add-handle(downloads, handle);
    prepare!(downloads, count: count - 1)
  end;
  downloads
end;

define function finished!
    (downloads :: <downloads>, url :: <string>)
 => (downloads :: <downloads>)
  let handle = downloads.downloads-handles[url];
  curl-multi-remove!(downloads, handle);
  curl-easy-cleanup(handle);
  remove-key!(downloads, url);
  downloads
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
      curl-multi-wait(downloads, timeout-ms: 1000);
    end
  end while;
end;

define benchmark benchmark-multi-download (tags: #("io", "slow"))
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
    with-curl-global ($curl-global-default)
      with-curl-multi (downloads = downloads!($max-parallel))
        add!(downloads, $urls);
        prepare!(downloads, count: $max-parallel);
        dynamic-bind(*curl-write-callback* = handle-download)
          run!(downloads);
        end;
      end;
    end;
  exception (err :: <error>)
    format-err("ERROR> %s\n", as(<string>, err));
    force-out();
  end block;
end benchmark;
