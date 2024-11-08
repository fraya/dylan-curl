Module: dylan-user

define library dylan-curl
  export
    curl-easy;
  
  use common-dylan;
  use c-ffi;
end library;
