Module: dylan-user

define library dylan-curl-easy-test-suite
  use common-dylan;
  use c-ffi;
  use dylan-curl,
    import: { dylan-curl-easy };
  use io,
    import: { format,
              format-out,
              standard-io,
              streams };
  use system,
    import: { file-system };
  use testworks;
end library;

define module dylan-curl-easy-test-suite
  use common-dylan;
  use c-ffi;
  use file-system;
  use format,
    import: { format };
  use format-out;
  use standard-io,
    import: { *standard-output* };
  use streams,
    import: { <string-stream>,
              stream-contents,
              with-output-to-string,
              write };
  use threads;
  use testworks;

  use dylan-curl-easy;

end module;
