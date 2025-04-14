Module:      %lib-curl-easy
Synopsis:    Libcurl "curl-easy" curlinfo options definition
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.
Reference:   See "lib-curl-easy-macros.dylan"

define curlinfo string effective-url             = 1;
define curlinfo long   response-code             = 2;
define curlinfo double total-time                = 3;
define curlinfo double namelookup-time           = 4;
define curlinfo double connect-time              = 5;
define curlinfo double pretransfer-time          = 6;
define curlinfo offt   size-upload-t             = 7;
define curlinfo offt   size-download-t           = 8;
define curlinfo offt   speed-download-t          = 9;
define curlinfo offt   speed-upload-t            = 10;
define curlinfo long   header-size               = 11;
define curlinfo long   request-size              = 12;
define curlinfo long   ssl-verifyresult          = 13;
define curlinfo offt   filetime-t                = 14;
define curlinfo offt   content-length-download-t = 15;
define curlinfo offt   content-length-upload-t   = 16;
define curlinfo double starttransfer-time        = 17;
define curlinfo string content-type              = 18;
define curlinfo double redirect-time             = 19;
define curlinfo long   redirect-count            = 20;
define curlinfo string private                   = 21;
define curlinfo long   http-connectcode          = 22;
define curlinfo long   httpauth-avail            = 23;
define curlinfo long   proxyauth-avail           = 24;
define curlinfo long   os-errno                  = 25;
define curlinfo long   num-connects              = 26;
define curlinfo slist  ssl-engines               = 27;
define curlinfo slist  cookielist                = 28;
define curlinfo long   lastsocket                = 29;
define curlinfo string ftp-entry-path            = 30;
define curlinfo string redirect-url              = 31;
define curlinfo string primary-ip                = 32;
define curlinfo double appconnect-time           = 33;
define curlinfo ptr    certinfo                  = 34;
define curlinfo long   condition-unmet           = 35;
define curlinfo string rtsp-session-id           = 36;
define curlinfo long   rtsp-client-cseq          = 37;
define curlinfo long   rtsp-server-cseq          = 38;
define curlinfo long   rtsp-cseq-recv            = 39;
define curlinfo long   primary-port              = 40;
define curlinfo string local-ip                  = 41;
define curlinfo long   local-port                = 42;
// deprecated: tls-session = 43;
// TODO: define curlinfo socket activesocket = 44;
define curlinfo ptr    tls-ssl-ptr               = 45;
define curlinfo long   http-version              = 46;
define curlinfo long   proxy-ssl-verifyresult    = 47;
define curlinfo long   protocol                  = 48;
define curlinfo string scheme                    = 49;
define curlinfo offt   total-time-t              = 50;
define curlinfo offt   namelookup-time-t         = 51;
define curlinfo offt   connect-time-t            = 52;
define curlinfo offt   pretransfer-time-t        = 53;
define curlinfo offt   starttransfer-time-t      = 54;
define curlinfo offt   redirect-time-t           = 55;
define curlinfo offt   appconnect-time-t         = 56;
define curlinfo offt   retry-after               = 57;
define curlinfo string effective-method          = 58;
define curlinfo long   proxy-error               = 59;
define curlinfo string referer                   = 60;
define curlinfo string cainfo                    = 61;
define curlinfo string capath                    = 62;
define curlinfo offt   xfer-id                   = 63;
define curlinfo offt   conn-id                   = 64;
define curlinfo offt   queue-time-t              = 65;
define curlinfo long   used-proxy                = 66;
define curlinfo offt   posttransfer-time-t       = 67;
define curlinfo offt   earlydata-sent-t          = 68;
