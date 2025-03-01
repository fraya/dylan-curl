Module: dylan-user

define library dylan-curl
  export
    curl-easy,
    curl-easy-impl;
  
  use common-dylan;
  use c-ffi;
end library;
