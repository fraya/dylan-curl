Module:      curl-easy-impl
Synopsis:    Curl library binding
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

///////////////////////////////////////////////////////////////////////////////
//
// Curl error codes
//
// See: https://curl.se/libcurl/c/libcurl-errors.html
//
///////////////////////////////////////////////////////////////////////////////

define constant $curle-ok = 0;
define constant $curle-unsupported-protocol = 1;
define constant $curle-failed-init = 2;
define constant $curle-url-malformat = 3;
define constant $curle-not-built-in = 4;
define constant $curle-couldnt-resolve-proxy = 5;
define constant $curle-couldnt-resolve-host = 6;
define constant $curle-couldnt-connect = 7;
define constant $curle-weird-server-reply = 8;
define constant $curle-remote-access-denied = 9;
define constant $curle-ftp-accept-failed = 10;
define constant $curle-ftp-weird-pass-reply = 11;
define constant $curle-ftp-accept-timeout = 12;
define constant $curle-ftp-weird-pasv-reply = 13;
define constant $curle-ftp-weird-227-reply = 14;
define constant $curle-ftp-cant-get-host = 15;
define constant $curle-http2 = 16;
define constant $curle-ftp-couldnt-set-type = 17;
define constant $curle-partial-file = 18;
define constant $curle-ftp-couldnt-retr-file = 19;
define constant $curle-obsolete20 = 20;
define constant $curle-quote-error = 21;
define constant $curle-http-returned_error = 22;
define constant $curle-write-error = 23;
define constant $curle-obsolete24 = 24;
define constant $curle-upload-failed = 25;
define constant $curle-read-error = 26;
define constant $curle-out-of-memory = 27;
define constant $curle-operation-timedout = 28;
define constant $curle-obsolete29 = 29;
define constant $curle-ftp-port-failed = 30;
define constant $curle-ftp-couldnt-use-rest = 31;
define constant $curle-obsolete32 = 32;
define constant $curle-range-error = 33;
define constant $curle-http-post-error = 34;
define constant $curle-ssl-connect-error = 35;
define constant $curle-bad-download-resume = 36;
define constant $curle-file-couldnt-read-file = 37;
define constant $curle-ldap-cannot-bind = 38;
define constant $curle-ldap-search-failed = 39;
define constant $curle-obsolete40 = 40;
define constant $curle-function-not-found = 41;
define constant $curle-aborted-by-callback = 42;
define constant $curle-bad-function-argument = 43;
define constant $curle-obsolete44 = 44;
define constant $curle-interface-failed = 45;
define constant $curle-obsolete46 = 46;
define constant $curle-too-many-redirects = 47;
define constant $curle-unknown-option = 48;
define constant $curle-setopt-option-syntax = 49;
define constant $curle-obsolete50 = 50;
define constant $curle-obsolete51 = 51;
define constant $curle-got-nothing = 52;
define constant $curle-ssl-engine-notfound = 53;
define constant $curle-ssl-engine-setfailed = 54;
define constant $curle-send-error = 55;
define constant $curle-recv-error = 56;
define constant $curle-obsolete57 = 57;
define constant $curle-ssl-certproblem = 58;
define constant $curle-ssl-cypher = 59;
define constant $curle-peer-failed-verification = 60;
define constant $curle-bad-content-encoding = 61;
define constant $curle-obsolete62 = 62;
define constant $curle-filesize-exceeded = 63;
define constant $curle-use-ssl-failed = 64;
define constant $curle-send-fail-rewind = 65;
define constant $curle-ssl-engine-initfailed = 66;
define constant $curle-login-denied = 67;
define constant $curle-tftp-notfound = 68;
define constant $curle-tftp-perm = 69;
define constant $curle-remote-disk-full = 70;
define constant $curle-tftp-illegal = 71;
define constant $curle-tftp-unknownid = 72;
define constant $curle-remote-file-exists = 73;
define constant $curle-tftp-nosuchuser = 74;
define constant $curle-obsolete75 = 75;
define constant $curle-obsolete76 = 76;
define constant $curle-ssl-cacert-badfile = 77;
define constant $curle-remote-file-not-found = 78;
define constant $curle-ssh = 79;
define constant $curle-ssl-shutdown-failed = 80;
define constant $curle-again = 81;
define constant $curle-ssl-crl-badfile = 82;
define constant $curle-ssl-issuer-error = 83;
define constant $curle-ftp-pret-failed = 84;
define constant $curle-rtsp-cseq-error = 85;
define constant $curle-rtsp-session-error = 86;
define constant $curle-ftp-bad-file-list = 87;
define constant $curle-chunk-failed = 88;
define constant $curle-no-connection-available = 89;
define constant $curle-ssl-pinnedpubkeynotmatch = 90;
define constant $curle-ssl-invalidcertstatus = 91;
define constant $curle-http2-stream = 92;
define constant $curle-recursive-api-call = 93;
define constant $curle-auth-error = 94;
define constant $curle-http3 = 95;
define constant $curle-quic-connect-error = 96;
define constant $curle-proxy = 97;
define constant $curle-ssl-clientcert = 98;
define constant $curle-unrecoverable-poll = 99;
define constant $curle-too-large = 100;
define constant $curle-ech-required = 101;

//////////////////////////////////////////////////////////////////////////////
//
// Constants used in `curl-global-init` function.
//
// See: https://curl.se/libcurl/c/curl_global_init.html
//
//////////////////////////////////////////////////////////////////////////////

define constant $curl-global-ssl       = ash(1, 0);
define constant $curl-global-win32     = ash(1, 1);
define constant $curl-global-all       = logior($curl-global-ssl, $curl-global-win32);
define constant $curl-global-nothing   = 0;
define constant $curl-global-default   = $curl-global-all;
define constant $curl-global-ack-eintr = ash(1, 2);

//////////////////////////////////////////////////////////////////////////////
//
// Constants used for get a detailed (SOCKS) proxy error.
// Returned by `curl-easy-getinfo-proxy-error` function.
//
// See: https://curl.se/libcurl/c/CURLINFO_PROXY_ERROR.html
//
//////////////////////////////////////////////////////////////////////////////

define constant $curlpx-ok = 0;
define constant $curlpx-bad-address-type = 1;
define constant $curlpx-bad-version = 2;
define constant $curlpx-closed = 3;
define constant $curlpx-gssapi = 4;
define constant $curlpx-gssapi-permsg = 5;
define constant $curlpx-gssapi-protection = 6;
define constant $curlpx-identd = 7;
define constant $curlpx-identd-differ = 8;
define constant $curlpx-long-hostname = 9;
define constant $curlpx-long-passwd = 10;
define constant $curlpx-long-user = 11;
define constant $curlpx-no-auth = 12;
define constant $curlpx-recv-address = 13;
define constant $curlpx-recv-auth = 14;
define constant $curlpx-recv-connect = 15;
define constant $curlpx-recv-reqack = 16;
define constant $curlpx-reply-address-type-not-supported = 17;
define constant $curlpx-reply-command-not-supported = 18;
define constant $curlpx-reply-connection-refused = 19;
define constant $curlpx-reply-general-server-failure = 20;
define constant $curlpx-reply-host-unreacheable = 21;
define constant $curlpx-reply-network-unreachable = 22;
define constant $curlpx-reply-not-allowed = 23;
define constant $curlpx-reply-ttl-expired = 24;
define constant $curlpx-reply-unassigned = 25;
define constant $curlpx-request-failed = 26;
define constant $curlpx-resolve-host = 27;
define constant $curlpx-send-auth = 28;
define constant $curlpx-send-connect = 29;
define constant $curlpx-send-request = 30;
define constant $curlpx-unknown-fail = 31;
define constant $curlpx-unknown-mode = 32;
define constant $curlpx-user-rejected = 33;

//////////////////////////////////////////////////////////////////////////////
//
// Curl header error codes
//
// See: https://curl.se/libcurl/c/libcurl-errors.html#CURLHcode
//
//////////////////////////////////////////////////////////////////////////////

define constant $curlhe-ok = 0;
define constant $curlhe-badindex = 1;
define constant $curlhe-missing = 2;
define constant $curlhe-noheaders = 3;
define constant $curlhe-norequest = 4;
define constant $curlhe-out-of-memory = 5;
define constant $curlhe-bad-argument = 6;
define constant $curlhe-not-built-in = 7;

//////////////////////////////////////////////////////////////////////////////
//
// Information types passed to a debug callback.
//
// See: https://curl.se/libcurl/c/CURLOPT_DEBUGFUNCTION.html
//
//////////////////////////////////////////////////////////////////////////////

define constant $curlinfo-text         = 0;
define constant $curlinfo-header-in    = 1;
define constant $curlinfo-header-out   = 2;
define constant $curlinfo-data-in      = 3;
define constant $curlinfo-data-out     = 4;
define constant $curlinfo-ssl-data-in  = 5;
define constant $curlinfo-ssl-data-out = 6;

//////////////////////////////////////////////////////////////////////////////
//
// Types of authentication methods
//
// See: https://curl.se/libcurl/c/CURLOPT_HTTPAUTH.html
//
//////////////////////////////////////////////////////////////////////////////

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
// See: https://curl.se/libcurl/c/curl_easy_pause.html
//

define constant $curlpause-recv      = ash(1, 0);
define constant $curlpause-recv-cont = 0;
define constant $curlpause-send      = ash(1, 2);
define constant $curlpause-send-cont = 0;
define constant $curlpause-all       = logior($curlpause-recv, $curlpause-send);
define constant $curlpause-cont      = logior($curlpause-recv-cont, $curlpause-send-cont);

//
// Different supported SSL backends
// https://github.com/curl/curl/blob/b3752d502e1ce2f92d2d52a7223f83d66c5a708b/include/curl/curl.h#L153
//

define constant $curlsslbackend-none = 0;
define constant $curlsslbackend-openssl = 1;
define constant $curlsslbackend-gnutls = 2;
define constant $curlsslbackend-nss = 3;
define constant $curlsslbackend-obsolete4 = 4;
define constant $curlsslbackend-gskit = 5;
define constant $curlsslbackend-polarssl = 6;
define constant $curlsslbackend-wolfssl = 7;
define constant $curlsslbackend-schannel = 8;
define constant $curlsslbackend-securetransport = 9;
define constant $curlsslbackend-axtls = 10;
define constant $curlsslbackend-mbedtls = 11;
define constant $curlsslbackend-mesalink = 12;
define constant $curlsslbackend-bearssl = 13;
define constant $curlsslbackend-rustls = 14;


//////////////////////////////////////////////////////////////////////////////
//
// C structures
//
//////////////////////////////////////////////////////////////////////////////

define C-struct <curl-blob>
  slot curl-blob-data :: <C-void*>;
  slot curl-blob-len :: <C-int>;
  slot curl-blob-flags :: <C-unsigned-int>;
  pointer-type-name: <curl-blob*>;
end C-struct;

define C-struct <curl-tlssessioninfo>
  slot curl-tlssessioninfo-backend   :: <C-int>;
  slot curl-tlssessioninfo-internals :: <C-void*>;
  pointer-type-name: <curl-tlssessioninfo*>;
end C-struct;
  
define C-struct <curl-header> 
  slot curl-header-name   :: <c-string>;
  slot curl-header-value  :: <c-string>;
  slot curl-header-amount :: <c-int>;
  slot curl-header-index  :: <c-int>;
  slot curl-header-origin :: <c-unsigned-int>;
  slot curl-header-anchor :: <c-void*>;
  pointer-type-name: <curl-header*>;
end C-struct;

define C-struct <curl-slist>
  slot curl-slist-data :: <c-string>;
  slot curl-slist-next :: <curl-slist*>;
  pointer-type-name: <curl-slist*>;
end C-struct;

define C-struct <curl-certinfo>
  slot curl-certinfo-num-of-certs :: <c-int>;
  slot curl-certinfo-certinfo :: <curl-slist*>;
  pointer-type-name: <curl-certinfo*>;
end;

// See: https://github.com/curl/curl/blob/280ff5ca0328bfc40968282faea6033a2cef7a92/include/curl/options.h#L1-L70

define C-struct <curl-easy-option>
  slot curl-easy-option-name  :: <c-string>;
  slot curl-easy-option-id    :: <c-int>;
  slot curl-easy-option-type  :: <c-int>; 
  slot curl-easy-option-flags :: <c-unsigned-int>;
  pointer-type-name: <curl-easy-option*>;
end C-struct;


///////////////////////////////////////////////////////////////////////////////
//
// Curl easy handle
//
///////////////////////////////////////////////////////////////////////////////

define C-subtype <curl-easy-handle> (<C-void*>) end;
define constant <curl-off-t> = <integer>;


///////////////////////////////////////////////////////////////////////////////
//
// All libcurl functions bindings all prefixed with C in case of collision.
//
// See: https://curl.se/libcurl/c/allfuncs.html
//
///////////////////////////////////////////////////////////////////////////////

define C-function c-curl-easy-cleanup
  // https://curl.se/libcurl/c/curl_easy_cleanup.html
  input parameter handle :: <curl-easy-handle>;
  c-name: "curl_easy_cleanup";
end C-function;

define C-function c-curl-easy-duphandle
  // https://curl.se/libcurl/c/curl_easy_duphandle.html
  input parameter handle :: <curl-easy-handle>;
  result dup :: <curl-easy-handle>;
  c-name: "curl_easy_duphandle";
end C-function;

define C-function c-curl-easy-escape
  // https://curl.se/libcurl/c/curl_easy_escape.html
  input parameter handle :: <curl-easy-handle>;
  input parameter url :: <c-string>;
  input parameter length :: <c-int>;
  result value :: <c-string>;
  c-name: "curl_easy_escape";
end C-function;

define C-function c-curl-easy-header
  // https://curl.se/libcurl/c/curl_easy_header.html
  // https://everything.curl.dev/helpers/headerapi/struct.html
  input parameter handle  :: <curl-easy-handle>;
  input parameter name    :: <c-string>;
  input parameter index   :: <c-int>;
  input parameter origin  :: <c-unsigned-int>;
  input parameter request :: <c-int>;
  output parameter hout   :: <curl-header*>;
  result curlhe-code :: <c-int>;
  c-name: "curl_easy_header";
end C-function;

define C-function c-curl-easy-init
  // https://curl.se/libcurl/c/curl_easy_init.html
  result curl-easy :: <curl-easy-handle>;
  c-name: "curl_easy_init";
end C-function;

define C-function c-curl-easy-next-header
  // https://curl.se/libcurl/c/curl_easy_nextheader.html
  input parameter handle  :: <curl-easy-handle>;
  input parameter origin  :: <c-unsigned-int>;
  input parameter request :: <c-int>;
  input parameter prev    :: <curl-header*>;
  result next-header :: <curl-header*>;
  c-name: "curl_easy_nextheader";
end C-function;

define C-function curl-easy-option-by-id
  input parameter id :: <c-int>;
  result curl-option :: <curl-easy-option*>;
  c-name: "curl_easy_option_by_id";
end C-function;

define C-function curl-easy-option-by-name
  input parameter name :: <c-string>;
  result curl-option   :: <curl-easy-option*>;
  c-name: "curl_easy_option_by_name";
end C-function;

define C-function curl-easy-option-next
  input parameter prev :: <curl-easy-option*>;
  result next-option   :: <curl-easy-option*>;
  c-name: "curl_easy_option_next";
end C-function;

define C-function c-curl-easy-pause
  input parameter handle  :: <curl-easy-handle>;
  input parameter bitmask :: <c-int>;
  result curl-code :: <c-int>;
  c-name: "curl_easy_pause";
end C-function;

define C-function c-curl-easy-perform
  // https://curl.se/libcurl/c/curl_easy_perform.html
  input parameter handle :: <curl-easy-handle>;
  result status :: <c-int>;
  c-name: "curl_easy_perform";
end C-function;

// NOT IMPLEMENTED: Problem with input output parameter
// define C-function curl-easy-recv
//   // https://curl.se/libcurl/c/curl_easy_recv.html
//   input parameter handle :: <curl-easy-handle>;
//   input output parameter buffer :: <c-void*>;
//   input parameter buflen :: <c-int>;
//   output parameter n :: <c-int*>;
//   result status :: <c-int>;
//   c-name: "curl_easy_recv_shim";
// end C-function;

define C-function c-curl-easy-reset
  // https://curl.se/libcurl/c/curl_easy_perform.html
  input parameter handle :: <curl-easy-handle>;
  c-name: "curl_easy_reset";
end C-function;

define C-function c-curl-easy-send
  // https://curl.se/libcurl/c/curl_easy_send.html
  input parameter handle :: <curl-easy-handle>;
  input parameter buffer :: <c-void*>;
  input parameter buflen :: <c-int>;
  output parameter n :: <c-int*>;
  result status :: <c-int>;
  c-name: "curl_easy_send";
end C-function;

define C-function c-curl-easy-strerror
  // https://curl.se/libcurl/c/curl_easy_strerror.html
  input parameter error-number :: <c-int>;
  result error-message :: <c-string>;
  c-name: "curl_easy_strerror";
end C-function;

define C-function c-curl-easy-unescape
  // https://curl.se/libcurl/c/curl_easy_unescape.html
  input parameter handle :: <curl-easy-handle>;
  input parameter input-string :: <C-string>;
  input parameter input-length :: <C-int>;
  output parameter output-length :: <C-int*>;
  result value :: <C-string>;
  c-name: "curl_easy_unescape";
end C-function;

define C-function c-curl-easy-upkeep
  // https://curl.se/libcurl/c/curl_easy_upkeep.html
  input parameter handle :: <curl-easy-handle>;
  result status :: <c-int>;
  c-name: "curl_easy_upkeep";
end C-function;

define C-function curl-global-init
  // https://curl.se/libcurl/c/curl_global_init.html
  input parameter flags :: <c-int>;
  result curl-code :: <c-int>;
  c-name: "curl_global_init";
end C-function;

// TODO: curl-global-init-mem needed???

// TODO: curl-global-sslset needed??

// NOTE: only from version 8.3
// define C-function curl-global-trace
//   // https://curl.se/libcurl/c/curl_global_trace.html
//   input parameter config :: <c-string>;
//   result curl-code :: <c-int>;
//   c-name: "curl_global_trace";
// end C-function;

define C-function curl-global-cleanup
  // https://curl.se/libcurl/c/curl_global_cleanup.html
  c-name: "curl_global_cleanup";
end C-function;

define C-function curl-slist-append
  // https://curl.se/libcurl/c/curl_slist_append.html
  input parameter slist  :: <curl-slist*>;
  input parameter string :: <c-string>;
  result new-slist :: <curl-slist*>;
  c-name: "curl_slist_append";
end C-function;

define C-function curl-slist-free-all
  // https://curl.se/libcurl/c/curl_slist_free_all.html
  input parameter slist :: <curl-slist*>;
  c-name: "curl_slist_free_all";
end C-function;

define C-function curl-version
  // https://curl.se/libcurl/c/curl_version.html
  result version :: <c-string>;
  c-name: "curl_version";
end C-function;

///////////////////////////////////////////////////////////////////////////////
//
// Curl errors as exceptions
//
///////////////////////////////////////////////////////////////////////////////

define abstract class <curl-error> (<error>)
  constant slot curl-error-code :: <integer>,
    required-init-keyword: code:;
  constant virtual slot curl-error-message :: <string>;
end;

define method curl-error-message
    (err :: <curl-error>) => (message :: <string>)
  c-curl-easy-strerror(err.curl-error-code)
end;

define class <curl-init-error> (<curl-error>)
  inherited slot curl-error-code, init-value: $curle-failed-init;
end;

define class <curl-option-error> (<curl-error>) end;
define class <curl-perform-error> (<curl-error>) end;
define class <curl-info-error> (<curl-error>) end;

///////////////////////////////////////////////////////////////////////////////
//
// Curl errors as exceptions
//
///////////////////////////////////////////////////////////////////////////////

define abstract class <curl> (<object>) end;

define open class <curl-easy> (<curl>)
  constant slot curl-handle :: <curl-easy-handle> = c-curl-easy-init(),
    init-keyword: handle:;
end;

define method initialize
    (curl :: <curl-easy>, #key)
  // drain-finalization-queue(); ???
  next-method();
  if (null-pointer?(curl.curl-handle))
    signal(make(<curl-init-error>))
  end;
  finalize-when-unreachable(curl);
end method;

define method finalize
    (curl :: <curl-easy>) => ()
  c-curl-easy-cleanup(curl.curl-handle)
end;

define function curl-easy-dup
    (curl :: <curl-easy>) => (dup :: <curl-easy>)
  make(<curl-easy>,
       handle: c-curl-easy-duphandle(curl.curl-handle))
end;

define function curl-easy-escape
    (curl :: <curl-easy>, url :: <string>, #key length :: false-or(<integer>) = #f)
 => (escaped-url :: <string>)
  let url-size = length | url.size;
  let escaped = c-curl-easy-escape(curl.curl-handle, url, url-size);
  if (null-pointer?(escaped))
    signal(make(<curl-init-error>))
  end;
  escaped
end;

define function curl-easy-perform
    (curl :: <curl-easy>) => ()
  let curl-code = c-curl-easy-perform(curl.curl-handle);
  unless (curl-code = $curle-ok)
    signal(make(<curl-perform-error>, code: curl-code))
  end;
end;

define function curl-easy-reset
    (curl :: <curl-easy>) => ()
  c-curl-easy-reset(curl.curl-handle)
end;

define function curl-easy-unescape
    (curl :: <curl-easy>, url :: <string>, #key length :: false-or(<integer>) = #f)
 => (escaped-url :: <string>, out-length :: <integer>)
  let url-size = length | url.size;
  let (unescaped, out-length) = c-curl-easy-unescape(curl.curl-handle, url, url-size);
  if (null-pointer?(unescaped))
    signal(make(<curl-init-error>))
  end;
  values(unescaped, out-length)
end;

//////////////////////////////////////////////////////////////////////////////
//
// Callbacks: Dylan functions called from C
//
//////////////////////////////////////////////////////////////////////////////

define thread variable *curl-write-callback* = #f;
define thread variable *curl-header-callback* = #f;
define thread variable *curl-debug-callback* = #f;
define thread variable *curl-progress-callback* = #f;

define function curl-write-callback
    (ptr :: <string>, size :: <integer>, nmemb :: <integer>, user-data :: <object>)
 => (bytes-written :: <integer>)
  *curl-write-callback*(ptr, size, nmemb, user-data)
end;

define function curl-header-callback
    (ptr :: <c-void*>, size :: <integer>, nmemb :: <integer>, stream :: <c-void*>)
 => (bytes-written :: <integer>)
  *curl-header-callback*(ptr, size, nmemb, stream)
end;

define function curl-debug-callback
    (handle :: <curl-easy-handle>, type :: <integer>, data :: <string>, size :: <integer>, clientp :: <c-void*>)
 => (code :: <integer>)
  *curl-debug-callback*(handle, type, data, size, clientp)
end;

define function curl-progress-callback
    (clientp :: <c-void*>, dt :: <integer>, dn :: <integer>, ut :: <integer>, unow :: <integer>)
 => (status :: <integer>)
  *curl-progress-callback*(clientp, dt, dn, ut, unow)
end;

define c-callable-wrapper $curl-write-callback of curl-write-callback
  input parameter ptr       :: <c-string>;
  input parameter size      :: <c-int>;
  input parameter nmemb     :: <c-int>;
  input parameter user-data :: <c-dylan-object>;
  result bytes-written :: <c-int>;
end c-callable-wrapper;

define c-callable-wrapper $curl-header-callback of curl-header-callback
  input parameter ptr    :: <c-void*>;
  input parameter size   :: <c-int>;
  input parameter nmemb  :: <c-int>;
  input parameter stream :: <c-void*>;
  result bytes-written :: <c-int>;
end c-callable-wrapper;

define c-callable-wrapper $curl-debug-callback of curl-debug-callback
  input parameter handle  :: <curl-easy-handle>;
  input parameter type    :: <c-int>;
  input parameter data    :: <c-string>;
  input parameter size    :: <c-int>;
  input parameter clientp :: <c-void*>;
  result code :: <c-int>;
end c-callable-wrapper;

define c-callable-wrapper $curl-progress-callback of curl-progress-callback
  input parameter clientp :: <c-dylan-object>;
  input parameter dltotal :: <c-unsigned-long>;
  input parameter dlnow   :: <c-unsigned-long>;
  input parameter ultotal :: <c-int>;
  input parameter ulnow   :: <c-int>;
  result status :: <c-int>;
end c-callable-wrapper;

//////////////////////////////////////////////////////////////////////////////
//
// `curl-easy-setopt` shim functions.
//
// A "shim" function is created for each `$curl-setopt-xxx` constant to 
// streamline the process of working with the variadic function 
// `curl_easy_getinfo`.
//
//////////////////////////////////////////////////////////////////////////////

define C-function curl-setopt-long
  input parameter handle :: <curl-easy-handle>;
  input parameter option :: <c-int>;
  input parameter value :: <c-long>;
  result curl-code :: <c-int>;
  c-name: "curl_setopt_long";
end C-function;

define C-function curl-setopt-objectpoint
  input parameter handle :: <curl-easy-handle>;
  input parameter option :: <c-int>;
  input parameter value :: <c-void*>;
  result curl-code :: <c-int>;
  c-name: "curl_setopt_objectpoint";
end C-function;

define C-function curl-setopt-functionpoint
  input parameter handle :: <curl-easy-handle>;
  input parameter option :: <c-int>;
  input parameter value :: <c-function-pointer>;
  result curl-code :: <c-int>;
  c-name: "curl_setopt_functionpoint";
end C-function;

define C-function curl-setopt-off-t
  input parameter handle :: <curl-easy-handle>;
  input parameter option :: <c-int>;
  input parameter value :: <c-long>;
  result curl-code :: <c-int>;
  c-name: "curl_setopt_off_t";
end C-function;

define C-function curl-setopt-blob
  input parameter handle :: <curl-easy-handle>;
  input parameter option :: <c-int>;
  input parameter stblob :: <curlopt-blob>;
  result curl-code :: <c-int>;
  c-name: "curl_setopt_blob";
end C-function;

define C-function curl-setopt-stringpoint
  input parameter handle :: <curl-easy-handle>;
  input parameter option :: <c-int>;
  input parameter value  :: <c-string>;
  result curl-code :: <c-int>;
  c-name: "curl_setopt_stringpoint";
end C-function;

define C-function curl-setopt-slistpoint
  input parameter handle :: <curl-easy-handle>;
  input parameter option :: <c-int>;
  input parameter value  :: <curlopt-slistpoint>;
  result curl-code :: <c-int>;
  c-name: "curl_setopt_slistpoint";
end C-function;

define C-function curl-setopt-cbpoint
  input parameter handle :: <curl-easy-handle>;
  input parameter option :: <c-int>;
  input parameter value  :: <c-void*>;
  result curl-code :: <c-int>;
  c-name: "curl_setopt_cbpoint";
end C-function;

define C-function curl-setopt-values
  input parameter handle :: <curl-easy-handle>;
  input parameter option :: <c-int>;
  input parameter vals   :: <c-long>;
  result curl-code :: <c-int>;
  c-name: "curl_setopt_values";
end C-function;


//////////////////////////////////////////////////////////////////////////////
//
// Type alias to make easier the macro `curlopt-definer`
//
//////////////////////////////////////////////////////////////////////////////

define constant <curlopt-long> = <integer>;
define constant <curlopt-objectpoint> = <c-struct>;
define constant <curlopt-functionpoint> = <object>;
define constant <curlopt-off-t> = <integer>;
define constant <curlopt-blob> = <curl-blob*>;
define constant <curlopt-stringpoint> = <string>;
define constant <curlopt-slistpoint> = <curl-slist*>;
define constant <curlopt-cbpoint> = <c-dylan-object>;
define constant <curlopt-values> = <integer>;

///////////////////////////////////////////////////////////////////////////////
//
// Curl option type constants are assigned a unique identifier based on a
// type-specific base index. Each constant's value is calculated by
// adding its unique offset to this base index.
//
// Reference: 
//
// - https://github.com/curl/curl/blob/878bc429f26c27294787dc59d7b53345d9edc5aa/include/curl/curl.h#L1079
// 
///////////////////////////////////////////////////////////////////////////////

define constant $curlopttype-long          = 0;
define constant $curlopttype-objectpoint   = 10000;
define constant $curlopttype-functionpoint = 20000;
define constant $curlopttype-off-t         = 30000;
define constant $curlopttype-blob          = 40000;
define constant $curlopttype-stringpoint   = $curlopttype-objectpoint;
define constant $curlopttype-slistpoint    = $curlopttype-objectpoint;
define constant $curlopttype-cbpoint       = $curlopttype-objectpoint;
define constant $curlopttype-values        = $curlopttype-long;

//////////////////////////////////////////////////////////////////////////////
//
// The `curlopt-definer` macro serves two purposes:
//
// 1. Defines a constant for each identifier by adding the base index 
//    to the identifier's numeric value.
//
// 2. Creates a function to set the option.
//    This function calls the corresponding shim function and checks 
//    the status code to handle errors appropriately.
//
//////////////////////////////////////////////////////////////////////////////

define macro curlopt-definer
  { define curlopt ?type:name ?id:name = ?number:expression }
    => { define constant "$curlopt-" ## ?id 
           = "$curlopttype-" ## ?type + ?number;
    
         define method "curl-" ## ?id ## "-setter"
             (option :: "<curlopt-" ## ?type ## ">", curl :: <curl-easy>)
	  => (option :: "<curlopt-" ## ?type ## ">")
	     let handle = curl.curl-handle;
	     let code = "curl-setopt-" ## ?type (handle, "$curlopt-" ## ?id, option);
	     if (code ~= $curle-ok)
	       signal(make(<curl-option-error>, code: code))
	     end;
	     option
         end method }
end macro curlopt-definer;

///////////////////////////////////////////////////////////////////////////////
//
// Curl options definition
//
// See: https://github.com/curl/curl/blob/b723f6a445b4d5757db915fe9946158e4158def4/include/curl/curl.h#L1110
//
///////////////////////////////////////////////////////////////////////////////

define curlopt cbpoint writedata = 1;
define curlopt stringpoint url = 2;
define curlopt long port = 3;
define curlopt stringpoint proxy = 4;
define curlopt stringpoint userpwd = 5;
define curlopt stringpoint proxyuserpwd = 6;
define curlopt stringpoint range = 7;
// // 8 not used
define curlopt cbpoint readdata = 9;
define curlopt objectpoint errorbuffer = 10;
define curlopt functionpoint writefunction = 11;
define curlopt functionpoint readfunction = 12;
define curlopt long timeout = 13;
define curlopt long infilesize = 14;
// postfields is defined as objectpoint in libcurl but it passes a string
define curlopt stringpoint postfields = 15;
define curlopt stringpoint referer = 16;
define curlopt stringpoint ftpport = 17;
define curlopt stringpoint useragent = 18;
define curlopt long low-speed-limit = 19;
define curlopt long low-speed-time = 20;
define curlopt long resume-from = 21;
define curlopt stringpoint cookie = 22;
define curlopt slistpoint httpheader = 23;
// // 24 is deprecated use curlopt-mimepost
define curlopt objectpoint httppost = 24;
define curlopt stringpoint sslcert = 25;
define curlopt stringpoint keypasswd = 26;
define curlopt long crlf = 27;
define curlopt slistpoint quote = 28;
define curlopt cbpoint headerdata = 29;
define curlopt stringpoint cookiefile = 31;
define curlopt values sslversion = 32;
define curlopt values timecondition = 33;
define curlopt long timevalue = 34;
// 35 is obsolete
define curlopt stringpoint customrequest = 36;
define curlopt objectpoint stderr = 37;
// 38 is not used
define curlopt slistpoint postquote = 39;
// 40 is not used
define curlopt long verbose = 41;
define curlopt long header = 42;
define curlopt long noprogress = 43;
define curlopt long nobody = 44;
define curlopt long failonerror = 45;
define curlopt long upload = 46;
define curlopt long post = 47;
define curlopt long dirlistonly = 48;
define curlopt long append = 50;
define curlopt values netrc = 51;
define curlopt long followlocation = 52;
define curlopt long transfertext = 53;
// 54 is deprecated use upload
define curlopt long put = 54;
// 55 is obsolete
// 56 is deprecated use xferinfofunction
define curlopt functionpoint progressfunction = 56;
define curlopt cbpoint xferinfodata = 57;
define curlopt long autoreferer = 58;
define curlopt long proxyport = 59;
define curlopt long postfieldsize = 60;
define curlopt long httpproxytunnel = 61;
define curlopt stringpoint interface = 62;
define curlopt stringpoint krblevel = 63;
define curlopt long ssl-verifypeer = 64;
define curlopt stringpoint cainfo = 65;
// 66 is obsolete
// 67 is obsolete
define curlopt long maxredirs = 68;
define curlopt long filetime = 69;
define curlopt slistpoint telnetoptions = 70;
define curlopt long maxconnects = 71;
// 72 is obsolete
// 73 is obsolete
define curlopt long fresh-connect = 74;
define curlopt long forbid-reuse = 75;
define curlopt stringpoint random-file = 76;
// 77 is deprecated, serves no purpose anymore
define curlopt stringpoint egdsocket = 77;
define curlopt long connecttimeout = 78;
define curlopt functionpoint headerfunction = 79;
define curlopt long httpget = 80;
define curlopt long ssl-verifyhost = 81;
define curlopt stringpoint cookiejar = 82;
define curlopt stringpoint ssl-cipher-list = 83;
define curlopt values http-version = 84;
define curlopt long ftp-use-epsv = 85;
define curlopt stringpoint sslcerttype = 86;
define curlopt stringpoint sslkeytype = 87;
define curlopt stringpoint sslengine = 89;
define curlopt long sslengine-default = 90;
// 91 deprecated, use curlopt-share
define curlopt long dns-use-global-cache = 91;
define curlopt long dns-cache-timeout = 92;
define curlopt slistpoint prequote = 93;
define curlopt functionpoint debugfunction = 94;
define curlopt cbpoint debugdata = 95;
define curlopt long cookiesession = 96;
define curlopt stringpoint capath = 97;
define curlopt long buffersize = 98;
define curlopt long nosignal = 99;
define curlopt objectpoint share = 100;
define curlopt values proxytype = 101;
define curlopt stringpoint accept-encoding = 102;
define curlopt objectpoint private = 103;
define curlopt slistpoint http200aliases = 104;
define curlopt long unrestricted-auth = 105;
define curlopt long ftp-use-eprt = 106;
define curlopt values httpauth = 107;
define curlopt functionpoint ssl-ctx-function = 108;
define curlopt cbpoint ssl-ctx-data = 109;
define curlopt long ftp-create-missing-dirs = 110;
define curlopt values proxyauth = 111;
define curlopt long server-response-timeout = 112;
define curlopt values ipresolve = 113;
define curlopt long maxfilesize = 114;
define curlopt off-t infilesize-large = 115;
define curlopt off-t resume-from-large = 116;
define curlopt off-t maxfilesize-large = 117;
define curlopt stringpoint netrc-file = 118;
define curlopt values use-ssl = 119;
define curlopt off-t postfieldsize-large = 120;
define curlopt long tcp-nodelay = 121;
// 122-128 obsolete
define curlopt values ftpsslauth = 129;
// 130 deprecated, use curlopt-seekfunction
define curlopt functionpoint ioctlfunction = 130;
// 131 deprecated, use curlopt-seekdata
define curlopt cbpoint ioctldata = 131;
// 132-133 obsolete
define curlopt stringpoint ftp-account = 134;
define curlopt stringpoint cookielist = 135;
define curlopt long ignore-content-length = 136;
define curlopt long ftp-skip-pasv-ip = 137;
define curlopt values ftp-filemethod = 138;
define curlopt long localport = 139;
define curlopt long localportrange = 140;
define curlopt long connect-only = 141;
// 142-144 deprecated
define curlopt off-t max-send-speed-large = 145;
define curlopt off-t max-recv-speed-large = 146;
define curlopt stringpoint ftp-alternative-to-user = 147;
define curlopt functionpoint sockoptfunction = 148;
define curlopt cbpoint sockoptdata = 149;
define curlopt long ssl-sessionid-cache = 150;
define curlopt values ssh-auth-types = 151;
define curlopt stringpoint ssh-public-keyfile = 152;
define curlopt stringpoint ssh-private-keyfile = 153;
define curlopt long ftp-ssl-ccc = 154;
define curlopt long timeout-ms = 155;
define curlopt long connecttimeout-ms = 156;
define curlopt long http-transfer-decoding = 157;
define curlopt long http-content-decoding = 158;
define curlopt long new-file-perms = 159;
define curlopt long new-directory-perms = 160;
define curlopt values postredir = 161;
define curlopt stringpoint ssh-host-public-key-md5 = 162;
define curlopt functionpoint opensocketfunction = 163;
define curlopt cbpoint opensocketdata = 164;
define curlopt objectpoint copypostfields = 165;
define curlopt long proxy-transfer-mode = 166;
define curlopt functionpoint seekfunction = 167;
define curlopt cbpoint seekdata = 168;
define curlopt stringpoint crlfile = 169;
define curlopt stringpoint issuercert = 170;
define curlopt long address-scope = 171;
define curlopt long certinfo = 172;
define curlopt stringpoint username = 173;
define curlopt stringpoint password = 174;
define curlopt stringpoint proxyusername = 175;
define curlopt stringpoint proxypassword = 176;
define curlopt stringpoint noproxy = 177;
define curlopt long tftp-blksize = 178;
define curlopt stringpoint socks5-gssapi-service = 179;
define curlopt long socks5-gssapi-nec = 180;
// 181 deprecated: use curlopt-protocols-str
define curlopt long protocols = 181;
// 182 deprecated: use curlopt-redir-protocols-str
define curlopt long redir-protocols = 182;
define curlopt stringpoint ssh-knownhosts = 183;
define curlopt functionpoint ssh-keyfunction = 184;
define curlopt cbpoint ssh-keydata = 185;
define curlopt stringpoint mail-from = 186;
define curlopt slistpoint mail-rcpt = 187;
define curlopt long ftp-use-pret = 188;
define curlopt values rtsp-request = 189;
define curlopt stringpoint rtsp-session-id = 190;
define curlopt cbpoint chunk-data = 201;
define curlopt cbpoint fnmatch-data = 202;
define curlopt slistpoint resolve = 203;
define curlopt stringpoint tlsauth-username = 204;
define curlopt stringpoint tlsauth-password = 205;
define curlopt stringpoint tlsauth-type = 206;
define curlopt long transfer-encoding = 207;
define curlopt functionpoint closesocketfunction = 208;
define curlopt cbpoint closesocketdata = 209;
define curlopt values gssapi-delegation = 210;
define curlopt stringpoint dns-servers = 211;
define curlopt long accepttimeout-ms = 212;
define curlopt long tcp-keepalive = 213;
define curlopt long tcp-keepidle = 214;
define curlopt long tcp-keepintvl = 215;
define curlopt values ssl-options = 216;
define curlopt stringpoint mail-auth = 217;
define curlopt long sasl-ir = 218;
define curlopt functionpoint xferinfofunction = 219;
define curlopt stringpoint xoauth2-bearer = 220;
define curlopt stringpoint dns-interface = 221;
define curlopt stringpoint dns-local-ip4 = 222;
define curlopt stringpoint dns-local-ip6 = 223;
define curlopt stringpoint login-options = 224;
define curlopt long ssl-enable-alpn = 226;
define curlopt long expect-100-timeout-ms = 227;
define curlopt slistpoint proxyheader = 228;
define curlopt values headeropt = 229;
define curlopt stringpoint pinnedpublickey = 230;
define curlopt stringpoint unix-socket-path = 231;
define curlopt long ssl-verifystatus = 232;
define curlopt long ssl-falsestart = 233;
define curlopt long path-as-is = 234;
define curlopt stringpoint proxy-service-name = 235;
define curlopt stringpoint service-name = 236;
define curlopt long pipewait = 237;
define curlopt stringpoint default-protocol = 238;
define curlopt long stream-weight = 239;
define curlopt objectpoint stream-depends = 240;
define curlopt objectpoint stream-depends-e = 241;
define curlopt long tftp-no-options = 242;
define curlopt slistpoint connect-to = 243;
define curlopt long tcp-fastopen = 244;
define curlopt long keep-sending-on-error = 245;
define curlopt stringpoint proxy-cainfo = 246;
define curlopt stringpoint proxy-capath = 247;
define curlopt long proxy-ssl-verifypeer = 248;
define curlopt long proxy-ssl-verifyhost = 249;
define curlopt values proxy-sslversion = 250;
define curlopt stringpoint proxy-tlsauth-username = 251;
define curlopt stringpoint proxy-tlsauth-password = 252;
define curlopt stringpoint proxy-tlsauth-type = 253;
define curlopt stringpoint proxy-sslcert = 254;
define curlopt stringpoint proxy-sslcerttype = 255;
define curlopt stringpoint proxy-sslkey = 256;
define curlopt stringpoint proxy-sslkeytype = 257;
define curlopt stringpoint proxy-keypasswd = 258;
define curlopt stringpoint proxy-ssl-cipher-list = 259;
define curlopt stringpoint proxy-crlfile = 260;
define curlopt long proxy-ssl-options = 261;
define curlopt stringpoint pre-proxy = 262;
define curlopt stringpoint proxy-pinnedpublickey = 263;
define curlopt stringpoint abstract-unix-socket = 264;
define curlopt long suppress-connect-headers = 265;
define curlopt stringpoint request-target = 266;
define curlopt long socks5-auth = 267;
define curlopt long ssh-compression = 268;
define curlopt objectpoint mimepost = 269;
define curlopt off-t timevalue-large = 270;
define curlopt long happy-eyeballs-timeout-ms = 271;
define curlopt functionpoint resolver-start-function = 272;
define curlopt cbpoint resolver-start-data = 273;
define curlopt long haproxyprotocol = 274;
define curlopt long dns-shuffle-addresses = 275;
define curlopt stringpoint tls13-ciphers = 276;
define curlopt stringpoint proxy-tls13-ciphers = 277;
define curlopt long disallow-username-in-url = 278;
define curlopt stringpoint doh-url = 279;
define curlopt long upload-buffersize = 280;
define curlopt long upkeep-interval-ms = 281;
define curlopt objectpoint curlu = 282;
define curlopt functionpoint trailerfunction = 283;
define curlopt cbpoint trailerdata = 284;
define curlopt long http09-allowed = 285;
define curlopt long altsvc-ctrl = 286;
define curlopt stringpoint altsvc = 287;
define curlopt long maxage-conn = 288;
define curlopt stringpoint sasl-authzid = 289;
define curlopt long mail-rcpt-allowfails = 290;
define curlopt blob sslcert-blob = 291;
define curlopt blob sslkey-blob = 292;
define curlopt blob proxy-sslcert-blob = 293;
define curlopt blob proxy-sslkey-blob = 294;
define curlopt blob issuercert-blob = 295;
define curlopt stringpoint proxy-issuercert = 296;
define curlopt blob proxy-issuercert-blob = 297;
define curlopt stringpoint ssl-ec-curves = 298;
define curlopt long hsts-ctrl = 299;
define curlopt stringpoint hsts = 300;
define curlopt functionpoint hstsreadfunction = 301;
define curlopt cbpoint hstsreaddata = 302;
define curlopt functionpoint hstswritefunction = 303;
define curlopt cbpoint hstswritedata = 304;
define curlopt stringpoint aws-sigv4 = 305;
define curlopt long doh-ssl-verifypeer = 306;
define curlopt long doh-ssl-verifyhost = 307;
define curlopt long doh-ssl-verifystatus = 308;
define curlopt blob cainfo-blob = 309;
define curlopt blob proxy-cainfo-blob = 310;
define curlopt stringpoint ssh-host-public-key-sha256 = 311;
define curlopt functionpoint prereqfunction = 312;
define curlopt cbpoint prereqdata = 313;
define curlopt long maxlifetime-conn = 314;
define curlopt long mime-options = 315;
define curlopt functionpoint ssh-hostkeyfunction = 316;
define curlopt cbpoint ssh-hostkeydata = 317;
define curlopt stringpoint protocols-str = 318;
define curlopt stringpoint redir-protocols-str = 319;
define curlopt long ws-options = 320;
define curlopt long ca-cache-timeout = 321;
define curlopt long quick-exit = 322;
define curlopt stringpoint haproxy-client-ip = 323;
define curlopt long server-response-timeout-ms = 324;
define curlopt stringpoint ech = 325;
define curlopt long tcp-keepcnt = 326;

//////////////////////////////////////////////////////////////////////////////
//
// Type alias to make easier the `curlinfo-definer` macro.
//
//////////////////////////////////////////////////////////////////////////////

define constant <curlinfo-string> = <string>;
define constant <curlinfo-long>   = <integer>;
define constant <curlinfo-double> = <double-float>;
define constant <curlinfo-slist>  = <curl-slist*>;
define constant <curlinfo-ptr>    = <C-void*>;
// define constant <curlinfo-tlssessioninfo> = <curl-tlssessioninfo*>;
// define constant <curlinfo-certinfo> = <curl-certinfo*>;
// define constant <curlinfo-socket> =
define constant <curlinfo-off-t>  = <curl-off-t>;
// define constant <curlinfo-mask>
// define constant <curlinfo-typemask>

//////////////////////////////////////////////////////////////////////////////
//
// `curl-easy-getinfo` shim functions.
//
// A "shim" function is created for each `$curlinfo-xxx` constant to 
// streamline the process of working with the variadic function 
// `curl_easy_getinfo`.
//
//////////////////////////////////////////////////////////////////////////////

define C-function curl-easy-getinfo-string 
  input  parameter handle    :: <curl-easy-handle>;
  input  parameter option    :: <c-int>;
  output parameter curl-code :: <c-int*>;
  result value :: <c-string>;
  c-name: "curl_easy_getinfo_string";
end C-function;

define C-function curl-easy-getinfo-long 
  input  parameter handle    :: <curl-easy-handle>;
  input  parameter option    :: <c-int>;
  output parameter curl-code :: <c-int*>;
  result value :: <c-long>;
  c-name: "curl_easy_getinfo_long";
end C-function;

define C-function curl-easy-getinfo-double 
  input  parameter handle    :: <curl-easy-handle>;
  input  parameter option    :: <c-int>;
  output parameter curl-code :: <c-int*>;
  result value :: <c-double>;
  c-name: "curl_easy_getinfo_double";
end C-function;

define C-function curl-easy-getinfo-off-t 
  input  parameter handle    :: <curl-easy-handle>;
  input  parameter option    :: <c-int>;
  output parameter curl-code :: <c-int*>;
  result value :: <c-int>;
  c-name: "curl_easy_getinfo_off_t";
end C-function;

define C-function curl-easy-getinfo-slist 
  input  parameter handle    :: <curl-easy-handle>;
  input  parameter option    :: <c-int>;
  output parameter curl-code :: <c-int*>;
  result value :: <curl-slist*>;
  c-name: "curl_easy_getinfo_slist";
end C-function;

define C-function curl-easy-getinfo-ptr
  input  parameter handle    :: <curl-easy-handle>;
  input  parameter option    :: <c-int>;
  output parameter curl-code :: <c-int*>;
  result value :: <C-void*>;
  c-name: "curl_easy_getinfo_ptr";
end C-function;

// define C-function curl-easy-getinfo-tlssessioninfo
//   input  parameter handle    :: <curl-easy-handle>;
//   input  parameter option    :: <c-int>;
//   output parameter curl-code :: <c-int*>;
//   result value :: <curl-tlssessioninfo*>;
//   c-name: "curl_easy_getinfo_tlssessioninfo";
// end C-function;

// define C-function curl-easy-getinfo-certinfo
//   input  parameter handle    :: <curl-easy-handle>;
//   input  parameter option    :: <c-int>;
//   output parameter curl-code :: <c-int*>;
//   result value :: <curl-certinfo*>;
//   c-name: "curl_easy_getinfo_certinfo";
// end C-function;

//////////////////////////////////////////////////////////////////////////////
//
// The following constants are assigned a unique identifier based on a
// type-specific base index. Each `curlinfo` constant's value is calculated 
// by adding its unique offset to this base index.
//
// Reference: 
//
// - https://github.com/curl/curl/blob/1da198d18e495c08adb5691459da0b5fcfc7f160/include/curl/curl.h#L2859
//
//////////////////////////////////////////////////////////////////////////////

define constant $curlinfo-string   = #x100000;
define constant $curlinfo-long     = #x200000;
define constant $curlinfo-double   = #x300000;
define constant $curlinfo-slist    = #x400000;
define constant $curlinfo-ptr      = #x400000; // same as slist
define constant $curlinfo-socket   = #x500000; ignore($curlinfo-socket);
define constant $curlinfo-off-t    = #x600000;

define constant $curlinfo-mask     = #x0fffff;
ignore($curlinfo-mask);

define constant $curlinfo-typemask = #xf00000;
ignore($curlinfo-typemask);

//////////////////////////////////////////////////////////////////////////////
//
// The `curlinfo-definer` macro serves two purposes:
//
// 1. Defines a constant for each identifier by adding the base index 
//    to the identifier's numeric value.
// 2. Creates a function to retrieve information about the identifier.
//    This function calls the corresponding shim function and checks 
//    the status code to handle errors appropriately.
//
//////////////////////////////////////////////////////////////////////////////

define macro curlinfo-definer
  { define curlinfo ?type:name ?id:name = ?number:expression }
    => { define constant "$curlinfo-" ## ?id 
           = "$curlinfo-" ## ?type + ?number;

         define method "curl-" ## ?id
              (curl :: <curl-easy>) 
	  => (result :: "<curlinfo-" ## ?type ## ">")
	     let handle = curl.curl-handle;
	     let (result, code)
	       = "curl-easy-getinfo-" ## ?type (handle, "$curlinfo-" ## ?id);
	     unless (code = $curle-ok)
	       signal(make(<curl-info-error>, code: code))
	     end;
	     result
         end method }
end macro;

//////////////////////////////////////////////////////////////////////////////
//
// curlinfo options definition
//
//////////////////////////////////////////////////////////////////////////////

define curlinfo string effective-url = 1;
define curlinfo long response-code = 2;
define curlinfo double total-time = 3;
define curlinfo double namelookup-time = 4;
define curlinfo double connect-time = 5;
define curlinfo double pretransfer-time = 6;
define curlinfo off-t size-upload-t = 7;
define curlinfo off-t size-download-t = 8;
define curlinfo off-t speed-download-t = 9;
define curlinfo off-t speed-upload-t = 10;
define curlinfo long header-size = 11;
define curlinfo long request-size = 12;
define curlinfo long ssl-verifyresult = 13;
define curlinfo off-t filetime-t = 14;
define curlinfo off-t content-length-download-t = 15;
define curlinfo off-t content-length-upload-t = 16;
define curlinfo double starttransfer-time = 17;
define curlinfo string content-type = 18;
define curlinfo double redirect-time = 19;
define curlinfo long redirect-count = 20;
define curlinfo string private = 21;
define curlinfo long http-connectcode = 22;
define curlinfo long httpauth-avail = 23;
define curlinfo long proxyauth-avail = 24;
define curlinfo long os-errno = 25;
define curlinfo long num-connects = 26;
define curlinfo slist ssl-engines = 27;
define curlinfo slist cookielist = 28;
define curlinfo long lastsocket = 29;
define curlinfo string ftp-entry-path = 30;
define curlinfo string redirect-url = 31;
define curlinfo string primary-ip = 32;
define curlinfo double appconnect-time = 33;
define curlinfo ptr certinfo = 34;
define curlinfo long condition-unmet = 35;
define curlinfo string rtsp-session-id = 36;
define curlinfo long rtsp-client-cseq = 37;
define curlinfo long rtsp-server-cseq = 38;
define curlinfo long rtsp-cseq-recv = 39;
define curlinfo long primary-port = 40;
define curlinfo string local-ip = 41;
define curlinfo long local-port = 42;
// deprecated: define curlinfo ptr tls-session = 43;
// TODO: define curlinfo socket activesocket = 44;
define curlinfo ptr tls-ssl-ptr = 45;
define curlinfo long http-version = 46;
define curlinfo long proxy-ssl-verifyresult = 47;
define curlinfo long protocol = 48;
define curlinfo string scheme = 49;
define curlinfo off-t total-time-t = 50;
define curlinfo off-t namelookup-time-t = 51;
define curlinfo off-t connect-time-t = 52;
define curlinfo off-t pretransfer-time-t = 53;
define curlinfo off-t starttransfer-time-t = 54;
define curlinfo off-t redirect-time-t = 55;
define curlinfo off-t appconnect-time-t = 56;
define curlinfo off-t retry-after = 57;
define curlinfo string effective-method = 58;
define curlinfo long proxy-error = 59;
define curlinfo string referer = 60;
define curlinfo string cainfo = 61;
define curlinfo string capath = 62;
define curlinfo off-t xfer-id = 63;
define curlinfo off-t conn-id = 64;
define curlinfo off-t queue-time-t = 65;
define curlinfo long used-proxy = 66;
define curlinfo off-t posttransfer-time-t = 67;
define curlinfo off-t earlydata-sent-t = 68;
