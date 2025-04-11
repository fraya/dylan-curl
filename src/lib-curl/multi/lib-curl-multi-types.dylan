Module:    %lib-curl-multi
Synopsis:  Curl multi API
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.

define C-subtype <curl-multi-handle> (<C-void*>) end;

define C-subtype <curlm-code> (<C-int>) end;

define C-union <curlmsg-data>
  constant slot curlmsg-data-whatever :: <C-void*>;  // message-specific data
  constant slot curlmsg-data-result   :: <C-int>;    // return code for transfer
end;

define C-struct <curlmsg>
  constant slot curlmsg-msg              :: <C-int>;
  constant slot curlmsg-curl-easy-handle :: <curl-easy-handle>;
  constant slot curlmsg-data             :: <curlmsg-data>;
  pointer-type-name: <curlmsg*>; 
end C-struct;

//
// <curl-waitfd>
//
//
// TODO: curl-waitfd-fd is 'curl_socket_t' type
//

define C-struct <curl-waitfd>
  constant slot curl-waitfd-fd      :: <C-void*>;
  constant slot curl-waitfd-events  :: <C-unsigned-short>;
  constant slot curl-waitfd-revents :: <C-unsigned-short>;
  pointer-type-name: <curl-waitfd*>;
end C-struct;
