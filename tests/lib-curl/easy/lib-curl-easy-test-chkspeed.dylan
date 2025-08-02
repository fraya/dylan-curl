Module:     lib-curl-easy-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Reference:  https://curl.se/libcurl/c/chkspeed.html
Reference:  https://curl.se/libcurl/c/CURLOPT_WRITEFUNCTION.html
Reference:  https://curl.se/libcurl/c/CURLOPT_XFERINFOFUNCTION.html
Reference:  https://curl.se/libcurl/c/CURLOPT_NOPROGRESS.html

define test test-chkspeed (tags: #("io", "slow"))
  local 
    method handle-download(ptr, size, nmemb, userdata)
      let stream = import-c-dylan-object(userdata);
      let bytes  = size * nmemb;
      write(stream, ptr, end: bytes);
      bytes
    end,

    method progress-callback(clientp, dltotal, dlnow, ultotal, ulnow)
      if (dltotal > 0)
        format-out("\rDownloading %d of %d bytes", dlnow, dltotal);
        force-out();
      end;
      0
    end,

    method print-download-stats(curl)
      
      format-out("\n---\n"); force-out();

      let download-bytes = curl-easy-getinfo-size-download-t(curl);
      if (download-bytes > 0)
        format-out("Data downloaded: %= bytes.\n", 
                    download-bytes)
      end;
      
      let total-time = curl-easy-getinfo-total-time-t(curl); 
      if (total-time > 0)
        format-out("Total download time: %= sec.\n", 
                    total-time / 1000000.0);
      end;
      
      let speed-download = curl-easy-getinfo-speed-download-t(curl);
      if (speed-download > 0)
        format-out("Average download speed: %= KB/sec.\n",
                    speed-download / 1000.0);
      end;
      
      let connect-time = curl-easy-getinfo-connect-time-t(curl);
      if (connect-time > 0)
        format-out("Connect time: %= sec.\n",
                    connect-time / 1000000.0);
      end;
    end method;

  let filename = "5MB.zip";
  let url-base = "http://ipv4.download.thinkbroadband.com";
  let url = concatenate(url-base, "/", filename);

  block () 
    with-curl-global ()
      with-curl-easy-handle (curl)

        curl-easy-setopt-url(curl, url);
        curl-easy-setopt-useragent(curl, "dylan-curl-speedchecker/1.0");
        curl-easy-setopt-writefunction(curl, $curl-write-callback);
        curl-easy-setopt-xferinfofunction(curl, $curl-progress-callback);
        curl-easy-setopt-noprogress(curl, #f);

        with-open-file (stream = filename, direction: #"output", if-exists: #"replace")
          register-c-dylan-object(stream);
          let exported-stream = export-c-dylan-object(stream);
          curl-easy-setopt-writedata(curl, exported-stream);
          dynamic-bind(*curl-write-callback* = handle-download,
                       *curl-progress-callback* = progress-callback)
            let curl-code = curl-easy-perform(curl);
            assert-equal($curle-ok, curl-code);
          end;
          unregister-c-dylan-object(stream);
        end with-open-file;
        print-download-stats(curl);
        assert-true(#t);
      end with-curl-easy-handle;
    end with-curl-global;
  exception (err :: <curl-error>)
    format-err("Error while fetching '%s' : %s\n", url, err.curl-error-message);
    assert-true(#f, "An error happend checking download speed test")
  end block;
end test;
