Module:     curl-easy-test-suite
Author:     Fernando Raya
Copyright:  Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:    See License.txt in this distribution for details.
Reference:  https://curl.se/libcurl/c/chkspeed.html   

define test test-chkspeed (tags: #("io", "slow"))
  local method handle-download(ptr, size, nmemb, userdata)
	  let stream = import-c-dylan-object(userdata);
	  let bytes = size * nmemb;
	  write(stream, ptr, end: bytes);
	  bytes
	end,
	method progress-callback(clientp, dltotal, dlnow, ultotal, ulnow)
	  if (dltotal > 0)
	    format-out("\rDownloading %d of %d bytes", dlnow, dltotal);
	    force-out();
	  end;
	  0
	end;
  let url = "http://ipv4.download.thinkbroadband.com";
  block () 
    with-curl-global ($curl-global-default)
      with-curl-easy (curl)
	let filename = "5MB.zip";
	curl.curl-url := concatenate(url, "/", filename);
	curl.curl-useragent := "dylan-curl-speedchecker/1.0";
	curl.curl-writefunction := $curl-write-callback;
	curl.curl-xferinfofunction := $curl-progress-callback;
	curl.curl-noprogress := 0;
	with-open-file (stream = filename, direction: #"output", if-exists: #"replace")
	  dynamic-bind(*curl-write-callback* = handle-download)
	    dynamic-bind(*curl-progress-callback* = progress-callback)
	      register-c-dylan-object(stream);
              curl.curl-writedata := export-c-dylan-object(stream);
              curl-easy-perform(curl);
              unregister-c-dylan-object(stream);
            end dynamic-bind;
          end dynamic-bind;
        end with-open-file;
        format-out("\n---\n"); force-out();
        assert-true(curl.curl-size-download-t > 0);
        if (curl.curl-size-download-t > 0)
          format-out("Data downloaded: %= bytes.\n", curl.curl-size-download-t)
        end;
        assert-true(curl.curl-total-time > 0);
        if (curl.curl-total-time-t > 0)
          format-out("Total download time: %= sec.\n", curl.curl-total-time-t / 1000000.0);
        end;
        assert-true(curl.curl-speed-download-t > 0);
        if (curl.curl-speed-download-t > 0)
          format-out("Average download speed: %= KB/sec.\n", curl.curl-speed-download-t / 1000.0);
        end;
        assert-true(curl.curl-connect-time-t > 0);
        if (curl.curl-connect-time-t > 0)
          format-out("Connect time: %= sec.\n", curl.curl-connect-time-t / 1000000.0);
        end;
        assert-true(#t);
      end with-curl-easy;
     end with-curl-global;
  exception (err :: <curl-error>)
    format-err("Error while fetching '%s' : %s\n", url, err.curl-error-message);
    assert-true(#f, "An error happend checking download speed test")
  end block;
end test;
