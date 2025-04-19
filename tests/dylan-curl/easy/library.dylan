Module: dylan-user

define library dylan-curl-easy-test-suite
  use common-dylan;
  use c-ffi;
  use dylan-curl,
    import: { dylan-curl-easy };
  use io,
    import: { format-out };
  use testworks;
end library;

define module dylan-curl-easy-test-suite
  use common-dylan;
  use c-ffi;
  use format-out;
  use threads;
  use testworks;

  use dylan-curl-easy;

end module;
