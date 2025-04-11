Module:    lib-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
Reference: https://curl.se/libcurl/c/curl_escape.html
Reference: https://curl.se/libcurl/c/curl_unescape.html

define test test-curl-easy-escape ()
  with-curl-global ()
    with-curl-easy-handle (curl)
      let data     = "data to convert";
      let expected = "data%20to%20convert";

      let output1  = curl-easy-escape(curl, data, data.size);
      assert-equal(expected, output1);
    end
  end
end test;

define test test-curl-easy-unescape () 
  with-curl-global ()
    with-curl-easy-handle (curl)
      let escaped  = "%63%75%72%6c";
      let expected = "curl";
      
      let (decoded, decoded-length)
	      = curl-easy-unescape(curl, escaped, escaped.size);

      assert-equal(expected, decoded,
		   "Decoded string is as expected");

      assert-equal(expected.size, decoded-length,
		   "Decoded length is as expected");

      let decoded
	      = curl-easy-unescape(curl, escaped, escaped.size);

      assert-equal(expected, decoded,
        "Unescaped is as expected");
      assert-equal(expected.size, decoded.size,
        "Unescaped size is equal as expected");

    end;
  end;
end test;
