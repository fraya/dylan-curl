Module: dylan-user

define library lib-curl-easy-test-suite
  use common-dylan;
  use c-ffi;
  use dylan-curl,
    import: { lib-curl-easy };
  use io,
    import: { format-out };
  use testworks;
end library;

define module lib-curl-easy-test-suite
  use common-dylan;
  use c-ffi;
  use format-out;
  use testworks;

  use lib-curl-easy;

end module;
