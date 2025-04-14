Module:    curl-easy-test-suite
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.
Comments:  Test performed to check the double initialization of the
           library.
Todo:      It is still possible to use the library when the resources have
           been released.

define test test-global-initialization ()
  assert-false(curl-library-initialized?());
  with-curl-global($curl-global-all)
    assert-true(curl-library-initialized?());
    with-curl-global($curl-global-all)
      assert-true(curl-library-initialized?())
    end;
    assert-false(curl-library-initialized?());
    // using curl library now will produce errors
  end with-curl-global;
  assert-false(*curl-library-initialized?*);
end;
