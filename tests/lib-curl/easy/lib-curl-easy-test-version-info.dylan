Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Reference: https://curl.se/libcurl/c/curl_version_info.html

define test test-lib-curl-easy-version-info ()
  local 
    method print-slist (slist)
      block (break)
        let i = 0;
        while (#t)
          let item = slist[i];
          if (null-pointer?(item)) break(#t) end;
          format-out(" - %s\n", item);
          i := i + 1;
        end;
      end block;
    end;

  with-curl-global ()
    let ver = curl-version-info($curlversion-now);
    format-out("\nVersion info\n");
    format-out("Host %s\n", ver.curl-version-info-data-host);
    format-out("SSL v.%s\n", ver.curl-version-info-data-ssl_version);
    format-out("libZ v.%s\n", ver.curl-version-info-data-libz-version);
    format-out("Supported protocols:\n");
    print-slist(ver.curl-version-info-data-protocols);
    format-out("libidn v.%s\n", ver.curl-version-info-data-libidn);
    format-out("lib SSH v.%s\n", ver.curl-version-info-data-libssh-version);
    format-out("brotli v.%s\n", ver.curl-version-info-data-brotli-version);
    format-out("nghttp2 v.%s\n", ver.curl-version-info-data-nghttp2-version);
    format-out("quic v.%s\n", ver.curl-version-info-data-quic-version);
    format-out("cainfo v.%s\n", ver.curl-version-info-data-cainfo);
    format-out("data capath %s\n", ver.curl-version-info-data-capath);
    format-out("zstd v.%s\n", ver.curl-version-info-data-zstd-version);
    format-out("hyper v.%s\n", ver.curl-version-info-data-hyper-version);
    format-out("gsasl v.%s\n", ver.curl-version-info-data-gsasl-version);
    format-out("Supported features:\n");
    print-slist(ver.curl-version-info-data-feature-names);
    assert-true(#t);
  end
end test;
