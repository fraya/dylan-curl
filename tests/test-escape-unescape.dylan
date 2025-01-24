Module:    curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.

define test test-curl-easy-escape ()
  curl-global-init($curl-global-default);
  block ()
    let curl = make(<curl-easy>);
    let data = "data to convert";
    let expected = "data%20to%20convert";
    let output1 = curl-easy-escape(curl, data, length: 15);
    assert-equal(expected, output1);
    let output2 = curl-easy-escape(curl, data);
    assert-equal(expected, output2);
  cleanup
    curl-global-cleanup();
  end block;
end test;

define test test-curl-easy-unescape ()
  curl-global-init($curl-global-default);
  block ()
    let curl = make(<curl-easy>);
    let escaped = "%63%75%72%6c";
    let expected = "curl";
    let expected-length = 4;
    let (decoded, decoded-length)
      = curl-easy-unescape(curl, escaped, length: 12);
    assert-equal(expected, decoded,
                 "Decoded string is as expected");
    assert-equal(expected-length, decoded-length,
                 "Decoded length is as expected");
    let (decoded, decoded-length)
      = curl-easy-unescape(curl, escaped);
    assert-equal(expected, decoded);
    assert-equal(expected-length, decoded-length);
  cleanup
    curl-global-cleanup();
  end block;
end test;
