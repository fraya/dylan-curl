Module:    %lib-curl-multi
Synopsis:  Curl multi constants
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.

//
// Curl multi error codes
//
// See: https://curl.se/libcurl/c/libcurl-errors.html
//

define constant $curlm-call-multi-perform    = -1;
define constant $curlm-ok                    = 0;
define constant $curlm-bad-handle            = 1;
define constant $curlm-bad-easy-handle       = 2;
define constant $curlm-out-of-memory         = 3;
define constant $curlm-internal-error        = 4;
define constant $curlm-bad-socket            = 5;
define constant $curlm-unknown-option        = 6;
define constant $curlm-added-already         = 7;
define constant $curlm-recursive-api-call    = 8;
define constant $curlm-wakeup-failure        = 9;
define constant $curlm-bad-function-argument = 10;
define constant $curlm-aborted-by-callback   = 11;
define constant $curlm-unrecoverable-poll    = 12;

//
//
// Curl message status
//
// See: https://curl.se/libcurl/c/curl_multi_info_read.html
//

define constant $curlmsg-none = 0;
define constant $curlmsg-done = 1;
