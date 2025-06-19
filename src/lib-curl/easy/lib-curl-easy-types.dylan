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

//
// URL interface
//

define C-struct <curlu>
  pointer-type-name: <curlu*>;
end;

// https://github.com/curl/curl/blob/69642330a3673364ba873fc1aabab5e85fa8da79/include/curl/curl.h#L3108

define C-struct <curl-version-info-data> 
  constant slot curl-version-info-data-age             :: <C-int>;
  constant slot curl-version-info-data-version         :: <C-string>;
  constant slot curl-version-info-data-version-num     :: <C-int>;     /* LIBCURL_VERSION_NUM */
  constant slot curl-version-info-data-host            :: <C-string>;  /* OS/host/cpu/machine when configured */
  constant slot curl-version-info-data-features        :: <C-int>;     /* bitmask, see defines below */
  constant slot curl-version-info-data-ssl_version     :: <C-string>;  /* human readable string */
  constant slot curl-version-info-data-ssl-version-num :: <C-long>;    /* not used anymore, always 0 */
  constant slot curl-version-info-data-libz-version    :: <C-string>;  /* human readable string */
   /* protocols is terminated by an entry with a NULL protoname */
  constant slot curl-version-info-data-protocols       :: <C-string*>; 
  /* The fields below this were added in CURLVERSION_SECOND */
  constant slot curl-version-info-data-ares            :: <C-string>;
  constant slot curl-version-info-data-ares-num        :: <C-int>;

  /* This field was added in CURLVERSION_THIRD */
  constant slot curl-version-info-data-libidn          :: <C-string>;

  /* These field were added in CURLVERSION_FOURTH */

  /* Same as '_libiconv_version' if built with HAVE_ICONV */
  constant slot curl-version-info-data-iconv-ver-num   :: <C-int>;
  constant slot curl-version-info-data-libssh-version  :: <C-string>; /* human readable string */

  /* These fields were added in CURLVERSION_FIFTH */
  /* Numeric Brotli version (MAJOR << 24) | (MINOR << 12) | PATCH */
  constant slot curl-version-info-data-brotli-ver-num  :: <C-int>;    
  constant slot curl-version-info-data-brotli-version  :: <C-string>; /* human readable string. */

  /* These fields were added in CURLVERSION_SIXTH */
  /* Numeric nghttp2 version (MAJOR << 16) | (MINOR << 8) | PATCH */
  constant slot curl-version-info-data-nghtp2-ver-num  :: <C-int>;    
  constant slot curl-version-info-data-nghttp2-version :: <C-string>; /* human readable string. */
  /* human readable quic (+ HTTP/3) library + version or NULL */
  constant slot curl-version-info-data-quic-version    :: <C-string>;      

  /* These fields were added in CURLVERSION_SEVENTH */
  /* the built-in default CURLOPT_CAINFO, might be NULL */
  constant slot curl-version-info-data-cainfo          :: <C-string>; 
  /* the built-in default CURLOPT_CAPATH, might be NULL */        
  constant slot curl-version-info-data-capath          :: <C-string>;          

  /* These fields were added in CURLVERSION_EIGHTH */
  /* Numeric Zstd version (MAJOR << 24) | (MINOR << 12) | PATCH */
  constant slot curl-version-info-data-zstd-ver-num    :: <C-int>; 
  constant slot curl-version-info-data-zstd-version    :: <C-string>; /* human readable string. */

  /* These fields were added in CURLVERSION_NINTH */
  constant slot curl-version-info-data-hyper-version   :: <C-string>; /* human readable string. */

  /* These fields were added in CURLVERSION_TENTH */
  constant slot curl-version-info-data-gsasl-version   :: <C-string>; /* human readable string. */

  /* These fields were added in CURLVERSION_ELEVENTH */
  /* feature_names is terminated by an entry with a NULL feature name */
  constant slot curl-version-info-data-feature-names   :: <C-string*>;

  /* These fields were added in CURLVERSION_TWELFTH */
  constant slot curl-version-info-data-rtmp-version    :: <C-string>; /* human readable string. */

  pointer-type-name: <curl-version-info-data*>;
end C-struct;