Module:      %lib-curl-easy
Synopsis:    Define curl's share options and functions to set them. 
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.
Reference:   https://curl.se/libcurl/c/curl_share_setopt.html
Reference:   https://github.com/curl/curl/blob/a7e6c78bfa3e4edcb3c0dcd105d2edc73d9e8b09/include/curl/curl.h#L3074
Comments:    See "lib-curl-easy-macros.dylan"

//
// CURLSHE
//
// Curl shared error codes.
//
// Reference:
//
// https://github.com/curl/curl/blob/a7e6c78bfa3e4edcb3c0dcd105d2edc73d9e8b09/include/curl/curl.h#L3064
//

define constant $curlshe-ok           = 0;
define constant $curlshe-bad-option   = 1;
define constant $curlshe-in-use       = 2;
define constant $curlshe-invalid      = 3;
define constant $curlshe-nomem        = 4;
define constant $curlshe-not-built-in = 5;

// Curl lock data constants
// https://github.com/curl/curl/blob/902262b16605bb8d92ee2002d498d81c2776fe5e/include/curl/curl.h#L3031

// $curl-lock-data-none = 0;
define constant $curl-lock-data-share       = 1; // undocumented
define constant $curl-lock-data-cookie      = 2;
define constant $curl-lock-data-dns         = 3;
define constant $curl-lock-data-ssl-session = 4;
define constant $curl-lock-data-connect     = 5;
define constant $curl-lock-data-psl         = 6;
define constant $curl-lock-data-hsts        = 7;

// Curl lock access (different lock access types)
// https://github.com/curl/curl/blob/902262b16605bb8d92ee2002d498d81c2776fe5e/include/curl/curl.h#L3047

// $curl-lock-access-none = 0;
define constant $curl-lock-access-shared = 1;
define constant $curl-lock-access-single = 2;

define class <curl-share-error> (<curl-error>)
end;

define method curl-error-message
    (err :: <curl-share-error>) => (message :: <string>)
  curl-share-strerror(err.curl-error-code)
end;

define class <curl-share-init-error> (<curl-share-error>)
  inherited slot curl-error-code = -1;
end;

define method curl-error-message
    (err :: <curl-share-init-error>) => (message :: <string>)
  "curl-share-init could not create the share object"
end;

define macro with-curl-share
  { with-curl-share (?share:variable) ?body:body end }
    => { let ?share = #f;
         block ()
           ?share := curl-share-init();
           if (null-pointer?(?share))
             error(make(<curl-share-init-error>))
           end;
           ?body
         cleanup
           if (?share)
             let sh = curl-share-cleanup(?share);
             if (sh ~= $curlshe-ok)
               error(make(<curl-share-error>, code: sh))
             end;
           end if;
         end block }
end macro;

//////////////////////////////////////////////////////////////////////////////
//
// `shim-curl-share-setopt-definer`
//
// Create a "shim" function for each `$curl-share-setopt-xxx` constant to
// streamline the process of working with the variadic function
// `curl_share_setopt`.
//
// Example:
//
// define shim-curl-share-setopt callback;
//
// .. generates ..
//
// define C-function shim-curl-share-setopt-callback
//   input parameter share  :: <curlsh*>;
//   input parameter option :: <curlsh-option>;
//   input parameter value  :: <curlsh-callback>;
//   result code :: <curlsh-code>;
//   c-name: "curl_share_setopt_callback";
// end C-function;
//
//////////////////////////////////////////////////////////////////////////////

define macro shim-curl-share-setopt-definer
  { define shim-curl-share-setopt ?:name :: ?type:name }
    => { define C-function "shim-curl-share-setopt-" ## ?name
           input parameter share  :: <curlsh*>;
           input parameter option :: <c-int>;
           input parameter value  :: ?type;
           result code :: <c-int>;
           c-name: "curl_share_setopt_" ?"name";
         end C-function; }
end macro;


/**

  The `curlsh-option-definer` creates a function that sets the share
  option value calling the corresponding shim function.

  define curlsh-option <option-type> <option-name> = <option-id>

  Example:

  define curlsh-option callback lockfunc :: <object> = 3;

  .. generates ..

  define function curl-share-setopt-lockfunc
      (share :: <curlsh*>, value :: <object>) => (code  :: <integer>)
    shim-curl-share-setopt-callback(share, 3, value)
  end;

*/

define macro curlsh-option-definer
  { define curlsh-option ?shim:name ?:name :: ?type:name = ?number:expression }
    => { define function "curl-share-setopt-" ## ?name
             (share :: <curlsh*>, value :: ?type) => (code :: <integer>)
          "shim-curl-share-setopt-" ## ?shim (share, ?number, value)
         end; }
end macro;

// Define C-ffi functions by option parameter type

define shim-curl-share-setopt callback :: <c-void*>;
define shim-curl-share-setopt long     :: <c-long>;
define shim-curl-share-setopt clientp  :: <c-dylan-object>;

// Define curl's shared options by shim, name, value type and constant value

define curlsh-option long share          :: <integer>        = 1;
define curlsh-option long unshare        :: <integer>        = 2;
define curlsh-option callback lockfunc   :: <object>         = 3;
define curlsh-option callback unlockfunc :: <object>         = 4;
define curlsh-option clientp userdata    :: <c-dylan-object> = 5;
