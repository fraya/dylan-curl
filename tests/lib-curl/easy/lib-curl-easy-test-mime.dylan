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
        curl-easy-setopt-url(curl, "https://example.com");
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
