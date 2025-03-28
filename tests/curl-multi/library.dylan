Module: dylan-user

define library curl-multi-test-suite
  use common-dylan;
  use c-ffi;
  use io;
  use strings;
  use system;
  use testworks;
  use dylan-curl,
    import: { curl-easy,
              curl-multi,
              curl-multi-impl };
end library;

define module curl-multi-test-suite
  use common-dylan;
  use c-ffi;
  use file-system;
  use format-out;
  use operating-system;
  use standard-io;
  use streams;
  use strings;
  use threads;
  use testworks;

  use curl-easy;
  use curl-multi;
  use curl-multi-impl;
end module;
