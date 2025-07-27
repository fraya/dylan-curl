Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
Reference: https://curl.se/libcurl/c/curl_global_trace.html

define test test-lib-curl-easy-test-global-trace ()
  local
    method debug (handle, type, data, size, clientp)
      format-out("%s\n", data);
      force-out();
      0
    end method;
  with-curl-global ()
    // log only DNS
    let code = curl-global-trace("dns");
    assert-equal($curle-ok, code);
    with-curl-easy-handle (curl)
      curl-easy-setopt-url(curl, "https://example.org");
      curl-easy-setopt-followlocation(curl, 1);
      curl-easy-setopt-verbose(curl, #t);
      curl-easy-setopt-debugfunction(curl, $curl-debug-callback);

      dynamic-bind (*curl-debug-callback* = debug)
        let code = curl-easy-perform(curl);
        assert-equal($curle-ok, code);
      end;
    end with-curl-easy-handle;
  end with-curl-global;
end test;
