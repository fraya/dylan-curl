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
    // TODO: curl-easy-ssls-export
    curl-easy-strerror,
    curl-easy-unescape,
    curl-easy-upkeep,
    // TODO: curl-escape
    // TODO: curl-formadd
    // TODO: curl-formfree
    curl-free,
    // TODO: curl-getdate
    // TODO: curl-getenv
    curl-global-cleanup,
    curl-global-init,
    // TODO: curl-global-init-mem,
    // TODO: curl-global-sslset,
    // TODO: curl-global-trace,
    // curl-maprintf (*) 
    // curl-mfprintf (*)
    // TODO: curl-mime-addpart
    // TODO: curl-mime-data
    // TODO: curl-mime-data-cb
    // TODO: curl-mime-encoder
    // TODO: curl-mime-filedata
    // TODO: curl-mime-filename
    // TODO: curl-mime-free
    // TODO: curl-mime-headers
    // TODO: curl-mime-init
    // TODO: curl-mime-name
    // TODO: curl-mime-subparts
    // TODO: curl-mime-type
    // TODO: curl-printf
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
    // TODO: curl-strequal
    // TODO: curl-strnequal
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
    <curl-init-error>,
    <curl-init-callback-error>,
    <curl-option-error>,
    <curl-option-set-error>,
    <curl-option-unknown-error>,
    <curl-perform-error>,
    <curl-info-error>;

  // curl options (in alphabetical order)
  
  create
    curl-setopt-abstract-unix-socket,
    curl-setopt-accept-encoding,
    curl-setopt-accepttimeout-ms,
    curl-setopt-address-scope,
    curl-setopt-altsvc,
    curl-setopt-altsvc-ctrl,
    curl-setopt-append,
    curl-setopt-autoreferer,
    curl-setopt-aws-sigv4,
    curl-setopt-buffersize,
    curl-setopt-ca-cache-timeout,
    curl-setopt-cainfo,
    curl-setopt-cainfo-blob,
    curl-setopt-capath,
    curl-setopt-certinfo,
    curl-setopt-chunk-data,
    curl-setopt-closesocketdata,
    curl-setopt-closesocketfunction,
    curl-setopt-connect-only,
    curl-setopt-connect-to,
    curl-setopt-connecttimeout,
    curl-setopt-connecttimeout-ms,
    curl-setopt-cookie,
    curl-setopt-cookiefile,
    curl-setopt-cookiejar,
    curl-setopt-cookielist,
    curl-setopt-cookiesession,
    curl-setopt-copypostfields,
    curl-setopt-copypostfields,
    curl-setopt-crlf,
    curl-setopt-crlfile,
    curl-setopt-crlfile,
    curl-setopt-curlu,
    curl-setopt-customrequest,
    curl-setopt-debugdata,
    curl-setopt-debugfunction,
    curl-setopt-debugfunction,
    curl-setopt-default-protocol,
    curl-setopt-dirlistonly,
    curl-setopt-disallow-username-in-url,
    curl-setopt-dns-cache-timeout,
    curl-setopt-dns-cache-timeout,
    curl-setopt-dns-interface,
    curl-setopt-dns-local-ip4,
    curl-setopt-dns-local-ip6,
    curl-setopt-dns-servers,
    curl-setopt-dns-shuffle-addresses,
    curl-setopt-dns-use-global-cache,
    curl-setopt-dns-use-global-cache,
    curl-setopt-doh-ssl-verifyhost,
    curl-setopt-doh-ssl-verifypeer,
    curl-setopt-doh-ssl-verifystatus,
    curl-setopt-doh-url,
    curl-setopt-ech,
    curl-setopt-egdsocket,
    curl-setopt-errorbuffer,
    curl-setopt-expect-100-timeout-ms,
    curl-setopt-failonerror,
    curl-setopt-filetime,
    curl-setopt-fnmatch-data,
    curl-setopt-followlocation,
    curl-setopt-forbid-reuse,
    curl-setopt-fresh-connect,
    curl-setopt-ftp-account,
    curl-setopt-ftp-alternative-to-user,
    curl-setopt-ftp-create-missing-dirs,
    curl-setopt-ftp-filemethod,
    curl-setopt-ftp-skip-pasv-ip,
    curl-setopt-ftp-ssl-ccc,
    curl-setopt-ftp-use-eprt,
    curl-setopt-ftp-use-epsv,
    curl-setopt-ftp-use-pret,
    curl-setopt-ftpport,
    curl-setopt-ftpsslauth,
    curl-setopt-gssapi-delegation,
    curl-setopt-happy-eyeballs-timeout-ms,
    curl-setopt-haproxy-client-ip,
    curl-setopt-haproxyprotocol,
    curl-setopt-header,
    curl-setopt-headerdata,
    curl-setopt-headerfunction,
    curl-setopt-headeropt,
    curl-setopt-hsts,
    curl-setopt-hsts-ctrl,
    curl-setopt-hstsreaddata,
    curl-setopt-hstsreadfunction,
    curl-setopt-hstswritedata,
    curl-setopt-hstswritefunction,
    curl-setopt-http-content-decoding,
    curl-setopt-http-transfer-decoding,
    curl-setopt-http-version,
    curl-setopt-http09-allowed,
    curl-setopt-http200aliases,
    curl-setopt-httpauth,
    curl-setopt-httpget,
    curl-setopt-httpheader,
    curl-setopt-httpproxytunnel,
    curl-setopt-ignore-content-length,
    curl-setopt-infilesize,
    curl-setopt-infilesize-large,
    curl-setopt-interface,
    curl-setopt-ioctldata,
    curl-setopt-ioctlfunction,
    curl-setopt-ipresolve,
    curl-setopt-issuercert,
    curl-setopt-issuercert,
    curl-setopt-issuercert-blob,
    curl-setopt-keep-sending-on-error,
    curl-setopt-keypasswd,
    curl-setopt-krblevel,
    curl-setopt-localport,
    curl-setopt-localportrange,
    curl-setopt-login-options,
    curl-setopt-low-speed-limit,
    curl-setopt-low-speed-time,
    curl-setopt-mail-auth,
    curl-setopt-mail-from,
    curl-setopt-mail-rcpt,
    curl-setopt-mail-rcpt-allowfails,
    curl-setopt-max-recv-speed-large,
    curl-setopt-max-send-speed-large,
    curl-setopt-maxage-conn,
    curl-setopt-maxconnects,
    curl-setopt-maxfilesize,
    curl-setopt-maxfilesize-large,
    curl-setopt-maxlifetime-conn,
    curl-setopt-maxredirs,
    curl-setopt-mime-options,
    curl-setopt-mimepost,
    curl-setopt-netrc,
    curl-setopt-netrc-file,
    curl-setopt-new-directory-perms,
    curl-setopt-new-file-perms,
    curl-setopt-nobody,
    curl-setopt-noprogress,
    curl-setopt-noproxy,
    curl-setopt-nosignal,
    curl-setopt-opensocketdata,
    curl-setopt-opensocketdata,
    curl-setopt-opensocketfunction,
    curl-setopt-opensocketfunction,
    curl-setopt-password,
    curl-setopt-path-as-is,
    curl-setopt-pinnedpublickey,
    curl-setopt-pipewait,
    curl-setopt-port,
    curl-setopt-post,
    curl-setopt-postfields,
    curl-setopt-postfieldsize,
    curl-setopt-postfieldsize-large,
    curl-setopt-postquote,
    curl-setopt-postredir,
    curl-setopt-postredir,
    curl-setopt-pre-proxy,
    curl-setopt-prequote,
    curl-setopt-prequote,
    curl-setopt-prereqdata,
    curl-setopt-prereqfunction,
    curl-setopt-private,
    curl-setopt-progressfunction,
    curl-setopt-protocols,
    curl-setopt-protocols-str,
    curl-setopt-proxy,
    curl-setopt-proxy-cainfo,
    curl-setopt-proxy-cainfo-blob,
    curl-setopt-proxy-capath,
    curl-setopt-proxy-crlfile,
    curl-setopt-proxy-issuercert,
    curl-setopt-proxy-issuercert-blob,
    curl-setopt-proxy-keypasswd,
    curl-setopt-proxy-pinnedpublickey,
    curl-setopt-proxy-service-name,
    curl-setopt-proxy-ssl-cipher-list,
    curl-setopt-proxy-ssl-options,
    curl-setopt-proxy-ssl-verifyhost,
    curl-setopt-proxy-ssl-verifypeer,
    curl-setopt-proxy-sslcert,
    curl-setopt-proxy-sslcert-blob,
    curl-setopt-proxy-sslcerttype,
    curl-setopt-proxy-sslkey,
    curl-setopt-proxy-sslkey-blob,
    curl-setopt-proxy-sslkeytype,
    curl-setopt-proxy-sslversion,
    curl-setopt-proxy-tls13-ciphers,
    curl-setopt-proxy-tlsauth-password,
    curl-setopt-proxy-tlsauth-type,
    curl-setopt-proxy-tlsauth-username,
    curl-setopt-proxy-transfer-mode,
    curl-setopt-proxy-transfer-mode,
    curl-setopt-proxyauth,
    curl-setopt-proxyheader,
    curl-setopt-proxypassword,
    curl-setopt-proxyport,
    curl-setopt-proxytype,
    curl-setopt-proxyusername,
    curl-setopt-proxyuserpwd,
    curl-setopt-put,
    curl-setopt-quick-exit,
    curl-setopt-quote,
    curl-setopt-random-file,
    curl-setopt-range,
    curl-setopt-readdata,
    curl-setopt-readfunction,
    curl-setopt-redir-protocols,
    curl-setopt-redir-protocols-str,
    curl-setopt-referer,
    curl-setopt-request-target,
    curl-setopt-resolve,
    curl-setopt-resolver-start-data,
    curl-setopt-resolver-start-function,
    curl-setopt-resume-from,
    curl-setopt-resume-from-large,
    curl-setopt-rtsp-request,
    curl-setopt-rtsp-session-id,
    curl-setopt-sasl-authzid,
    curl-setopt-sasl-ir,
    curl-setopt-seekdata,
    curl-setopt-seekdata,
    curl-setopt-seekfunction,
    curl-setopt-seekfunction,
    curl-setopt-server-response-timeout,
    curl-setopt-server-response-timeout-ms,
    curl-setopt-service-name,
    curl-setopt-share,
    curl-setopt-sockoptdata,
    curl-setopt-sockoptfunction,
    curl-setopt-socks5-auth,
    curl-setopt-socks5-gssapi-nec,
    curl-setopt-socks5-gssapi-service,
    curl-setopt-ssh-auth-types,
    curl-setopt-ssh-compression,
    curl-setopt-ssh-host-public-key-md5,
    curl-setopt-ssh-host-public-key-md5,
    curl-setopt-ssh-host-public-key-sha256,
    curl-setopt-ssh-hostkeydata,
    curl-setopt-ssh-hostkeyfunction,
    curl-setopt-ssh-keydata,
    curl-setopt-ssh-keyfunction,
    curl-setopt-ssh-knownhosts,
    curl-setopt-ssh-private-keyfile,
    curl-setopt-ssh-public-keyfile,
    curl-setopt-ssl-cipher-list,
    curl-setopt-ssl-ctx-data,
    curl-setopt-ssl-ctx-function,
    curl-setopt-ssl-ec-curves,
    curl-setopt-ssl-enable-alpn,
    curl-setopt-ssl-falsestart,
    curl-setopt-ssl-options,
    curl-setopt-ssl-sessionid-cache,
    curl-setopt-ssl-verifyhost,
    curl-setopt-ssl-verifypeer,
    curl-setopt-ssl-verifystatus,
    curl-setopt-sslcert,
    curl-setopt-sslcert-blob,
    curl-setopt-sslcerttype,
    curl-setopt-sslengine,
    curl-setopt-sslengine-default,
    curl-setopt-sslkey-blob,
    curl-setopt-sslkeytype,
    curl-setopt-sslversion,
    curl-setopt-stderr,
    curl-setopt-stream-depends,
    curl-setopt-stream-depends-e,
    curl-setopt-stream-weight,
    curl-setopt-suppress-connect-headers,
    curl-setopt-tcp-fastopen,
    curl-setopt-tcp-keepalive,
    curl-setopt-tcp-keepcnt,
    curl-setopt-tcp-keepidle,
    curl-setopt-tcp-keepintvl,
    curl-setopt-tcp-nodelay,
    curl-setopt-telnetoptions,
    curl-setopt-tftp-blksize,
    curl-setopt-tftp-no-options,
    curl-setopt-timecondition,
    curl-setopt-timeout,
    curl-setopt-timeout-ms,
    curl-setopt-timevalue,
    curl-setopt-timevalue-large,
    curl-setopt-tls13-ciphers,
    curl-setopt-tlsauth-password,
    curl-setopt-tlsauth-type,
    curl-setopt-tlsauth-username,
    curl-setopt-trailerdata,
    curl-setopt-trailerfunction,
    curl-setopt-transfer-encoding,
    curl-setopt-transfertext,
    curl-setopt-unix-socket-path,
    curl-setopt-unrestricted-auth,
    curl-setopt-upkeep-interval-ms,
    curl-setopt-upload,
    curl-setopt-upload-buffersize,
    curl-setopt-url,
    curl-setopt-use-ssl,
    curl-setopt-useragent,
    curl-setopt-username,
    curl-setopt-userpwd,
    curl-setopt-verbose,
    curl-setopt-writedata,
    curl-setopt-writefunction,
    curl-setopt-ws-options,
    curl-setopt-xferinfodata,
    curl-setopt-xferinfofunction,
    curl-setopt-xoauth2-bearer;

  // Curlinfo options (in alphabetical order)
  
  create
    // TODO: curl-activesocket
    curl-appconnect-time,
    curl-appconnect-time-t,
    curl-cainfo,
    curl-capath,
    curl-certinfo,
    curl-condition-unmet,
    curl-conn-id,
    curl-connect-time,
    curl-connect-time-t,
    curl-content-length-download-t,
    curl-content-length-upload-t,
    curl-content-type,
    curl-cookielist,
    curl-earlydata-sent-t,
    curl-effective-method,
    curl-effective-url,
    curl-filetime-t,
    curl-ftp-entry-path,
    curl-header-size,
    curl-http-connectcode,
    curl-http-version,
    curl-httpauth-avail,
    curl-lastsocket,
    curl-local-ip,
    curl-local-port,
    curl-namelookup-time,
    curl-namelookup-time-t,
    curl-num-connects,
    curl-os-errno,
    curl-posttransfer-time-t,
    curl-pretransfer-time,
    curl-pretransfer-time-t,
    curl-primary-ip,
    curl-primary-port,
    curl-private,
    curl-protocol,
    curl-proxy-error,
    curl-proxy-ssl-verifyresult,
    curl-proxyauth-avail,
    curl-queue-time-t,
    curl-redirect-count,
    curl-redirect-time,
    curl-redirect-time-t,
    curl-redirect-url,
    curl-referer,
    curl-request-size,
    curl-response-code,
    curl-retry-after,
    curl-rtsp-client-cseq,
    curl-rtsp-cseq-recv,
    curl-rtsp-server-cseq,
    curl-rtsp-session-id,
    curl-scheme,
    curl-size-download-t,
    curl-size-upload-t,
    curl-speed-download-t,
    curl-speed-upload-t,
    curl-ssl-engines,
    curl-ssl-verifyresult,
    curl-starttransfer-time,
    curl-starttransfer-time-t,
    curl-tls-ssl-ptr,
    curl-total-time,
    curl-total-time-t,
    curl-used-proxy,
    curl-xfer-id;

end module lib-curl-easy;

define module %lib-curl-easy
  use lib-curl-easy;
  
  use common-dylan;
  use c-ffi;
  use format,
    import: { format-to-string };
//   use format-out;

//   export
//     *curl-library-initialized?*,
//     <curl-easy-handle>,
//     <curl-easy-handle*>,
//     curl-easy-handle,
//     c-curl-free;

//   export
//     <curl-boolean>;


end module;
