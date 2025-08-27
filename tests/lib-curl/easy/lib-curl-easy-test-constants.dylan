Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Synopsis:  Test 'define enum' macro with some constants

define test test-curle-error-codes ()
  assert-equal(0, $curle-ok);
  assert-equal(10, $curle-ftp-accept-failed);
  assert-equal(19, $curle-ftp-couldnt-retr-file);
  assert-equal(21, $curle-quote-error);
  assert-equal(27, $curle-operation-timedout);
  assert-equal(30, $curle-ftp-port-failed);
  assert-equal(31, $curle-ftp-couldnt-use-rest);
  assert-equal(55, $curle-send-error);
  assert-equal(74, $curle-tftp-nosuchuser);
  assert-equal(101, $curle-ech-required);
end test;

define test test-curl-global-constants ()
  assert-equal(ash(1, 0), $curl-global-ssl);
  assert-equal(ash(1, 0), $curl-global-ssl);
  assert-equal($curl-global-default, $curl-global-all);
end test;

define test test-curl-proxy-constants ()
  assert-equal(0, $curlpx-ok);
  assert-equal(33, $curlpx-user-rejected);
end test;

define test test-curhe-error-codes ()
  assert-equal(0, $curlhe-ok);
  assert-equal(7, $curlhe-not-built-in);
end test;

define test test-curl-debug-info-types ()
  assert-equal(0, $curlinfo-text);
  assert-equal(6, $curlinfo-ssl-data-out);
end test;

define test test-curl-auth-type ()
  assert-equal(0, $curlauth-none);
  assert-equal(lognot(logior($curlauth-basic, $curlauth-digest-ie)),
               $curlauth-anysafe);
end test;

define test test-curl-ssl-backends ()
  assert-equal(0, $curlsslbackend-none);
  assert-equal(14, $curlsslbackend-rustls);
end test;

define test test-curl-easy-option-types ()
  assert-equal(0, $curlot-long);
  assert-equal(8, $curlot-function);
end test;

define test test-curl-url-error-codes ()
  assert-equal(0, $curlue-ok);
  assert-equal(31, $curlue-too-large);
end test;

define suite suite-curl-constants ()
  test test-curle-error-codes;
  test test-curl-global-constants;
  test test-curl-proxy-constants;
  test test-curhe-error-codes;
  test test-curl-debug-info-types;
  test test-curl-auth-type;
  test test-curl-ssl-backends;
  test test-curl-easy-option-types;
end suite;
