Module:      %lib-curl-easy
Synopsis:    Libcurl "curl-easy" function bindings
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.
Reference:   https://curl.se/libcurl/c/allfuncs.html

// https://curl.se/libcurl/c/curl_easy_cleanup.html

define C-function curl-easy-cleanup
  input parameter handle :: <curl-easy-handle>;
  c-name: "curl_easy_cleanup";
end C-function;

// https://curl.se/libcurl/c/curl_easy_duphandle.html

define C-function curl-easy-duphandle
  input parameter handle :: <curl-easy-handle>;
  result dup             :: <curl-easy-handle>;
  c-name: "curl_easy_duphandle";
end C-function;

// https://curl.se/libcurl/c/curl_easy_escape.html

define C-function curl-easy-escape
  input parameter handle :: <curl-easy-handle>;
  input parameter url    :: <C-string>;
  input parameter length :: <C-int>;
  result value           :: <C-string>;
  c-name: "curl_easy_escape";
end C-function;

// https://curl.se/libcurl/c/curl_easy_header.html
// https://everything.curl.dev/helpers/headerapi/struct.html

define C-function curl-easy-header
  input parameter handle  :: <curl-easy-handle>;
  input parameter name    :: <C-string>;
  input parameter index   :: <C-int>;
  input parameter origin  :: <C-unsigned-int>;
  input parameter request :: <C-int>;
  output parameter hout   :: <curl-header*>;
  result curlhe-code      :: <C-int>;
  c-name: "curl_easy_header";
end C-function;

// https://curl.se/libcurl/c/curl_easy_init.html

define C-function curl-easy-init
  result curl-easy :: <curl-easy-handle>;
  c-name: "curl_easy_init";
end C-function;

// https://curl.se/libcurl/c/curl_easy_nextheader.html

define C-function curl-easy-next-header
  input parameter handle  :: <curl-easy-handle>;
  input parameter origin  :: <C-unsigned-int>;
  input parameter request :: <C-int>;
  input parameter prev    :: <curl-header*>;
  result next-header      :: <curl-header*>;
  c-name: "curl_easy_nextheader";
end C-function;

// https://curl.se/libcurl/c/curl_easy_option_by_id.html

define C-function curl-easy-option-by-id
  input parameter id :: <curl-option-id>;
  result curl-option :: <curl-easy-option*>;
  c-name: "curl_easy_option_by_id";
end C-function;

// https://curl.se/libcurl/c/curl_easy_option_by_name.html

define C-function curl-easy-option-by-name
  input parameter name :: <C-string>;
  result curl-option   :: <curl-easy-option*>;
  c-name: "curl_easy_option_by_name";
end C-function;

// https://curl.se/libcurl/c/curl_easy_option_next.html

define C-function curl-easy-option-next
  input parameter prev :: <curl-easy-option*>;
  result next-option   :: <curl-easy-option*>;
  c-name: "curl_easy_option_next";
end C-function;

// https://curl.se/libcurl/c/curl_easy_pause.html

define C-function curl-easy-pause
  input parameter handle  :: <curl-easy-handle>;
  input parameter bitmask :: <C-int>;
  result curl-code        :: <curl-code>;
  c-name: "curl_easy_pause";
end C-function;

// https://curl.se/libcurl/c/curl_easy_perform.html

define C-function curl-easy-perform
  input parameter handle :: <curl-easy-handle>;
  result curl-code       :: <curl-code>;
  c-name: "curl_easy_perform";
end C-function;


// NOT IMPLEMENTED: Problem with input output parameter
// https://curl.se/libcurl/c/curl_easy_recv.html

// define C-function curl-easy-recv
//   input parameter handle :: <curl-easy-handle>;
//   input output parameter buffer :: <C-void*>;
//   input parameter buflen :: <C-int>;
//   output parameter n :: <C-int*>;
//   result status :: <C-int>;
//   c-name: "curl_easy_recv_shim";
// end C-function;

// https://curl.se/libcurl/c/curl_easy_perform.html

define C-function curl-easy-reset
  input parameter handle :: <curl-easy-handle>;
  c-name: "curl_easy_reset";
end C-function;

// https://curl.se/libcurl/c/curl_easy_send.html

define C-function curl-easy-send
  input  parameter handle :: <curl-easy-handle>;
  input  parameter buffer :: <C-void*>;
  input  parameter buflen :: <C-int>;
  output parameter n      :: <C-int*>;
  result curl-code        :: <curl-code>;
  c-name: "curl_easy_send";
end C-function;

// https://curl.se/libcurl/c/curl_easy_strerror.html

define C-function curl-easy-strerror
  input parameter error-number :: <curl-code>;
  result error-message         :: <C-string>;
  c-name: "curl_easy_strerror";
end C-function;

// https://curl.se/libcurl/c/curl_easy_unescape.html

define C-function curl-easy-unescape
  input  parameter handle        :: <curl-easy-handle>;
  input  parameter input-string  :: <C-string>;
  input  parameter input-length  :: <C-int>;
  output parameter output-length :: <C-int*>;
  result value                   :: <C-string>;
  c-name: "curl_easy_unescape";
end C-function;

// https://curl.se/libcurl/c/curl_easy_upkeep.html

define C-function curl-easy-upkeep
  input parameter handle :: <curl-easy-handle>;
  result curl-code       :: <curl-code>;
  c-name: "curl_easy_upkeep";
end C-function;

// https://curl.se/libcurl/c/curl_free.html

define C-function curl-free
  input parameter ptr :: <C-void*>;
  c-name: "curl_free";
end C-function;

//  https://curl.se/libcurl/c/curl_getdate.html

define C-function curl-getdate
  input  parameter datestring :: <C-string>;
  output parameter now        :: <C-int*>;
  result seconds              :: <C-int>;
  c-name: "curl_getdate";
end C-function;

// https://curl.se/libcurl/c/curl_getenv.html

define C-function curl-getenv
  input parameter name :: <C-string>;
  result env           :: <C-string>;
  c-name: "curl_getenv";
end C-function;

// https://curl.se/libcurl/c/curl_global_init.html

define C-function curl-global-init
  input parameter flags :: <C-int>;
  result curl-code      :: <curl-code>;
  c-name: "curl_global_init";
end C-function;

// TODO: curl-global-init-mem needed???

// TODO: curl-global-sslset needed??

// https://curl.se/libcurl/c/curl_mime_addpart.html

define C-function curl-mime-addpart
  input parameter mime :: <curl-mime*>;
  result part :: <curl-mimepart*>;
  c-name: "curl_mime_addpart";
end C-function;

// https://curl.se/libcurl/c/curl_mime_data.html

define C-function curl-mime-data
  input parameter part      :: <curl-mimepart*>;
  input parameter data      :: <C-string>;
  // parameter data-size is ignored, meaning that the size
  // of the string 'data' is used
  result code :: <curl-code>;
  c-name: "curl_mime_data";
end C-function;

// https://curl.se/libcurl/c/curl_global_trace.html

// NOTE: only from version 8.3
// define C-function curl-global-trace
//   input parameter config :: <C-string>;
//   result curl-code :: <C-int>;
//   c-name: "curl_global_trace";
// end C-function;

// https://curl.se/libcurl/c/curl_global_cleanup.html

define C-function curl-global-cleanup
  c-name: "curl_global_cleanup";
end C-function;

// https://curl.se/libcurl/c/curl_mime_filename.html

define C-function curl-mime-filename
  input parameter part :: <curl-mimepart*>;
  input parameter filename :: <C-string>;
  result curl-code :: <curl-code>;
  c-name: "curl_mime_filename";
end;

// https://curl.se/libcurl/c/curl_mime_free.html

define C-function curl-mime-free
  input parameter mime :: <curl-mime*>;
  c-name: "curl_mime_free";
end;

// https://curl.se/libcurl/c/curl_mime_init.html

define C-function curl-mime-init
  input parameter handle :: <curl-easy-handle>;
  result curl-mime :: <curl-mime*>;
  c-name: "curl_mime_init";
end;

// https://curl.se/libcurl/c/curl_mime_name.html

define C-function curl-mime-name
  input parameter part :: <curl-mimepart*>;
  input parameter name :: <C-string>;
  result curl-code :: <curl-code>;
  c-name: "curl_mime_name";
end;

// https://curl.se/libcurl/c/curl_slist_append.html

define C-function curl-slist-append
  input parameter slist  :: <curl-slist*>;
  input parameter string :: <C-string>;
  result new-slist       :: <curl-slist*>;
  c-name: "curl_slist_append";
end C-function;

// https://curl.se/libcurl/c/curl_slist_free_all.html

define C-function curl-slist-free-all
  input parameter slist :: <curl-slist*>;
  c-name: "curl_slist_free_all";
end C-function;

// https://curl.se/libcurl/c/curl_version.html

define C-function curl-version
  result version :: <C-string>;
  c-name: "curl_version";
end C-function;
