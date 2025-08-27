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

define enum curle-error-codes ()
  $curle-ok = 0;
  $curle-unsupported-protocol;
  $curle-failed-init;
  $curle-url-malformat;
  $curle-not-built-in;
  $curle-couldnt-resolve-proxy;
  $curle-couldnt-resolve-host;
  $curle-couldnt-connect;
  $curle-weird-server-reply;
  $curle-remote-access-denied;
  $curle-ftp-accept-failed;
  $curle-ftp-weird-pass-reply;
  $curle-ftp-accept-timeout;
  $curle-ftp-weird-pasv-reply;
  $curle-ftp-weird-227-reply;
  $curle-ftp-cant-get-host;
  $curle-http2;
  $curle-ftp-couldnt-set-type;
  $curle-partial-file;
  $curle-ftp-couldnt-retr-file;
  // Obsolete 20
  $curle-quote-error = 21;
  $curle-http-returned_error;
  $curle-write-error;
  $curle-upload-failed;
  $curle-read-error;
  $curle-out-of-memory;
  $curle-operation-timedout;
  // Obsolete 29
  $curle-ftp-port-failed = 30;
  $curle-ftp-couldnt-use-rest;
  // Obsolete 32
  $curle-range-error = 33;
  $curle-http-post-error;
  $curle-ssl-connect-error;
  $curle-bad-download-resume;
  $curle-file-couldnt-read-file;
  $curle-ldap-cannot-bind;
  $curle-ldap-search-failed;
  // Obsolete 40
  $curle-function-not-found = 41;
  $curle-aborted-by-callback;
  $curle-bad-function-argument;
  // Obsolete 44
  $curle-interface-failed = 45;
  // Obsolete 46
  $curle-too-many-redirects = 47;
  $curle-unknown-option;
  $curle-setopt-option-syntax;
  // Obsolete 50
  // Obsolete 51
  $curle-got-nothing = 52;
  $curle-ssl-engine-notfound;
  $curle-ssl-engine-setfailed;
  $curle-send-error;
  $curle-recv-error;
  // Obsolete 57
  $curle-ssl-certproblem = 58;
  $curle-ssl-cypher;
  $curle-peer-failed-verification;
  $curle-bad-content-encoding;
  // Obsolete 62
  $curle-filesize-exceeded = 63;
  $curle-use-ssl-failed;
  $curle-send-fail-rewind;
  $curle-ssl-engine-initfailed;
  $curle-login-denied;
  $curle-tftp-notfound;
  $curle-tftp-perm;
  $curle-remote-disk-full;
  $curle-tftp-illegal;
  $curle-tftp-unknownid;
  $curle-remote-file-exists;
  $curle-tftp-nosuchuser;
  // Obsolete 75
  // Obsolete 76
  $curle-ssl-cacert-badfile = 77;
  $curle-remote-file-not-found;
  $curle-ssh;
  $curle-ssl-shutdown-failed;
  $curle-again;
  $curle-ssl-crl-badfile;
  $curle-ssl-issuer-error;
  $curle-ftp-pret-failed;
  $curle-rtsp-cseq-error;
  $curle-rtsp-session-error;
  $curle-ftp-bad-file-list;
  $curle-chunk-failed;
  $curle-no-connection-available;
  $curle-ssl-pinnedpubkeynotmatch;
  $curle-ssl-invalidcertstatus;
  $curle-http2-stream;
  $curle-recursive-api-call;
  $curle-auth-error;
  $curle-http3;
  $curle-quic-connect-error;
  $curle-proxy;
  $curle-ssl-clientcert;
  $curle-unrecoverable-poll;
  $curle-too-large;
  $curle-ech-required;
end enum curle-error-codes;

//
// $curl-global: Used in `curl-global-init` function.
//
// See: https://curl.se/libcurl/c/curl_global_init.html
//
// {C-r TOC: RET}
//

define enum curl-global-constants ()
  $curl-global-ssl       = ash(1, 0);
  $curl-global-win32     = ash(1, 1);
  $curl-global-all       = logior($curl-global-ssl, $curl-global-win32);
  $curl-global-nothing   = 0;
  $curl-global-default   = $curl-global-all;
  $curl-global-ack-eintr = ash(1, 2);
end enum;

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

define enum curl-proxy-error-codes ()
  $curlpx-ok = 0;
  $curlpx-bad-address-type;
  $curlpx-bad-version;
  $curlpx-closed;
  $curlpx-gssapi;
  $curlpx-gssapi-permsg;
  $curlpx-gssapi-protection;
  $curlpx-identd;
  $curlpx-identd-differ;
  $curlpx-long-hostname;
  $curlpx-long-passwd;
  $curlpx-long-user;
  $curlpx-no-auth;
  $curlpx-recv-address;
  $curlpx-recv-auth;
  $curlpx-recv-connect;
  $curlpx-recv-reqack;
  $curlpx-reply-address-type-not-supported;
  $curlpx-reply-command-not-supported;
  $curlpx-reply-connection-refused;
  $curlpx-reply-general-server-failure;
  $curlpx-reply-host-unreacheable;
  $curlpx-reply-network-unreachable;
  $curlpx-reply-not-allowed;
  $curlpx-reply-ttl-expired;
  $curlpx-reply-unassigned;
  $curlpx-request-failed;
  $curlpx-resolve-host;
  $curlpx-send-auth;
  $curlpx-send-connect;
  $curlpx-send-request;
  $curlpx-unknown-fail;
  $curlpx-unknown-mode;
  $curlpx-user-rejected;
end enum curl-proxy-error-codes;

//
// $curlhe: Curl header error codes
//
// See: https://curl.se/libcurl/c/libcurl-errors.html#CURLHcode
//
// {C-r TOC: RET}
//

define enum curl-header-error-codes ()
  $curlhe-ok = 0;
  $curlhe-badindex;
  $curlhe-missing;
  $curlhe-noheaders;
  $curlhe-norequest;
  $curlhe-out-of-memory;
  $curlhe-bad-argument;
  $curlhe-not-built-in;
end enum;

//
// $curlinfo: Information types passed to a debug callback.
//
// See: https://curl.se/libcurl/c/CURLOPT_DEBUGFUNCTION.html
//
// {C-r TOC: RET}
//

define enum curl-debug-info-types ()
  $curlinfo-text = 0;
  $curlinfo-header-in;
  $curlinfo-header-out;
  $curlinfo-data-in;
  $curlinfo-data-out;
  $curlinfo-ssl-data-in;
  $curlinfo-ssl-data-out;
end enum;

//
// $curlauth: Types of authentication methods
//
// See: https://curl.se/libcurl/c/CURLOPT_HTTPAUTH.html
//
// {C-r TOC: RET}
//

define enum curl-auth-type ()
  $curlauth-none         = 0;
  $curlauth-basic        = ash(1, 0);
  $curlauth-digest       = ash(1, 1);
  $curlauth-negotiate    = ash(1, 2);
  $curlauth-gssnegotiate = $curlauth-negotiate;
  $curlauth-gssapi       = $curlauth-negotiate;
  $curlauth-ntlm         = ash(1, 3);
  $curlauth-digest-ie    = ash(1, 4);
  $curlauth-ntlm-wb      = ash(1, 5);
  $curlauth-bearer       = ash(1, 6);
  $curlauth-aws-sigv4    = ash(1, 7);
  $curlauth-only         = ash(1, 31);
  $curlauth-any          = lognot($curlauth-digest-ie);
  $curlauth-anysafe      = lognot(logior($curlauth-basic, $curlauth-digest-ie));
end enum;

//
// $curlpause: Bitmask constants to mark a running connection to get
// paused.
//
// See: https://curl.se/libcurl/c/curl_easy_pause.html
//
// {C-r TOC: RET}
//

define enum curlpause-constants ()
  $curlpause-recv      = ash(1, 0);
  $curlpause-recv-cont = 0;
  $curlpause-send      = ash(1, 2);
  $curlpause-send-cont = 0;
  $curlpause-all       = logior($curlpause-recv, $curlpause-send);
  $curlpause-cont      = logior($curlpause-recv-cont, $curlpause-send-cont);
end enum;

//
// $curlsslbackend: Different supported SSL backends
//
// https://github.com/curl/curl/blob/b3752d502e1ce2f92d2d52a7223f83d66c5a708b/include/curl/curl.h#L153
//
// {C-r TOC: RET}
//

define enum curl-ssl-backends ()
  $curlsslbackend-none = 0;
  $curlsslbackend-openssl;
  $curlsslbackend-gnutls;
  $curlsslbackend-nss;
  $curlsslbackend-obsolete4;
  $curlsslbackend-gskit;
  $curlsslbackend-polarssl;
  $curlsslbackend-wolfssl;
  $curlsslbackend-schannel;
  $curlsslbackend-securetransport;
  $curlsslbackend-axtls;
  $curlsslbackend-mbedtls;
  $curlsslbackend-mesalink;
  $curlsslbackend-bearssl;
  $curlsslbackend-rustls;
end enum;

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

define enum curl-option-types ()
  $curlopttype-long          = 0;
  $curlopttype-objectpoint   = 10000;
  $curlopttype-functionpoint = 20000;
  $curlopttype-offt          = 30000;
  $curlopttype-blob          = 40000;
  $curlopttype-stringpoint   = $curlopttype-objectpoint;
  $curlopttype-slistpoint    = $curlopttype-objectpoint;
  $curlopttype-cbpoint       = $curlopttype-objectpoint;
  $curlopttype-values        = $curlopttype-long;
  $curlopttype-boolean       = $curlopttype-long;
end enum;

//
// $curlot: Curl option type
//
// See:
//
// - https://curl.se/libcurl/c/curl_easy_option_next.html
//

define enum curl-easy-option-types ()
  $curlot-long = 0;
  $curlot-values;
  $curlot-offt;
  $curlot-object;
  $curlot-string;
  $curlot-slist;
  $curlot-cbptr;
  $curlot-blob;
  $curlot-function;
end enum;

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

define enum curl-info-types ()
  $curlinfo-string   = #x100000;
  $curlinfo-long     = #x200000;
  $curlinfo-double   = #x300000;
  $curlinfo-slist    = #x400000;
  $curlinfo-ptr      = #x400000; // same as slist
  $curlinfo-socket   = #x500000;
  $curlinfo-offt     = #x600000;
  $curlinfo-mask     = #x0fffff; 
  $curlinfo-typemask = #xf00000; 
end enum;

// Not used yet

ignore($curlinfo-socket);
ignore($curlinfo-mask);
ignore($curlinfo-typemask);

//
// Curlucode
// The URL interface returns a CURLUcode to indicate when an error has occurred.
//
// Reference:
//
// - https://curl.se/libcurl/c/libcurl-errors.html
//

define enum curl-url-error-codes ()
  $curlue-ok = 0;
  $curlue-bad-handle;
  $curlue-bad-partpointer;
  $curlue-malformed-input;
  $curlue-bad-port-number;
  $curlue-unsupported-scheme;
  $curlue-urldecode;
  $curlue-out-of-memory;
  $curlue-user-not-allowed;
  $curlue-unknown-part;
  $curlue-no-scheme;
  $curlue-no-user;
  $curlue-no-password;
  $curlue-no-options;
  $curlue-no-host;
  $curlue-no-port;
  $curlue-no-query;
  $curlue-no-fragment;
  $curlue-no-zoneid;
  $curlue-bad-file-url;
  $curlue-bad-fragment;
  $curlue-bad-hostname;
  $curlue-bad-ipv6;
  $curlue-bad-login;
  $curlue-bad-password;
  $curlue-bad-path;
  $curlue-bad-query;
  $curlue-bad-scheme;
  $curlue-bad-slashes;
  $curlue-bad-user;
  $curlue-lacks-idn;
  $curlue-too-large;
end enum;

//
// CURLUPart
//
// Reference:
//
// - https://github.com/curl/curl/blob/9e3492690b8d15a81f029516ae7e06a2de5863b9/include/curl/urlapi.h#L70C1-L82C13
//

define enum curl-upart ()
  $curlupart-url = 0;
  $curlupart-scheme;
  $curlupart-user;
  $curlupart-password;
  $curlupart-options;
  $curlupart-host;
  $curlupart-port;
  $curlupart-path;
  $curlupart-query;
  $curlupart-fragment;
  $curlupart-zoneid;
end enum;

// Curl version 
// https://github.com/curl/curl/blob/69642330a3673364ba873fc1aabab5e85fa8da79/include/curl/curl.h#L3085
// https://github.com/curl/curl/blob/69642330a3673364ba873fc1aabab5e85fa8da79/include/curl/curl.h#L3101

define enum curlversion ()
  $curlversion-first = 0; // 7.10 
  $curlversion-second;    // 7.11.1 
  $curlversion-third;     // 7.12.0
  $curlversion-fourth;    // 7.16.1
  $curlversion-fifth;     // 7.57.0
  $curlversion-sixth;     // 7.66.0
  $curlversion-seventh;   // 7.70.0
  $curlversion-eighth;    // 7.72.0
  $curlversion-ninth;     // 7.75.0
  $curlversion-tenth;     // 7.77.0
  $curlversion-eleventh;  // 7.87.0
  $curlversion-twelfth;   // 8.8.0
  $curlversion-last;      // never actually use this
  $curlversion-now = $curlversion-twelfth;
end enum;
