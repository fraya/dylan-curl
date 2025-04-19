Module: dylan-user

define library dylan-curl
  export
    lib-curl-easy,
    lib-curl-multi,
    dylan-curl-easy;
  
  use common-dylan;
  use c-ffi;
  use io,
    import { format; };
end library;
