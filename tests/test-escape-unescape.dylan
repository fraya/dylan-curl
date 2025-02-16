Module:    curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.

define test test-curl-easy-escape ()
  with-curl-global ($curl-global-default)
    with-curl-easy (curl)
      let data = "data to convert";
      let expected = "data%20to%20convert";
      let output1 = curl-easy-escape(curl, data, length: 15);
      assert-equal(expected, output1);
      let output2 = curl-easy-escape(curl, data);
      assert-equal(expected, output2);
    end with-curl-easy;
  end with-curl-global;
end test;

define test test-curl-easy-unescape () 
  with-curl-global ($curl-global-default)
    with-curl-easy (curl)
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
    end with-curl-easy;
  end with-curl-global;
end test;
