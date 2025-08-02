Module:      %lib-curl-easy
Synopsis:    Libcurl "curl-easy" constants bindings
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

///////////////////////////////////////////////////////////////////////////////
//
//  TOC: Table of contents
//  ----------------------
//
//  - $curle: Curl error codes                   {C-s $curle: RET}
//  - $curl-global: Global initialization        {C-s $curl-global: RET}
//  - $curlpx: Proxy error codes                 {C-s $curlpx: RET}
//  - $curlhe: Header error codes                {C-s $curlhe: RET}
//  - $curlinfo: Debug callback function         {C-s $curlinfo: RET}
//  - $curlauth: Types of authentication methods {C-s $curlauth: RET}
//  - $curlpause: Bitmasks to pause a connection {C-s $curlpause: RET}
//  - $curlsslbackend: SSL backends              {C-s $curlsslbackend: RET}
//  - $curlopttyp: Curl option types ids         {C-s $curlopttype: RET}
//  - $curlot: Curl easy option type             {C-s $curlot: RET}
//  - $curlupart: Curl URL part                  {C-s $curlupart: RET}
//
///////////////////////////////////////////////////////////////////////////////

// 
// $curle: Curl error codes.
//
// See: https://curl.se/libcurl/c/libcurl-errors.html
//
// {C-r TOC: RET}
//

define constant $curle-ok                       = 0;
define constant $curle-unsupported-protocol     = 1;
define constant $curle-failed-init              = 2;
define constant $curle-url-malformat            = 3;
define constant $curle-not-built-in             = 4;
define constant $curle-couldnt-resolve-proxy    = 5;
define constant $curle-couldnt-resolve-host     = 6;
define constant $curle-couldnt-connect          = 7;
define constant $curle-weird-server-reply       = 8;
define constant $curle-remote-access-denied     = 9;
define constant $curle-ftp-accept-failed        = 10;
define constant $curle-ftp-weird-pass-reply     = 11;
define constant $curle-ftp-accept-timeout       = 12;
define constant $curle-ftp-weird-pasv-reply     = 13;
define constant $curle-ftp-weird-227-reply      = 14;
define constant $curle-ftp-cant-get-host        = 15;
define constant $curle-http2                    = 16;
define constant $curle-ftp-couldnt-set-type     = 17;
define constant $curle-partial-file             = 18;
define constant $curle-ftp-couldnt-retr-file    = 19;
// Obsolete 20
define constant $curle-quote-error              = 21;
define constant $curle-http-returned_error      = 22;
define constant $curle-write-error              = 23;
// Obsolete 24 
define constant $curle-upload-failed            = 25;
define constant $curle-read-error               = 26;
define constant $curle-out-of-memory            = 27;
define constant $curle-operation-timedout       = 28;
// Obsolete 29
define constant $curle-ftp-port-failed          = 30;
define constant $curle-ftp-couldnt-use-rest     = 31;
// Obsolete 32
define constant $curle-range-error              = 33;
define constant $curle-http-post-error          = 34;
define constant $curle-ssl-connect-error        = 35;
define constant $curle-bad-download-resume      = 36;
define constant $curle-file-couldnt-read-file   = 37;
define constant $curle-ldap-cannot-bind         = 38;
define constant $curle-ldap-search-failed       = 39;
// Obsolete 40 
define constant $curle-function-not-found       = 41;
define constant $curle-aborted-by-callback      = 42;
define constant $curle-bad-function-argument    = 43;
// Obsolete 44
define constant $curle-interface-failed         = 45;
// Obsolete 46
define constant $curle-too-many-redirects       = 47;
define constant $curle-unknown-option           = 48;
define constant $curle-setopt-option-syntax     = 49;
// Obsolete 50
// Obsolete 51 
define constant $curle-got-nothing              = 52;
define constant $curle-ssl-engine-notfound      = 53;
define constant $curle-ssl-engine-setfailed     = 54;
define constant $curle-send-error               = 55;
define constant $curle-recv-error               = 56;
// Obsolete 57
define constant $curle-ssl-certproblem          = 58;
define constant $curle-ssl-cypher               = 59;
define constant $curle-peer-failed-verification = 60;
define constant $curle-bad-content-encoding     = 61;
// Obsolete 62
define constant $curle-filesize-exceeded        = 63;
define constant $curle-use-ssl-failed           = 64;
define constant $curle-send-fail-rewind         = 65;
define constant $curle-ssl-engine-initfailed    = 66;
define constant $curle-login-denied             = 67;
define constant $curle-tftp-notfound            = 68;
define constant $curle-tftp-perm                = 69;
define constant $curle-remote-disk-full         = 70;
define constant $curle-tftp-illegal             = 71;
define constant $curle-tftp-unknownid           = 72;
define constant $curle-remote-file-exists       = 73;
define constant $curle-tftp-nosuchuser          = 74;
// Obsolete 75
// Obsolete 76
define constant $curle-ssl-cacert-badfile       = 77;
define constant $curle-remote-file-not-found    = 78;
define constant $curle-ssh                      = 79;
define constant $curle-ssl-shutdown-failed      = 80;
define constant $curle-again                    = 81;
define constant $curle-ssl-crl-badfile          = 82;
define constant $curle-ssl-issuer-error         = 83;
define constant $curle-ftp-pret-failed          = 84;
define constant $curle-rtsp-cseq-error          = 85;
define constant $curle-rtsp-session-error       = 86;
define constant $curle-ftp-bad-file-list        = 87;
define constant $curle-chunk-failed             = 88;
define constant $curle-no-connection-available  = 89;
define constant $curle-ssl-pinnedpubkeynotmatch = 90;
define constant $curle-ssl-invalidcertstatus    = 91;
define constant $curle-http2-stream             = 92;
define constant $curle-recursive-api-call       = 93;
define constant $curle-auth-error               = 94;
define constant $curle-http3                    = 95;
define constant $curle-quic-connect-error       = 96;
define constant $curle-proxy                    = 97;
define constant $curle-ssl-clientcert           = 98;
define constant $curle-unrecoverable-poll       = 99;
define constant $curle-too-large                = 100;
define constant $curle-ech-required             = 101;

//
// $curl-global: Used in `curl-global-init` function.
//
// See: https://curl.se/libcurl/c/curl_global_init.html
//
// {C-r TOC: RET}
//

define constant $curl-global-ssl       = ash(1, 0);
define constant $curl-global-win32     = ash(1, 1);
define constant $curl-global-all       = logior($curl-global-ssl, $curl-global-win32);
define constant $curl-global-nothing   = 0;
define constant $curl-global-default   = $curl-global-all;
define constant $curl-global-ack-eintr = ash(1, 2);

//
// $curlpx: Proxy errors.
//
// Constants used for get a detailed (SOCKS) proxy error.
// Returned by `curl-easy-getinfo-proxy-error` function.
//
// See: https://curl.se/libcurl/c/CURLINFO_PROXY_ERROR.html
//
// {C-r TOC: RET}
//

define constant $curlpx-ok                               = 0;
define constant $curlpx-bad-address-type                 = 1;
define constant $curlpx-bad-version                      = 2;
define constant $curlpx-closed                           = 3;
define constant $curlpx-gssapi                           = 4;
define constant $curlpx-gssapi-permsg                    = 5;
define constant $curlpx-gssapi-protection                = 6;
define constant $curlpx-identd                           = 7;
define constant $curlpx-identd-differ                    = 8;
define constant $curlpx-long-hostname                    = 9;
define constant $curlpx-long-passwd                      = 10;
define constant $curlpx-long-user                        = 11;
define constant $curlpx-no-auth                          = 12;
define constant $curlpx-recv-address                     = 13;
define constant $curlpx-recv-auth                        = 14;
define constant $curlpx-recv-connect                     = 15;
define constant $curlpx-recv-reqack                      = 16;
define constant $curlpx-reply-address-type-not-supported = 17;
define constant $curlpx-reply-command-not-supported      = 18;
define constant $curlpx-reply-connection-refused         = 19;
define constant $curlpx-reply-general-server-failure     = 20;
define constant $curlpx-reply-host-unreacheable          = 21;
define constant $curlpx-reply-network-unreachable        = 22;
define constant $curlpx-reply-not-allowed                = 23;
define constant $curlpx-reply-ttl-expired                = 24;
define constant $curlpx-reply-unassigned                 = 25;
define constant $curlpx-request-failed                   = 26;
define constant $curlpx-resolve-host                     = 27;
define constant $curlpx-send-auth                        = 28;
define constant $curlpx-send-connect                     = 29;
define constant $curlpx-send-request                     = 30;
define constant $curlpx-unknown-fail                     = 31;
define constant $curlpx-unknown-mode                     = 32;
define constant $curlpx-user-rejected                    = 33;

//
// $curlhe: Curl header error codes
//
// See: https://curl.se/libcurl/c/libcurl-errors.html#CURLHcode
//
// {C-r TOC: RET}
//

define constant $curlhe-ok            = 0;
define constant $curlhe-badindex      = 1;
define constant $curlhe-missing       = 2;
define constant $curlhe-noheaders     = 3;
define constant $curlhe-norequest     = 4;
define constant $curlhe-out-of-memory = 5;
define constant $curlhe-bad-argument  = 6;
define constant $curlhe-not-built-in  = 7;

//
// $curlinfo: Information types passed to a debug callback.
//
// See: https://curl.se/libcurl/c/CURLOPT_DEBUGFUNCTION.html
//
// {C-r TOC: RET}
//

define constant $curlinfo-text         = 0;
define constant $curlinfo-header-in    = 1;
define constant $curlinfo-header-out   = 2;
define constant $curlinfo-data-in      = 3;
define constant $curlinfo-data-out     = 4;
define constant $curlinfo-ssl-data-in  = 5;
define constant $curlinfo-ssl-data-out = 6;

//
// $curlauth: Types of authentication methods
//
// See: https://curl.se/libcurl/c/CURLOPT_HTTPAUTH.html
//
// {C-r TOC: RET}
//

define constant $curlauth-none         = 0;
define constant $curlauth-basic        = ash(1, 0);
define constant $curlauth-digest       = ash(1, 1);
define constant $curlauth-negotiate    = ash(1, 2);
define constant $curlauth-gssnegotiate = $curlauth-negotiate;
define constant $curlauth-gssapi       = $curlauth-negotiate;
define constant $curlauth-ntlm         = ash(1, 3);
define constant $curlauth-digest-ie    = ash(1, 4);
define constant $curlauth-ntlm-wb      = ash(1, 5);
define constant $curlauth-bearer       = ash(1, 6);
define constant $curlauth-aws-sigv4    = ash(1, 7);
define constant $curlauth-only         = ash(1, 31);
define constant $curlauth-any          = lognot($curlauth-digest-ie);
define constant $curlauth-anysafe      = lognot(logior($curlauth-basic, $curlauth-digest-ie));

//
// $curlpause: Bitmask constants to mark a running connection to get
// paused.
//
// See: https://curl.se/libcurl/c/curl_easy_pause.html
//
// {C-r TOC: RET}
//

define constant $curlpause-recv      = ash(1, 0);
define constant $curlpause-recv-cont = 0;
define constant $curlpause-send      = ash(1, 2);
define constant $curlpause-send-cont = 0;
define constant $curlpause-all       = logior($curlpause-recv, $curlpause-send);
define constant $curlpause-cont      = logior($curlpause-recv-cont, $curlpause-send-cont);

//
// $curlsslbackend: Different supported SSL backends
//
// https://github.com/curl/curl/blob/b3752d502e1ce2f92d2d52a7223f83d66c5a708b/include/curl/curl.h#L153
//
// {C-r TOC: RET}
//

define constant $curlsslbackend-none            = 0;
define constant $curlsslbackend-openssl         = 1;
define constant $curlsslbackend-gnutls          = 2;
define constant $curlsslbackend-nss             = 3;
define constant $curlsslbackend-obsolete4       = 4;
define constant $curlsslbackend-gskit           = 5;
define constant $curlsslbackend-polarssl        = 6;
define constant $curlsslbackend-wolfssl         = 7;
define constant $curlsslbackend-schannel        = 8;
define constant $curlsslbackend-securetransport = 9;
define constant $curlsslbackend-axtls           = 10;
define constant $curlsslbackend-mbedtls         = 11;
define constant $curlsslbackend-mesalink        = 12;
define constant $curlsslbackend-bearssl         = 13;
define constant $curlsslbackend-rustls          = 14;

//
// $curlopttype: Curl option types identifiers
//
// Curl option type constants are assigned a unique identifier based on a
// type-specific base index. Each constant's value is calculated by
// adding its unique offset to this base index.
//
// See: 
//
// - https://github.com/curl/curl/blob/878bc429f26c27294787dc59d7b53345d9edc5aa/include/curl/curl.h#L1079
//
// {C-r TOC: RET}
// 

define constant $curlopttype-long          = 0;
define constant $curlopttype-objectpoint   = 10000;
define constant $curlopttype-functionpoint = 20000;
define constant $curlopttype-offt          = 30000;
define constant $curlopttype-blob          = 40000;
define constant $curlopttype-stringpoint   = $curlopttype-objectpoint;
define constant $curlopttype-slistpoint    = $curlopttype-objectpoint;
define constant $curlopttype-cbpoint       = $curlopttype-objectpoint;
define constant $curlopttype-values        = $curlopttype-long;
define constant $curlopttype-boolean       = $curlopttype-long;

//
// $curlot: Curl option type
//
// See:
//
// - https://curl.se/libcurl/c/curl_easy_option_next.html
//

define constant $curlot-long     = 0;
define constant $curlot-values   = 1;
define constant $curlot-offt     = 2;
define constant $curlot-object   = 3;
define constant $curlot-string   = 4;
define constant $curlot-slist    = 5;
define constant $curlot-cbptr    = 6;
define constant $curlot-blob     = 7;
define constant $curlot-function = 8;

//
// $curlinfo:
//
// The following constants are assigned a unique identifier based on a
// type-specific base index. Each `curlinfo` constant's value is calculated
// by adding its unique offset to this base index.
//
// Reference: 
//
// - https://github.com/curl/curl/blob/1da198d18e495c08adb5691459da0b5fcfc7f160/include/curl/curl.h#L2859
//

define constant $curlinfo-string   = #x100000;
define constant $curlinfo-long     = #x200000;
define constant $curlinfo-double   = #x300000;
define constant $curlinfo-slist    = #x400000;
define constant $curlinfo-ptr      = #x400000; // same as slist
define constant $curlinfo-socket   = #x500000; ignore($curlinfo-socket);
define constant $curlinfo-offt     = #x600000;
define constant $curlinfo-mask     = #x0fffff; ignore($curlinfo-mask);
define constant $curlinfo-typemask = #xf00000; ignore($curlinfo-typemask);

//
// Curlucode
// The URL interface returns a CURLUcode to indicate when an error has occurred.
//
// Reference:
//
// - https://curl.se/libcurl/c/libcurl-errors.html
//

define constant $curlue-ok                 = 0;
define constant $curlue-bad-handle         = 1;
define constant $curlue-bad-partpointer    = 2;
define constant $curlue-malformed-input    = 3;
define constant $curlue-bad-port-number    = 4;
define constant $curlue-unsupported-scheme = 5;
define constant $curlue-urldecode          = 6;
define constant $curlue-out-of-memory      = 7;
define constant $curlue-user-not-allowed   = 8;
define constant $curlue-unknown-part       = 9;
define constant $curlue-no-scheme          = 10;
define constant $curlue-no-user            = 11;
define constant $curlue-no-password        = 12;
define constant $curlue-no-options         = 13;
define constant $curlue-no-host            = 14;
define constant $curlue-no-port            = 15;
define constant $curlue-no-query           = 16;
define constant $curlue-no-fragment        = 17;
define constant $curlue-no-zoneid          = 18;
define constant $curlue-bad-file-url       = 19;
define constant $curlue-bad-fragment       = 20;
define constant $curlue-bad-hostname       = 21;
define constant $curlue-bad-ipv6           = 22;
define constant $curlue-bad-login          = 23;
define constant $curlue-bad-password       = 24;
define constant $curlue-bad-path           = 25;
define constant $curlue-bad-query          = 26;
define constant $curlue-bad-scheme         = 27;
define constant $curlue-bad-slashes        = 28;
define constant $curlue-bad-user           = 29;
define constant $curlue-lacks-idn          = 30;
define constant $curlue-too-large          = 31;

//
// CURLUPart
//
// Reference:
//
// - https://github.com/curl/curl/blob/9e3492690b8d15a81f029516ae7e06a2de5863b9/include/curl/urlapi.h#L70C1-L82C13
//

define constant $curlupart-url      = 0;
define constant $curlupart-scheme   = 1;
define constant $curlupart-user     = 2;
define constant $curlupart-password = 3;
define constant $curlupart-options  = 4;
define constant $curlupart-host     = 5;
define constant $curlupart-port     = 6;
define constant $curlupart-path     = 7;
define constant $curlupart-query    = 8;
define constant $curlupart-fragment = 9;
define constant $curlupart-zoneid   = 10;

// Curl version 
// https://github.com/curl/curl/blob/69642330a3673364ba873fc1aabab5e85fa8da79/include/curl/curl.h#L3085

define constant $curlversion-first    = 0;  // 7.10 
define constant $curlversion-second   = 1;  // 7.11.1 
define constant $curlversion-third    = 2;  // 7.12.0
define constant $curlversion-fourth   = 3;  // 7.16.1
define constant $curlversion-fifth    = 4;  // 7.57.0
define constant $curlversion-sixth    = 5;  // 7.66.0
define constant $curlversion-seventh  = 6;  // 7.70.0
define constant $curlversion-eighth   = 7;  // 7.72.0
define constant $curlversion-ninth    = 8;  // 7.75.0
define constant $curlversion-tenth    = 9;  // 7.77.0
define constant $curlversion-eleventh = 10; // 7.87.0
define constant $curlversion-twelfth  = 11; // 8.8.0 

// https://github.com/curl/curl/blob/69642330a3673364ba873fc1aabab5e85fa8da79/include/curl/curl.h#L3101
define constant $curlversion-now = $curlversion-twelfth;

