Module: dylan-user

define library curl-easy-test-suite
  use common-dylan;
  use c-ffi;
  use io;
  use strings;
  use system;
  use testworks;

  use dylan-curl,
    import: { curl-easy };
end library;

define module curl-easy-test-suite
  use byte-vector;
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

  export curl-easy-test-suite;
end module;
