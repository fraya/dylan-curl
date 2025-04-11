Module:     dylan-curl-easy-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Reference:  https://curl.se/libcurl/c/chkspeed.html
Reference:  https://curl.se/libcurl/c/CURLOPT_WRITEFUNCTION.html
Reference:  https://curl.se/libcurl/c/CURLOPT_XFERINFOFUNCTION.html
Reference:  https://curl.se/libcurl/c/CURLOPT_NOPROGRESS.html

define test dylan-curl-easy-test-chkspeed (tags: #("io", "slow"))
  local 
    method show-progress(clientp, dltotal, dlnow, ultotal, ulnow)
      if (dltotal > 0)
        format-out("\rDownloading %d of %d bytes", dlnow, dltotal);
        force-out();
      end;
      0
    end,
    method print-download-stats(curl)
      format-out("\n---\n"); force-out();

      let download-bytes = curl.curl-easy-size-download-t;
      if (download-bytes > 0)
        format-out("Data downloaded: %= bytes.\n", 
                    download-bytes)
      end;
      
      let total-time = curl.curl-easy-total-time-t; 
      if (total-time > 0)
        format-out("Total download time: %= sec.\n", 
                    total-time / 1000000.0);
      end;
      
      let speed-download = curl.curl-easy-speed-download-t;
      if (speed-download > 0)
        format-out("Average download speed: %= KB/sec.\n",
                    speed-download / 1000.0);
      end;
      
      let connect-time = curl.curl-easy-connect-time-t;
      if (connect-time > 0)
        format-out("Connect time: %= sec.\n",
                    connect-time / 1000000.0);
      end;
    end method;

  let filename = "5MB.zip";
  let url-base = "http://ipv4.download.thinkbroadband.com";
  let url = concatenate(url-base, "/", filename);

  with-open-file (stream = filename, direction: #"output", if-exists: #"replace")
    with-curl-global ()
      with-curl-easy (curl = url,
                      useragent: "dylan-curl-speedchecker/1.0",
                      progress-callback: show-progress,
                      noprogress: #f,
                      write-data-stream: stream)
        assert-no-errors(curl.curl-easy-perform);
        print-download-stats(curl);
      end;
    end;
  end;
end test;
