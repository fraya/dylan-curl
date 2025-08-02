Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Reference: https://curl.se/libcurl/c/CURLSHOPT_SHARE.html

define test test-lib-curl-easy-share-share-option ()
  with-curl-global ()
    with-curl-share (share)
      share := curl-share-init();
      assert-not-equal(#f, share, "share object not initialized");
      assert-false(null-pointer?(share), "share object was not created");

      let sh = curl-share-setopt-share(share, $curl-lock-data-cookie);
      assert-equal($curlshe-ok, sh, curl-share-strerror(sh));

      let sh = curl-share-setopt-share(share, $curl-lock-data-dns);
      assert-equal($curlshe-ok, sh, curl-share-strerror(sh));

      let sh = curl-share-setopt-share(share, $curl-lock-data-ssl-session);
      assert-equal($curlshe-ok, sh, curl-share-strerror(sh));

      let sh = curl-share-setopt-share(share, $curl-lock-data-connect);
      assert-equal($curlshe-ok, sh, curl-share-strerror(sh));

      let sh = curl-share-setopt-share(share, $curl-lock-data-psl);
      assert-equal($curlshe-ok, sh, curl-share-strerror(sh));

      let sh = curl-share-setopt-share(share, $curl-lock-data-hsts);
      assert-equal($curlshe-ok, sh, curl-share-strerror(sh));
    end with-curl-share;
  end with-curl-global;
end test;

define test test-lib-curl-easy-share-lockfunc ()
  local method mutex-lock (handle, data, access, clientp)
        end;
  with-curl-global ()
    with-curl-easy-handle (curl)
      with-curl-share (share)
        let sh = curl-share-setopt-lockfunc(share, mutex-lock);
        assert-equal($curlshe-ok, sh, curl-share-strerror(sh));
      end with-curl-share;
    end with-curl-easy-handle;
  end with-curl-global;
end test;
