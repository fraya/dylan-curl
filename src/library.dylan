Module: dylan-user

define library dylan-curl
  export
    lib-curl-easy,
    lib-curl-multi,
    dylan-curl-easy;
  
  use common-dylan;
  use c-ffi;
  use io,
    import { format,
             format-out,
             standard-io };
  use uncommon-dylan,
    import { uncommon-utils };
end library;
