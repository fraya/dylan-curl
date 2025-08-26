Module:      %lib-curl-easy
Synopsis:    Callback functions
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.
Summary:     The callback functions that libcurl calls at various points
             during a transfer to let your program handle
             things like data reception, headers, progress reporting,
             and debugging.

//
// Callback variables
//
// Example of use:
//
// local
//   method write-cb (data, size-t, bytes, user-data)
//     size-t * bytes
//   end;
//
// dynamic-bind(*curl-write-callback* = write-cb)
//  ...
// end
//
define thread variable *curl-write-callback*    :: <function> = ignore;
define thread variable *curl-header-callback*   :: <function> = ignore;
define thread variable *curl-debug-callback*    :: <function> = ignore;
define thread variable *curl-progress-callback* :: <function> = ignore;

//
// curl-write-callback:
//
// Called to write the data received.
//
// Note: Must return size-t * bytes
//
define function curl-write-callback
    (data        :: <string>,         // data received
     size-t      :: <integer>,        // always 1
     bytes       :: <integer>,        // data size
     user-data   :: <C-Dylan-object>) // object passed in `writedata`
  => (bytes-written :: <integer>)
    *curl-write-callback*(data, size-t, bytes, user-data)
end;

//
// curl-header-callback:
//
// Call on each received header
//
define function curl-header-callback
    (buffer    :: <C-void*>,         // delivered data
     size-t    :: <integer>,         // always 1
     bytes     :: <integer>,         // size of the data
     user-data :: <C-Dylan-object>)  // object passed in 'writedata'
  => (bytes-written :: <integer>)
    *curl-header-callback*(buffer, size-t, bytes, user-data)
end;

define function curl-debug-callback
    (handle    :: <curl-easy-handle>, // handle doing the request
     type      :: <integer>,          // kind of information (<curl-info-*>)
     data      :: <string>,           // actual debug message string
     data-size :: <integer>,          // data size in bytes
     user-data :: <C-Dylan-object>)   // Set in curl-setopt-debugdata
  => (code :: <integer>)
    *curl-debug-callback*(handle, type, data, data-size, user-data)
end;

//
// curl-progress-callback:
//
// Progress meter callback
//
// See: https://curl.se/libcurl/c/CURLOPT_XFERINFOFUNCTION.html
// See: https://curl.se/libcurl/c/CURLOPT_NOPROGRESS.html
//
//

define function curl-progress-callback
    (user-data       :: <C-Dylan-object>, // pointer to xferinfodata
     download-total  :: <integer>,        // bytes
     download-now    :: <integer>,        // downloaded bytes already
     upload-total    :: <integer>,        // bytes
     upload-now      :: <integer>)        // number of bytes uploaded already
  => (status  :: <integer>)
    *curl-progress-callback*(user-data,
                             download-total,
                             download-now,
                             upload-total,
                             upload-now)
end;

//
// Callable wrappers:
//

define C-callable-wrapper $curl-write-callback of curl-write-callback
  input parameter data      :: <C-string>;
  input parameter size-t    :: <C-int>;
  input parameter bytes     :: <C-int>;
  input parameter user-data :: <C-Dylan-object>;
  result bytes-written :: <C-int>;
end C-callable-wrapper;

define C-callable-wrapper $curl-header-callback of curl-header-callback
  input parameter buffer    :: <C-void*>;
  input parameter size-t    :: <C-int>;
  input parameter bytes     :: <C-int>;
  input parameter user-data :: <C-Dylan-object>;
  result bytes-written :: <C-int>;
end C-callable-wrapper;

define C-callable-wrapper $curl-debug-callback of curl-debug-callback
  input parameter handle    :: <curl-easy-handle>;
  input parameter type      :: <C-int>;
  input parameter data      :: <C-string>;
  input parameter data-size :: <C-int>;
  input parameter user-data :: <C-Dylan-object>;
  result code :: <C-int>;
end C-callable-wrapper;

define C-callable-wrapper $curl-progress-callback of curl-progress-callback
  input parameter clientp :: <C-dylan-object>;
  input parameter dltotal :: <C-unsigned-long>;
  input parameter dlnow   :: <C-unsigned-long>;
  input parameter ultotal :: <C-int>;
  input parameter ulnow   :: <C-int>;
  result status :: <C-int>;
end C-callable-wrapper;

// Curl mime callbacks

define thread variable *curl-read-callback* :: <function> = ignore;
define thread variable *curl-seek-callback* :: <function> = ignore;
define thread variable *curl-free-callback* :: <function> = ignore;

define function curl-read-callback
    (buffer       :: <string>,
     buffer-size  :: <integer>,
     number-items :: <integer>,
     arg          :: <object>)
 => (bytes-read   :: <integer>)
  let bytes-read = *curl-read-callback*(buffer, buffer-size, number-items, arg);
  // if cb function is set to ignore, bytes-read is #f so return 0 to stop read
  bytes-read | 0
end;

define function curl-seek-callback
    (arg    :: <object>,
     offset :: <integer>,
     origin :: <integer>)
 => (seek-status :: <integer>)
  *curl-seek-callback*(arg, offset, origin)
end;

define function curl-free-callback
    (arg :: <object>)
 => ()
  *curl-free-callback*(arg)
end;

define C-callable-wrapper $curl-read-callback of curl-read-callback
  input parameter buffer       :: <C-string>;
  input parameter buffer-size  :: <C-int>;
  input parameter number-items :: <C-int>;
  input parameter arg          :: <C-Dylan-object>;
  result bytes-read :: <C-int>;
end C-callable-wrapper;

define C-callable-wrapper $curl-seek-callback of curl-seek-callback
  input parameter arg    :: <C-Dylan-object>;
  input parameter offset :: <C-size-t>;
  input parameter origin :: <C-int>;
  result seek-status :: <C-int>;
end C-callable-wrapper;

define C-callable-wrapper $curl-free-callback of curl-free-callback
  input parameter arg :: <C-Dylan-object>;
end C-callable-wrapper;
