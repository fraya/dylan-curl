Module:      %dylan-curl-easy
Synopsis:    Default callback functions
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

define function default-write-callback
    (data               :: <string>,
     element-size       :: <integer>,
     number-of-elements :: <integer>,
     user-data          :: <C-Dylan-object>)
  => (bytes-written :: <integer>)
  let bytes-written = element-size * number-of-elements;
  let stream = import-c-dylan-object(user-data);
  write(stream, data, end: bytes-written);
  bytes-written
end;

// Returns the number of bytes passed

// define function %null-write-callback
//     (data               :: <string>,
//      element-size       :: <integer>,
//      number-of-elements :: <integer>,
//      user-data          :: <C-Dylan-object>)
//   => (bytes-written :: <integer>)
//   element-size * number-of-elements
// end;

// Returns that everything is OK

define function %null-debug-callback
    (handle    :: <curl-easy-handle>,
     type      :: <integer>,
     data      :: <string>,
     data-size :: <integer>,
     user-data :: <C-Dylan-object>)
 => (code :: <integer>)
  0
end;

// Returns that everything is OK

define function %null-progress-callback
    (user-data       :: <C-Dylan-object>,
     download-total  :: <integer>,
     download-now    :: <integer>,
     upload-total    :: <integer>,
     upload-now      :: <integer>)
 => (status  :: <integer>)
  0
end;
