Module: dylan-user

define library lib-curl-easy-test-suite
  export 
    lib-curl-easy-test-suite;

  use common-dylan;
  use c-ffi,
    import: { c-ffi };
  use dylan-curl,
    import: { lib-curl-easy };
  use io,
    import: { format-out,
              streams };
  use testworks,
    import: { testworks };
  use strings,
    import: { strings };
  use system,
    import: { file-system,
              operating-system };
end library;

define module lib-curl-easy-test-suite
  export
    suite-httpbin;

  use common-dylan;
  use c-ffi;
  use file-system;
  use format-out,
    import: { force-out,
              format-err,
              format-out };
  use lib-curl-easy;
  use operating-system,
    import: { environment-variable };
  use streams;
  use strings,
    import: { uppercase };
  use threads;
  use testworks;
end module;
