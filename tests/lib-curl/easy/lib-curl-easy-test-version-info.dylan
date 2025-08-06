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
    end,
    method version(version)
      concatenate("v.", if (empty?(version)) "?" else version end)
    end;

  with-curl-global ()
    let ver = curl-version-info($curlversion-now);
    format-out("\nVersion info (%s)\n", curl-version());
    format-out("host: %s\n", ver.curl-version-info-data-host);
    format-out("brotli: %s\n", version(ver.curl-version-info-data-brotli-version));
    format-out("cainfo: %s\n", version(ver.curl-version-info-data-cainfo));
    format-out("data capath: %s\n", ver.curl-version-info-data-capath);
    format-out("hyper: %s\n", version(ver.curl-version-info-data-hyper-version));
    format-out("gsasl: %s\n", version(ver.curl-version-info-data-gsasl-version));
    format-out("libs: %s\n", version(ver.curl-version-info-data-libz-version));
    format-out("libidn: %s\n", version(ver.curl-version-info-data-libidn));
    format-out("ssh: %s\n", version(ver.curl-version-info-data-libssh-version));
    format-out("nghttp2: %s\n", version(ver.curl-version-info-data-nghttp2-version));
    format-out("quic: %s\n", version(ver.curl-version-info-data-quic-version));
    format-out("ssl: %s\n", version(ver.curl-version-info-data-ssl-version));
    format-out("zstd: %s\n", version(ver.curl-version-info-data-zstd-version));
    format-out("Supported protocols:\n");
    print-slist(ver.curl-version-info-data-protocols);
    format-out("Supported features:\n");
    print-slist(ver.curl-version-info-data-feature-names);
    assert-true(#t);
  end
end test;
