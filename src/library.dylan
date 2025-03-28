Module: dylan-user

define library dylan-curl
  export
    curl-easy,
    curl-easy-impl,
    curl-multi,
    curl-multi-impl;
  
  use common-dylan;
  use c-ffi;
  use io;
end library;
