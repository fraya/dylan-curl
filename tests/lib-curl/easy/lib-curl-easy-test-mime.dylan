Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
Reference: https://curl.se/libcurl/c/curl_mime_data.html

define test test-mime ()
  let mime = #f;
  block()
    with-curl-global ()
      with-curl-easy-handle (curl)
        mime := curl-mime-init(curl);
        assert-false(null-pointer?(mime));

        let part = curl-mime-addpart(mime);
        let code = curl-mime-data(part, "This is the field data");
        assert-equal($curle-ok, code);
        let code = curl-mime-name(part, "shoe_size");
        assert-equal($curle-ok, code);

        curl-easy-setopt-mimepost(curl, mime);
        curl-easy-setopt-url(curl, "https://example.org");
        let code = curl-easy-perform(curl);
        assert-equal($curle-ok, code);
      end
    end
  cleanup
    if (mime)
      curl-mime-free(mime)
    end
  exception (err :: <curl-error>)
      format-out("cainfo failed: %s\n", err.curl-error-message)
  end block;
end test;

define test test-mime-type ()
  let mime = #f;
  block()
    with-curl-global ()
      with-curl-easy-handle (curl)
        mime := curl-mime-init(curl);
        assert-false(null-pointer?(mime));

        let part = curl-mime-addpart(mime);
        assert-false(null-pointer?(part));

        let code = curl-mime-type(part, "image/png");
        assert-equal($curle-ok, code);

        let code = curl-mime-name(part, "image");
        assert-equal($curle-ok, code);
      end
    end
  cleanup
    unless (mime)
      curl-mime-free(mime)
    end
  end block;
end test;

define test test-mime-headers ()
  let mime = #f;
  let headers = null-pointer(<curl-slist*>);
  block()
    with-curl-global ()
      with-curl-easy-handle (curl)
        mime := curl-mime-init(curl);
        assert-false(null-pointer?(mime));

        let part = curl-mime-addpart(mime);
        assert-false(null-pointer?(part));

        headers := curl-slist-append(headers, "Custom header: mooo");
        assert-false(null-pointer?(headers));

        /* use these headers in the part, takes ownership */
        let code = curl-mime-headers(part, headers, 1);
      end
    end
  cleanup
    unless (mime)
      curl-mime-free(mime)
    end
  end block;
end test;

define test test-mime-filedata ()
  let mime :: false-or(<curl-mime*>) = #f;
  let part :: false-or(<curl-mimepart*>) = #f;
  block ()
    // create fake image.png
    let temp-directory = test-temp-directory();
    let image-locator = write-test-file("image.png", contents: "fake image");

    with-curl-global ()
      with-curl-easy-handle (curl)
        mime := curl-mime-init(curl);
        assert-false(null-pointer?(mime));

        part := curl-mime-addpart(mime);
        assert-false(null-pointer?(part));

        let code = curl-mime-filedata(part, as(<string>, image-locator));
        assert-equal($curle-ok, code, "Error in curl-mime-filedata");
        
        let code = curl-mime-name(part, "data");
        assert-equal($curle-ok, code, "Error curl-mime-name");
      end with-curl-easy-handle;
    end with-curl-global;
  cleanup
    unless (mime) curl-mime-free(mime) end;
  end block;
end test;