Module:      %lib-curl-easy
Synopsis:    Libcurl "curl-easy" types
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

//
// <curl-easy-handle>:
//
// Curl easy handle and pointer
//

define C-subtype <curl-easy-handle> (<C-void*>)
  pointer-type-name: <curl-easy-handle*>;
end;

define C-subtype <curl-code> (<C-int>) end;

define constant <curl-offt> = <integer>;

//
// <curl-option-id>:
//
// Number that identifies a Curl option

define C-subtype <curl-option-id> (<C-int>) end;

//
// <curl-info-option-id>:
//
// Number that identifies a Curl info option
//

define C-subtype <curl-info-option-id> (<C-int>) end;


//
// <curl-blob>:
//
// Information about a memory block with binary data
//
// See: https://curl.se/libcurl/c/CURLOPT_CAINFO_BLOB.html
//

define C-struct <curl-blob>
  slot curl-blob-data  :: <C-void*>;
  slot curl-blob-len   :: <C-int>;
  slot curl-blob-flags :: <C-unsigned-int>;
  pointer-type-name: <curl-blob*>;
end C-struct;

//
// <curl-tlssessioninfo>:
//
// TLS session info.
//
// See:
//
// - https://curl.se/libcurl/c/CURLINFO_TLS_SSL_PTR.html
// - "lib-curl-easy-constants.dylan"#$curlsslbackend
//

define C-struct <curl-tlssessioninfo>
  slot curl-tlssessioninfo-backend   :: <C-int>;
  slot curl-tlssessioninfo-internals :: <C-void*>;
  pointer-type-name: <curl-tlssessioninfo*>;
end C-struct;

//
// <curl-header>:
//
// HTTP response header.
//
// See: https://curl.se/libcurl/c/curl_easy_header.html
// See: "lib-curl-easy-constants.dylan"#$curlhe
//

define C-struct <curl-header>
  constant slot curl-header-name   :: <C-string>;
  constant slot curl-header-value  :: <C-string>;
  constant slot curl-header-amount :: <C-int>;
  constant slot curl-header-index  :: <C-int>;
  constant slot curl-header-origin :: <C-unsigned-int>;
  constant slot curl-header-anchor :: <C-void*>;
  pointer-type-name: <curl-header*>;
end C-struct;

//
// <curl-slist>:
//
// Linked list of strings
//
// See:
//
// - https://curl.se/libcurl/c/curl_slist_append.html
// - https://curl.se/libcurl/c/curl_slist_free_all.html
//

define C-struct <curl-slist>
  constant slot curl-slist-data :: <C-string>;
  constant slot curl-slist-next :: <curl-slist*>;
  pointer-type-name: <curl-slist*>;
end C-struct;

//
// <curl-certinfo>:
//
// Certificate chain information
//
// See:
//
// - https://curl.se/libcurl/c/CURLOPT_CERTINFO.html
//

define C-struct <curl-certinfo>
  constant slot curl-certinfo-num-of-certs :: <C-int>;
  constant slot curl-certinfo-certinfo     :: <curl-slist*>;
  pointer-type-name: <curl-certinfo*>;
end;

//
// <curl-easy-option>:
//
// Information about the option using 'id'.
//
// See:
//
// - https://curl.se/libcurl/c/curl_easy_option_by_id.html
// - https://github.com/curl/curl/blob/280ff5ca0328bfc40968282faea6033a2cef7a92/include/curl/options.h#L1-L70
//

define C-struct <curl-easy-option>
  constant slot curl-easy-option-name  :: <C-string>;
  constant slot curl-easy-option-id    :: <C-int>;
  constant slot curl-easy-option-type  :: <C-int>; 
  constant slot curl-easy-option-flags :: <C-unsigned-int>;
  pointer-type-name: <curl-easy-option*>;
end C-struct;

//
// <curm-mimepart>
// 
// Reference:
// - https://github.com/curl/curl/blob/54ef546ec4f1a9f251674fe4501bbf98df911074/lib/mime.h#L110
//

define C-struct <curl-mimepart>
  pointer-type-name: <curl-mimepart*>;
end;

//
// <curl-mime>
//
// Reference:
// - https://github.com/curl/curl/blob/54ef546ec4f1a9f251674fe4501bbf98df911074/lib/mime.h#L101
//

define C-struct <curl-mime>
  pointer-type-name: <curl-mime*>;
end;
  
//
// <curl-boolean>:
//
// Maps the <boolean> type to <integer>, where functions interpret
// 0 as #f (false) and 1 as #t (true).
//

define C-mapped-subtype <curl-boolean> (<C-int>)
  map <boolean>,
    export-function:
    method (v :: <boolean>) => (result :: <integer>)
      as(<integer>, if(v) 1 else 0 end if)
    end,
    import-function:
    method (v :: <integer>) => (result :: <boolean>)
      ~zero?(v)
    end;
end C-mapped-subtype;

//
// Type alias to make easier the `curlopt-definer` macro,
// each one represents a type of option.
//
// See: "lib-curl-easy-macros.dylan"
//

define constant <curlopt-long>          = <integer>;
define constant <curlopt-objectpoint>   = <object>;
define constant <curlopt-functionpoint> = <object>;
define constant <curlopt-offt>          = <curl-offt>;
define constant <curlopt-blob>          = <curl-blob*>;
define constant <curlopt-stringpoint>   = <string>;
define constant <curlopt-slistpoint>    = <curl-slist*>;
define constant <curlopt-cbpoint>       = <C-Dylan-object>;
define constant <curlopt-values>        = <integer>;
define constant <curlopt-boolean>       = <boolean>;

//
// Type alias to make easier the `curlinfo-definer` macro,
// each one represents a type of information returned.
//

define constant <curlinfo-string>       = <string>;
define constant <curlinfo-long>         = <integer>;
define constant <curlinfo-double>       = <double-float>;
define constant <curlinfo-slist>        = <curl-slist*>;
define constant <curlinfo-ptr>          = <C-void*>;
// define constant <curlinfo-tlssessioninfo> = <curl-tlssessioninfo*>;
// define constant <curlinfo-certinfo> = <curl-certinfo*>;
// define constant <curlinfo-socket> =
define constant <curlinfo-offt>         = <curl-offt>;
// define constant <curlinfo-mask>
// define constant <curlinfo-typemask>
