Module:      dylan-user
Synopsis:    Module lib-curl-easy definition
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

define module lib-curl-easy

  /////////////////////////////////////////////////////////////////////////////
  //
  // Constants.
  //
  // See: "lib-curl-easy-constants.dylan"
  //
  /////////////////////////////////////////////////////////////////////////////
  
  // Curle: Error codes
  
  export
    $curle-aborted-by-callback,
    $curle-again,
    $curle-auth-error,
    $curle-bad-content-encoding,
    $curle-bad-download-resume,
    $curle-bad-function-argument,
    $curle-chunk-failed,
    $curle-couldnt-connect,
    $curle-couldnt-resolve-host,
    $curle-couldnt-resolve-proxy,
    $curle-ech-required,
    $curle-failed-init,
    $curle-file-couldnt-read-file,
    $curle-filesize-exceeded,
    $curle-ftp-accept-failed,
    $curle-ftp-accept-timeout,
    $curle-ftp-bad-file-list,
    $curle-ftp-cant-get-host,
    $curle-ftp-couldnt-retr-file,
    $curle-ftp-couldnt-set-type,
    $curle-ftp-couldnt-use-rest,
    $curle-ftp-port-failed,
    $curle-ftp-pret-failed,
    $curle-ftp-weird-227-reply,
    $curle-ftp-weird-pass-reply,
    $curle-ftp-weird-pasv-reply,
    $curle-function-not-found,
    $curle-got-nothing,
    $curle-http-post-error,
    $curle-http-returned_error,
    $curle-http2,
    $curle-http2-stream,
    $curle-http3,
    $curle-interface-failed,
    $curle-ldap-cannot-bind,
    $curle-ldap-search-failed,
    $curle-login-denied,
    $curle-no-connection-available,
    $curle-not-built-in,
    $curle-ok,
    $curle-operation-timedout,
    $curle-out-of-memory,
    $curle-partial-file,
    $curle-peer-failed-verification,
    $curle-proxy,
    $curle-quic-connect-error,
    $curle-quote-error,
    $curle-range-error,
    $curle-read-error,
    $curle-recursive-api-call,
    $curle-recv-error,
    $curle-remote-access-denied,
    $curle-remote-disk-full,
    $curle-remote-file-exists,
    $curle-remote-file-not-found,
    $curle-rtsp-cseq-error,
    $curle-rtsp-session-error,
    $curle-send-error,
    $curle-send-fail-rewind,
    $curle-setopt-option-syntax,
    $curle-ssh,
    $curle-ssl-cacert-badfile,
    $curle-ssl-certproblem,
    $curle-ssl-clientcert,
    $curle-ssl-connect-error,
    $curle-ssl-crl-badfile,
    $curle-ssl-cypher,
    $curle-ssl-engine-initfailed,
    $curle-ssl-engine-notfound,
    $curle-ssl-engine-setfailed,
    $curle-ssl-invalidcertstatus,
    $curle-ssl-issuer-error,
    $curle-ssl-pinnedpubkeynotmatch,
    $curle-ssl-shutdown-failed,
    $curle-tftp-illegal,
    $curle-tftp-nosuchuser,
    $curle-tftp-notfound,
    $curle-tftp-perm,
    $curle-tftp-unknownid,
    $curle-too-large,
    $curle-too-many-redirects,
    $curle-unknown-option,
    $curle-unrecoverable-poll,
    $curle-unsupported-protocol,
    $curle-upload-failed,
    $curle-url-malformat,
    $curle-use-ssl-failed,
    $curle-weird-server-reply,
    $curle-write-error;

  // Constants for `curl-global-init`

  export
    $curl-global-ack-eintr,
    $curl-global-all,
    $curl-global-default,
    $curl-global-nothing,
    $curl-global-ssl,
    $curl-global-win32;

  // Proxy error codes
  
  create
    $curlpx-ok,
    $curlpx-bad-address-type,
    $curlpx-bad-version,
    $curlpx-closed,
    $curlpx-gssapi,
    $curlpx-gssapi-permsg,
    $curlpx-gssapi-protection,
    $curlpx-identd,
    $curlpx-identd-differ,
    $curlpx-long-hostname,
    $curlpx-long-passwd,
    $curlpx-long-user,
    $curlpx-no-auth,
    $curlpx-recv-address,
    $curlpx-recv-auth,
    $curlpx-recv-connect,
    $curlpx-recv-reqack,
    $curlpx-reply-address-type-not-supported,
    $curlpx-reply-command-not-supported,
    $curlpx-reply-connection-refused,
    $curlpx-reply-general-server-failure,
    $curlpx-reply-host-unreacheable,
    $curlpx-reply-network-unreachable,
    $curlpx-reply-not-allowed,
    $curlpx-reply-ttl-expired,
    $curlpx-reply-unassigned,
    $curlpx-request-failed,
    $curlpx-resolve-host,
    $curlpx-send-auth,
    $curlpx-send-connect,
    $curlpx-send-request,
    $curlpx-unknown-fail,
    $curlpx-unknown-mode,
    $curlpx-user-rejected;

  // Curl header error codes
  
  create
    $curlhe-bad-argument,
    $curlhe-badindex,
    $curlhe-missing,
    $curlhe-noheaders,
    $curlhe-norequest,
    $curlhe-not-built-in,
    $curlhe-ok,
    $curlhe-out-of-memory;

  // Curl constants for the URL interface

  create
    $curlue-ok,
    $curlue-bad-handle,
    $curlue-bad-partpointer,
    $curlue-malformed-input,
    $curlue-bad-port-number,
    $curlue-unsupported-scheme,
    $curlue-urldecode,
    $curlue-out-of-memory,
    $curlue-user-not-allowed,
    $curlue-unknown-part,
    $curlue-no-scheme,
    $curlue-no-user,
    $curlue-no-password,
    $curlue-no-options,
    $curlue-no-host,
    $curlue-no-port,
    $curlue-no-query,
    $curlue-no-fragment,
    $curlue-no-zoneid,
    $curlue-bad-file-url,
    $curlue-bad-fragment,
    $curlue-bad-hostname,
    $curlue-bad-ipv6,
    $curlue-bad-login,
    $curlue-bad-password,
    $curlue-bad-path,
    $curlue-bad-query,
    $curlue-bad-scheme,
    $curlue-bad-slashes,
    $curlue-bad-user,
    $curlue-lacks-idn,
    $curlue-too-large;


  // Information types passed to a debug callback

  create
    $curlinfo-data-in,
    $curlinfo-data-out,
    $curlinfo-header-in,
    $curlinfo-header-out,
    $curlinfo-ssl-data-in,
    $curlinfo-ssl-data-out,
    $curlinfo-text;

  // Type of authentication methods
  
  create
    $curlauth-any,
    $curlauth-anysafe,
    $curlauth-aws-sigv4,
    $curlauth-basic,
    $curlauth-bearer,
    $curlauth-digest,
    $curlauth-digest-ie,
    $curlauth-gssapi,
    $curlauth-gssnegotiate,
    $curlauth-negotiate,
    $curlauth-negotiate,
    $curlauth-none,
    $curlauth-ntlm,
    $curlauth-ntlm-wb,
    $curlauth-only;

  // Bitmask to pause a connection
  
  create
    $curlpause-all,
    $curlpause-cont,
    $curlpause-recv,
    $curlpause-recv-cont,
    $curlpause-send,
    $curlpause-send-cont;

  // SSL backends

  create
    $curlsslbackend-axtls,
    $curlsslbackend-bearssl,
    $curlsslbackend-gnutls,
    $curlsslbackend-gskit,
    $curlsslbackend-mbedtls,
    $curlsslbackend-mesalink,
    $curlsslbackend-none,
    $curlsslbackend-nss,
    $curlsslbackend-obsolete4,
    $curlsslbackend-openssl,
    $curlsslbackend-polarssl,
    $curlsslbackend-rustls,
    $curlsslbackend-schannel,
    $curlsslbackend-securetransport,
    $curlsslbackend-wolfssl;

  // Curl option types
  
  create
    $curlopttype-blob,
    $curlopttype-boolean,
    $curlopttype-cbpoint,
    $curlopttype-functionpoint,
    $curlopttype-objectpoint,
    $curlopttype-offt,
    $curlopttype-slistpoint,
    $curlopttype-stringpoint,
    $curlopttype-values,
    $curlopttype-long;

  // Curl option types

  create
    $curlot-blob,
    $curlot-cbptr,
    $curlot-function,
    $curlot-long,
    $curlot-object,
    $curlot-offt,
    $curlot-slist,
    $curlot-string,
    $curlot-values;

  // Callable wrappers

  create
    $curl-debug-callback,
    $curl-header-callback,
    $curl-progress-callback,
    $curl-write-callback,
    *curl-debug-callback*,
    *curl-header-callback*,
    *curl-progress-callback*,
    *curl-write-callback*;

  /////////////////////////////////////////////////////////////////////////////
  //
  // Types.
  //
  // See: "lib-curl-easy-types.dylan"
  //
  /////////////////////////////////////////////////////////////////////////////

  create
    <curl-easy-handle>,
    <curl-easy-handle*>,
    <curl-option-id>;
  
  // Memory block with binary data
  
  create
    <curl-blob>,
    <curl-blob*>,
    curl-blob-data,
    curl-blob-data-setter,
    curl-blob-len,
    curl-blob-len-setter,
    curl-blob-flags,
    curl-blob-flags-setter;

  // TLS session info
  
  create
    <curl-tlssessioninfo>,
    <curl-tlssessioninfo*>,
    curl-tlssessioninfo-backend,
    curl-tlssessioninfo-backend-setter,
    curl-tlssessioninfo-internals,
    curl-tlssessioninfo-internals-setter;

  // Curl header

  create
    <curl-header>,
    <curl-header*>,
    curl-header-name,
    curl-header-value,
    curl-header-amount,
    curl-header-index,
    curl-header-origin,
    curl-header-anchor;

  // Curl slist
  
  create
    <curl-slist>,
    <curl-slist*>,
    curl-slist-data,
    curl-slist-next;

  // Certificate information

  create
    <curl-certinfo>,
    <curl-certinfo*>,
    curl-certinfo-num-of-certs,
    curl-certinfo-certinfo;

  // Information about an option

  create
    <curl-easy-option>,
    <curl-easy-option*>,
    curl-easy-option-name,
    curl-easy-option-id,
    curl-easy-option-type,
    curl-easy-option-flags;

  // Mapped types

  create
    <curl-boolean>;

  // Curl types to make easier the macros
  
  create
    <curlopt-long>,
    <curlopt-objectpoint>,
    <curlopt-functionpoint>,
    <curlopt-offt>,
    <curlopt-blob>,
    <curlopt-stringpoint>,
    <curlopt-slistpoint>,
    <curlopt-cbpoint>,
    <curlopt-values>,
    <curlopt-boolean>;

  create
    <curlinfo-string>,
    <curlinfo-long>,
    <curlinfo-double>,
    <curlinfo-slist>,
    <curlinfo-ptr>,
    <curlinfo-offt>;

  /////////////////////////////////////////////////////////////////////////////
  //
  // Functions. See: https://curl.se/libcurl/c/allfuncs.html
  //
  // (*): Curl discourage users from using any of these functions in
  // new applications
  //
  /////////////////////////////////////////////////////////////////////////////
  
  create
    curl-easy-cleanup,
    curl-easy-duphandle,
    curl-easy-escape,
    // curl-easy-getinfo see: "lib-curl-easy-getinfo.dylan"
    curl-easy-header,
    curl-easy-init,
    curl-easy-next-header,
    curl-easy-option-by-id,
    curl-easy-option-by-name,
    curl-easy-option-next,
    curl-easy-pause,
    curl-easy-perform,
    // TODO: curl-easy-recv,
    curl-easy-reset,
    curl-easy-send,
    // curl-easy-setopt see: "lib-curl-easy-options.dylan"
    curl-easy-strerror,
    curl-easy-unescape,
    curl-easy-upkeep,
    curl-free,
    curl-getdate,
    curl-getenv,
    curl-global-cleanup,
    curl-global-init,
    // TODO: curl-global-init-mem,
    // TODO: curl-global-sslset,
    // TODO: curl-global-trace,
    // curl-maprintf (*) 
    // curl-mfprintf (*)
    curl-mime-addpart,
    curl-mime-data,
    // TODO: curl-mime-data-cb
    // TODO: curl-mime-encoder
    // TODO: curl-mime-filedata
    curl-mime-filename,
    curl-mime-free,
    // TODO: curl-mime-headers
    curl-mime-init,
    curl-mime-name,
    // TODO: curl-mime-subparts
    // TODO: curl-mime-type
    // TODO: curl-msnprintf (*)
    // curl-multi-* see: "../multi/"
    // curl-mvaprintf (*)
    // curl-mvfprintf (*)
    // curl-mvprintf (*)
    // curl-mvsnprintf (*)
    // curl-mvsprintf (*)
    // TODO: curl-pushheader-byname
    // TODO: curl-pushheader-bynum
    // TODO: curl-share-cleanup
    // TODO: curl-share-init
    // TODO: curl-share-setopt
    // TODO: curl-share-strerror
    curl-slist-append,
    curl-slist-free-all,
    // curl-strequal is not imported
    // curl-strnequal is not imported
    // TODO: curl-unscape
    // TODO: curl-url
    // TODO: curl-url-cleanup
    // TODO: curl-url-dup
    // TODO: curl-url-get
    // TODO: curl-url-set
    // TODO: curl-url-strerror
    curl-version;
    // TODO: curl-version-info
    // TODO: curl-ws-meta
    // TODO: curl-ws-recv
    // TODO: curl-ws-send;

  // Curl errors
  create
    <curl-error>,
    curl-error-code,
    curl-error-message,
    <curl-init-error>;

  // Curl macros
  create
    with-curl-easy-handle,
    with-curl-global;

  // curl options (in alphabetical order)
  
  create
    curl-easy-setopt-abstract-unix-socket,
    curl-easy-setopt-accept-encoding,
    curl-easy-setopt-accepttimeout-ms,
    curl-easy-setopt-address-scope,
    curl-easy-setopt-altsvc,
    curl-easy-setopt-altsvc-ctrl,
    curl-easy-setopt-append,
    curl-easy-setopt-autoreferer,
    curl-easy-setopt-aws-sigv4,
    curl-easy-setopt-buffersize,
    curl-easy-setopt-ca-cache-timeout,
    curl-easy-setopt-cainfo,
    curl-easy-setopt-cainfo-blob,
    curl-easy-setopt-capath,
    curl-easy-setopt-certinfo,
    curl-easy-setopt-chunk-data,
    curl-easy-setopt-closesocketdata,
    curl-easy-setopt-closesocketfunction,
    curl-easy-setopt-connect-only,
    curl-easy-setopt-connect-to,
    curl-easy-setopt-connecttimeout,
    curl-easy-setopt-connecttimeout-ms,
    curl-easy-setopt-cookie,
    curl-easy-setopt-cookiefile,
    curl-easy-setopt-cookiejar,
    curl-easy-setopt-cookielist,
    curl-easy-setopt-cookiesession,
    curl-easy-setopt-copypostfields,
    curl-easy-setopt-copypostfields,
    curl-easy-setopt-crlf,
    curl-easy-setopt-crlfile,
    curl-easy-setopt-crlfile,
    curl-easy-setopt-curlu,
    curl-easy-setopt-customrequest,
    curl-easy-setopt-debugdata,
    curl-easy-setopt-debugfunction,
    curl-easy-setopt-debugfunction,
    curl-easy-setopt-default-protocol,
    curl-easy-setopt-dirlistonly,
    curl-easy-setopt-disallow-username-in-url,
    curl-easy-setopt-dns-cache-timeout,
    curl-easy-setopt-dns-cache-timeout,
    curl-easy-setopt-dns-interface,
    curl-easy-setopt-dns-local-ip4,
    curl-easy-setopt-dns-local-ip6,
    curl-easy-setopt-dns-servers,
    curl-easy-setopt-dns-shuffle-addresses,
    curl-easy-setopt-dns-use-global-cache,
    curl-easy-setopt-dns-use-global-cache,
    curl-easy-setopt-doh-ssl-verifyhost,
    curl-easy-setopt-doh-ssl-verifypeer,
    curl-easy-setopt-doh-ssl-verifystatus,
    curl-easy-setopt-doh-url,
    curl-easy-setopt-ech,
    curl-easy-setopt-egdsocket,
    curl-easy-setopt-errorbuffer,
    curl-easy-setopt-expect-100-timeout-ms,
    curl-easy-setopt-failonerror,
    curl-easy-setopt-filetime,
    curl-easy-setopt-fnmatch-data,
    curl-easy-setopt-followlocation,
    curl-easy-setopt-forbid-reuse,
    curl-easy-setopt-fresh-connect,
    curl-easy-setopt-ftp-account,
    curl-easy-setopt-ftp-alternative-to-user,
    curl-easy-setopt-ftp-create-missing-dirs,
    curl-easy-setopt-ftp-filemethod,
    curl-easy-setopt-ftp-skip-pasv-ip,
    curl-easy-setopt-ftp-ssl-ccc,
    curl-easy-setopt-ftp-use-eprt,
    curl-easy-setopt-ftp-use-epsv,
    curl-easy-setopt-ftp-use-pret,
    curl-easy-setopt-ftpport,
    curl-easy-setopt-ftpsslauth,
    curl-easy-setopt-gssapi-delegation,
    curl-easy-setopt-happy-eyeballs-timeout-ms,
    curl-easy-setopt-haproxy-client-ip,
    curl-easy-setopt-haproxyprotocol,
    curl-easy-setopt-header,
    curl-easy-setopt-headerdata,
    curl-easy-setopt-headerfunction,
    curl-easy-setopt-headeropt,
    curl-easy-setopt-hsts,
    curl-easy-setopt-hsts-ctrl,
    curl-easy-setopt-hstsreaddata,
    curl-easy-setopt-hstsreadfunction,
    curl-easy-setopt-hstswritedata,
    curl-easy-setopt-hstswritefunction,
    curl-easy-setopt-http-content-decoding,
    curl-easy-setopt-http-transfer-decoding,
    curl-easy-setopt-http-version,
    curl-easy-setopt-http09-allowed,
    curl-easy-setopt-http200aliases,
    curl-easy-setopt-httpauth,
    curl-easy-setopt-httpget,
    curl-easy-setopt-httpheader,
    curl-easy-setopt-httpproxytunnel,
    curl-easy-setopt-ignore-content-length,
    curl-easy-setopt-infilesize,
    curl-easy-setopt-infilesize-large,
    curl-easy-setopt-interface,
    curl-easy-setopt-ioctldata,
    curl-easy-setopt-ioctlfunction,
    curl-easy-setopt-ipresolve,
    curl-easy-setopt-issuercert,
    curl-easy-setopt-issuercert,
    curl-easy-setopt-issuercert-blob,
    curl-easy-setopt-keep-sending-on-error,
    curl-easy-setopt-keypasswd,
    curl-easy-setopt-krblevel,
    curl-easy-setopt-localport,
    curl-easy-setopt-localportrange,
    curl-easy-setopt-login-options,
    curl-easy-setopt-low-speed-limit,
    curl-easy-setopt-low-speed-time,
    curl-easy-setopt-mail-auth,
    curl-easy-setopt-mail-from,
    curl-easy-setopt-mail-rcpt,
    curl-easy-setopt-mail-rcpt-allowfails,
    curl-easy-setopt-max-recv-speed-large,
    curl-easy-setopt-max-send-speed-large,
    curl-easy-setopt-maxage-conn,
    curl-easy-setopt-maxconnects,
    curl-easy-setopt-maxfilesize,
    curl-easy-setopt-maxfilesize-large,
    curl-easy-setopt-maxlifetime-conn,
    curl-easy-setopt-maxredirs,
    curl-easy-setopt-mime-options,
    curl-easy-setopt-mimepost,
    curl-easy-setopt-netrc,
    curl-easy-setopt-netrc-file,
    curl-easy-setopt-new-directory-perms,
    curl-easy-setopt-new-file-perms,
    curl-easy-setopt-nobody,
    curl-easy-setopt-noprogress,
    curl-easy-setopt-noproxy,
    curl-easy-setopt-nosignal,
    curl-easy-setopt-opensocketdata,
    curl-easy-setopt-opensocketdata,
    curl-easy-setopt-opensocketfunction,
    curl-easy-setopt-opensocketfunction,
    curl-easy-setopt-password,
    curl-easy-setopt-path-as-is,
    curl-easy-setopt-pinnedpublickey,
    curl-easy-setopt-pipewait,
    curl-easy-setopt-port,
    curl-easy-setopt-post,
    curl-easy-setopt-postfields,
    curl-easy-setopt-postfieldsize,
    curl-easy-setopt-postfieldsize-large,
    curl-easy-setopt-postquote,
    curl-easy-setopt-postredir,
    curl-easy-setopt-postredir,
    curl-easy-setopt-pre-proxy,
    curl-easy-setopt-prequote,
    curl-easy-setopt-prequote,
    curl-easy-setopt-prereqdata,
    curl-easy-setopt-prereqfunction,
    curl-easy-setopt-private,
    curl-easy-setopt-progressfunction,
    curl-easy-setopt-protocols,
    curl-easy-setopt-protocols-str,
    curl-easy-setopt-proxy,
    curl-easy-setopt-proxy-cainfo,
    curl-easy-setopt-proxy-cainfo-blob,
    curl-easy-setopt-proxy-capath,
    curl-easy-setopt-proxy-crlfile,
    curl-easy-setopt-proxy-issuercert,
    curl-easy-setopt-proxy-issuercert-blob,
    curl-easy-setopt-proxy-keypasswd,
    curl-easy-setopt-proxy-pinnedpublickey,
    curl-easy-setopt-proxy-service-name,
    curl-easy-setopt-proxy-ssl-cipher-list,
    curl-easy-setopt-proxy-ssl-options,
    curl-easy-setopt-proxy-ssl-verifyhost,
    curl-easy-setopt-proxy-ssl-verifypeer,
    curl-easy-setopt-proxy-sslcert,
    curl-easy-setopt-proxy-sslcert-blob,
    curl-easy-setopt-proxy-sslcerttype,
    curl-easy-setopt-proxy-sslkey,
    curl-easy-setopt-proxy-sslkey-blob,
    curl-easy-setopt-proxy-sslkeytype,
    curl-easy-setopt-proxy-sslversion,
    curl-easy-setopt-proxy-tls13-ciphers,
    curl-easy-setopt-proxy-tlsauth-password,
    curl-easy-setopt-proxy-tlsauth-type,
    curl-easy-setopt-proxy-tlsauth-username,
    curl-easy-setopt-proxy-transfer-mode,
    curl-easy-setopt-proxy-transfer-mode,
    curl-easy-setopt-proxyauth,
    curl-easy-setopt-proxyheader,
    curl-easy-setopt-proxypassword,
    curl-easy-setopt-proxyport,
    curl-easy-setopt-proxytype,
    curl-easy-setopt-proxyusername,
    curl-easy-setopt-proxyuserpwd,
    curl-easy-setopt-put,
    curl-easy-setopt-quick-exit,
    curl-easy-setopt-quote,
    curl-easy-setopt-random-file,
    curl-easy-setopt-range,
    curl-easy-setopt-readdata,
    curl-easy-setopt-readfunction,
    curl-easy-setopt-redir-protocols,
    curl-easy-setopt-redir-protocols-str,
    curl-easy-setopt-referer,
    curl-easy-setopt-request-target,
    curl-easy-setopt-resolve,
    curl-easy-setopt-resolver-start-data,
    curl-easy-setopt-resolver-start-function,
    curl-easy-setopt-resume-from,
    curl-easy-setopt-resume-from-large,
    curl-easy-setopt-rtsp-request,
    curl-easy-setopt-rtsp-session-id,
    curl-easy-setopt-sasl-authzid,
    curl-easy-setopt-sasl-ir,
    curl-easy-setopt-seekdata,
    curl-easy-setopt-seekdata,
    curl-easy-setopt-seekfunction,
    curl-easy-setopt-seekfunction,
    curl-easy-setopt-server-response-timeout,
    curl-easy-setopt-server-response-timeout-ms,
    curl-easy-setopt-service-name,
    curl-easy-setopt-share,
    curl-easy-setopt-sockoptdata,
    curl-easy-setopt-sockoptfunction,
    curl-easy-setopt-socks5-auth,
    curl-easy-setopt-socks5-gssapi-nec,
    curl-easy-setopt-socks5-gssapi-service,
    curl-easy-setopt-ssh-auth-types,
    curl-easy-setopt-ssh-compression,
    curl-easy-setopt-ssh-host-public-key-md5,
    curl-easy-setopt-ssh-host-public-key-md5,
    curl-easy-setopt-ssh-host-public-key-sha256,
    curl-easy-setopt-ssh-hostkeydata,
    curl-easy-setopt-ssh-hostkeyfunction,
    curl-easy-setopt-ssh-keydata,
    curl-easy-setopt-ssh-keyfunction,
    curl-easy-setopt-ssh-knownhosts,
    curl-easy-setopt-ssh-private-keyfile,
    curl-easy-setopt-ssh-public-keyfile,
    curl-easy-setopt-ssl-cipher-list,
    curl-easy-setopt-ssl-ctx-data,
    curl-easy-setopt-ssl-ctx-function,
    curl-easy-setopt-ssl-ec-curves,
    curl-easy-setopt-ssl-enable-alpn,
    curl-easy-setopt-ssl-falsestart,
    curl-easy-setopt-ssl-options,
    curl-easy-setopt-ssl-sessionid-cache,
    curl-easy-setopt-ssl-verifyhost,
    curl-easy-setopt-ssl-verifypeer,
    curl-easy-setopt-ssl-verifystatus,
    curl-easy-setopt-sslcert,
    curl-easy-setopt-sslcert-blob,
    curl-easy-setopt-sslcerttype,
    curl-easy-setopt-sslengine,
    curl-easy-setopt-sslengine-default,
    curl-easy-setopt-sslkey-blob,
    curl-easy-setopt-sslkeytype,
    curl-easy-setopt-sslversion,
    curl-easy-setopt-stderr,
    curl-easy-setopt-stream-depends,
    curl-easy-setopt-stream-depends-e,
    curl-easy-setopt-stream-weight,
    curl-easy-setopt-suppress-connect-headers,
    curl-easy-setopt-tcp-fastopen,
    curl-easy-setopt-tcp-keepalive,
    curl-easy-setopt-tcp-keepcnt,
    curl-easy-setopt-tcp-keepidle,
    curl-easy-setopt-tcp-keepintvl,
    curl-easy-setopt-tcp-nodelay,
    curl-easy-setopt-telnetoptions,
    curl-easy-setopt-tftp-blksize,
    curl-easy-setopt-tftp-no-options,
    curl-easy-setopt-timecondition,
    curl-easy-setopt-timeout,
    curl-easy-setopt-timeout-ms,
    curl-easy-setopt-timevalue,
    curl-easy-setopt-timevalue-large,
    curl-easy-setopt-tls13-ciphers,
    curl-easy-setopt-tlsauth-password,
    curl-easy-setopt-tlsauth-type,
    curl-easy-setopt-tlsauth-username,
    curl-easy-setopt-trailerdata,
    curl-easy-setopt-trailerfunction,
    curl-easy-setopt-transfer-encoding,
    curl-easy-setopt-transfertext,
    curl-easy-setopt-unix-socket-path,
    curl-easy-setopt-unrestricted-auth,
    curl-easy-setopt-upkeep-interval-ms,
    curl-easy-setopt-upload,
    curl-easy-setopt-upload-buffersize,
    curl-easy-setopt-url,
    curl-easy-setopt-use-ssl,
    curl-easy-setopt-useragent,
    curl-easy-setopt-username,
    curl-easy-setopt-userpwd,
    curl-easy-setopt-verbose,
    curl-easy-setopt-writedata,
    curl-easy-setopt-writefunction,
    curl-easy-setopt-ws-options,
    curl-easy-setopt-xferinfodata,
    curl-easy-setopt-xferinfofunction,
    curl-easy-setopt-xoauth2-bearer;

  // Curlinfo options (in alphabetical order)
  
  create
    // TODO: curl-easy-getinfo-activesocket
    curl-easy-getinfo-appconnect-time,
    curl-easy-getinfo-appconnect-time-t,
    curl-easy-getinfo-cainfo,
    curl-easy-getinfo-capath,
    curl-easy-getinfo-certinfo,
    curl-easy-getinfo-condition-unmet,
    curl-easy-getinfo-conn-id,
    curl-easy-getinfo-connect-time,
    curl-easy-getinfo-connect-time-t,
    curl-easy-getinfo-content-length-download-t,
    curl-easy-getinfo-content-length-upload-t,
    curl-easy-getinfo-content-type,
    curl-easy-getinfo-cookielist,
    curl-easy-getinfo-earlydata-sent-t,
    curl-easy-getinfo-effective-method,
    curl-easy-getinfo-effective-url,
    curl-easy-getinfo-filetime-t,
    curl-easy-getinfo-ftp-entry-path,
    curl-easy-getinfo-header-size,
    curl-easy-getinfo-http-connectcode,
    curl-easy-getinfo-http-version,
    curl-easy-getinfo-httpauth-avail,
    curl-easy-getinfo-lastsocket,
    curl-easy-getinfo-local-ip,
    curl-easy-getinfo-local-port,
    curl-easy-getinfo-namelookup-time,
    curl-easy-getinfo-namelookup-time-t,
    curl-easy-getinfo-num-connects,
    curl-easy-getinfo-os-errno,
    curl-easy-getinfo-posttransfer-time-t,
    curl-easy-getinfo-pretransfer-time,
    curl-easy-getinfo-pretransfer-time-t,
    curl-easy-getinfo-primary-ip,
    curl-easy-getinfo-primary-port,
    curl-easy-getinfo-private,
    curl-easy-getinfo-protocol,
    curl-easy-getinfo-proxy-error,
    curl-easy-getinfo-proxy-ssl-verifyresult,
    curl-easy-getinfo-proxyauth-avail,
    curl-easy-getinfo-queue-time-t,
    curl-easy-getinfo-redirect-count,
    curl-easy-getinfo-redirect-time,
    curl-easy-getinfo-redirect-time-t,
    curl-easy-getinfo-redirect-url,
    curl-easy-getinfo-referer,
    curl-easy-getinfo-request-size,
    curl-easy-getinfo-response-code,
    curl-easy-getinfo-retry-after,
    curl-easy-getinfo-rtsp-client-cseq,
    curl-easy-getinfo-rtsp-cseq-recv,
    curl-easy-getinfo-rtsp-server-cseq,
    curl-easy-getinfo-rtsp-session-id,
    curl-easy-getinfo-scheme,
    curl-easy-getinfo-size-download-t,
    curl-easy-getinfo-size-upload-t,
    curl-easy-getinfo-speed-download-t,
    curl-easy-getinfo-speed-upload-t,
    curl-easy-getinfo-ssl-engines,
    curl-easy-getinfo-ssl-verifyresult,
    curl-easy-getinfo-starttransfer-time,
    curl-easy-getinfo-starttransfer-time-t,
    curl-easy-getinfo-tls-ssl-ptr,
    curl-easy-getinfo-total-time,
    curl-easy-getinfo-total-time-t,
    curl-easy-getinfo-used-proxy,
    curl-easy-getinfo-xfer-id;

end module lib-curl-easy;

define module %lib-curl-easy

  use lib-curl-easy;
  
  use common-dylan;
  use c-ffi;
  use format,
    import: { format-to-string };
  
end module;
