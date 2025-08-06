Module:      %lib-curl-easy
Synopsis:    Define curl's websockets API
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

// Curl ws metadata flag bits
//
// See: https://github.com/curl/curl/blob/2340a6007082674bd8e79c3ecc172c4b2a14d023/include/curl/websockets.h#L39

define constant $curlws-text       = ash(1, 0);
define constant $curlws-binary     = ash(1, 1);
define constant $curlws-cont       = ash(1, 2);
define constant $curlws-close      = ash(1, 3);
define constant $curlws-ping       = ash(1, 4);
define constant $curlws-offset     = ash(1, 5);
define constant $curlws-pong       = ash(1, 6);
define constant $curlws-raw-mode   = ash(1, 0); // (1L << 0) ??
define constant $curlws-noautopong = ash(1, 1); // (1L << 1)

// Curl WS metadata information
// See: https://github.com/curl/curl/blob/2340a6007082674bd8e79c3ecc172c4b2a14d023/include/curl/websockets.h#L31

define c-struct <curl-ws-frame>
  constant slot curl-ws-frame-age       :: <c-int>;
  constant slot curl-ws-frame-flags     :: <c-int>;
  constant slot curl-ws-frame-offset    :: <c-unsigned-long>;
  constant slot curl-ws-frame-bytesleft :: <c-unsigned-long>;
  pointer-type-name: <curl-ws-frame*>;
end c-struct;

// https://curl.se/libcurl/c/curl_ws_meta.html

define c-function curl-ws-meta
  input parameter handler :: <curl-easy-handle>;
  result meta :: <curl-ws-frame*>;
  c-name: "curl_ws_meta";
end c-function;

// https://curl.se/libcurl/c/curl_ws_recv.html

define c-function curl-ws-recv
  input  parameter handler :: <curl-easy-handle>;
  input  parameter buffer  :: <c-dylan-object>;
  input  parameter buflen  :: <c-unsigned-long>;
  output parameter recv    :: <c-unsigned-long*>;
  output parameter meta    :: <curl-ws-frame*>;
  result code :: <curl-code>;
  c-name: "curl_ws_recv";
end c-function;

//
// https://curl.se/libcurl/c/curl_ws_meta.html
// Wraps a shim function that reorder the parameters, so the output
// parameter 'sent' is the last.
//

define c-function curl-ws-send
  input  parameter handler  :: <curl-easy-handle>;
  input  parameter buffer   :: <c-dylan-object>;
  input  parameter buflen   :: <c-unsigned-long>;
  input  parameter fragsize :: <c-unsigned-long>;
  input  parameter flags    :: <c-unsigned-int>;
  output parameter sent     :: <c-unsigned-long*>;
  result code :: <curl-code>;
  c-name: "shim_curl_ws_send";
end c-function;
