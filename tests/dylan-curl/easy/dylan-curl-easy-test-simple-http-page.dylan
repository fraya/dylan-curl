Module:    dylan-curl-easy-test-suite
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Reference: https://curl.se/libcurl/c/simple.html

// Write http page to *standard-output*

define test dylan-curl-easy-test-simple-http-page-1 ()
  with-curl-global ()
    with-curl-easy (curl = "http://example.com", 
                    followlocation: 1)
      curl.curl-easy-perform;
      assert-equal(200, curl.curl-easy-response-code);
    end
  end
end test;

// Download http page but don't show nothing

define test dylan-curl-easy-test-simple-http-page-2 ()  
  with-curl-global ()
    with-curl-easy (curl = "http://example.com", 
                    followlocation: 1)
      curl.curl-easy-perform;
      assert-equal(200, curl.curl-easy-response-code);
    end
  end
end test;

// Read http page in a memory buffer

define test dylan-curl-easy-test-simple-http-page-3 ()
  let buffer = make(<string-stream>, direction: #"output");
  let content-length = 0;
  with-curl-global ()
    with-curl-easy (curl = "http://example.com/",
                    followlocation: 1,
                    write-data-stream: buffer)
      curl.curl-easy-perform;
      assert-equal(200, curl.curl-easy-response-code);
      content-length := curl.curl-easy-content-length-download-t;
    end;
  end;
  assert-equal(content-length, stream-contents(buffer).size)
end test;
