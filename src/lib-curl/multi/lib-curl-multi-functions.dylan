Module:    %lib-curl-multi
Synopsis:  Curl multi functions
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.

// https://curl.se/libcurl/c/curl_multi_init.html

define C-function curl-multi-init
  result multi :: <curl-multi-handle>;
  c-name: "curl_multi_init";
end C-function;

// https://curl.se/libcurl/c/curl_multi_cleanup.html

define C-function curl-multi-cleanup
   input parameter multi :: <curl-multi-handle>;
   result curlm-code     :: <curlm-code>;
   c-name: "curl_multi_cleanup";
end C-function;

// https://curl.se/libcurl/c/curl_multi_strerror.html

define C-function curl-multi-strerror
  input parameter err-num :: <curlm-code>;
  result message          :: <C-string>;
  c-name: "curl_multi_strerror";
end C-function;

// https://curl.se/libcurl/c/curl_multi_add_handle.html

define C-function curl-multi-add-handle
  input parameter multi :: <curl-multi-handle>;
  input parameter easy  :: <curl-easy-handle>;
  result curlm-code     :: <curlm-code>;
  c-name: "curl_multi_add_handle";
end C-function;

// https://curl.se/libcurl/c/curl_multi_remove_handle.html

define C-function curl-multi-remove-handle
  input parameter multi :: <curl-multi-handle>;
  input parameter easy  :: <curl-easy-handle>;
  result curlm-code     :: <curlm-code>;
  c-name: "curl_multi_remove_handle";
end C-function;

// https://curl.se/libcurl/c/curl_multi_get_handles.html

define C-function curl-multi-get-handles
  input parameter multi :: <curl-multi-handle>;
  result handles        :: <curl-easy-handle*>;
  c-name: "curl_multi_get_handles";
end C-function;

// https://curl.se/libcurl/c/curl_multi_info_read.html

define C-function curl-multi-info-read
  input  parameter multi-handle  :: <curl-multi-handle>;
  output parameter msgs-in-queue :: <C-int*>;
  result curl-msg                :: <curlmsg*>;
  c-name: "curl_multi_info_read";
end C-function;

// https://curl.se/libcurl/c/curl_multi_perform.html

define C-function curl-multi-perform
  input  parameter multi-handle    :: <curl-multi-handle>;
  output parameter running-handles :: <C-int*>;
  result curlmcode                 :: <curlm-code>;
  c-name: "curl_multi_perform";
end C-function;

define C-function curl-multi-poll
  input  parameter multi-handle :: <curl-multi-handle>;
  input  parameter extra-fds    :: <curl-waitfd*>;
  input  parameter extra-nfds   :: <C-unsigned-int>;
  input  parameter timeout-ms   :: <C-int>;
  output parameter numfds       :: <C-int*>;
  result curlmcode              :: <curlm-code>;
  c-name: "curl_multi_poll";
end C-function;

define C-function curl-multi-wait
  input  parameter multi-handle :: <curl-multi-handle>;
  input  parameter extra-fds    :: <curl-waitfd*>;
  input  parameter extra-nfds   :: <C-unsigned-int>;
  input  parameter timeout-ms   :: <C-int>;
  output parameter numfds       :: <C-int*>;
  result curlmcode              :: <curlm-code>;
  c-name: "curl_multi_wait";
end C-function;
