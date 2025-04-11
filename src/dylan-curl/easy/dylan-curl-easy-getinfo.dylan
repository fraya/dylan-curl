Module:      %dylan-curl-easy
Synopsis:    curl-easy-getinfo option definitions
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.
Comment:     Generates a getter method for each getinfo option
             See "dylan-curl-easy-macros.dylan"

define curl-easy-getinfo-options
  effective-url             :: <curlinfo-string>;
  response-code             :: <curlinfo-long>;
  total-time                :: <curlinfo-double>;
  namelookup-time           :: <curlinfo-double>;
  connect-time              :: <curlinfo-double>;
  pretransfer-time          :: <curlinfo-double>;
  size-upload-t             :: <curlinfo-offt>;
  size-download-t           :: <curlinfo-offt>;
  speed-download-t          :: <curlinfo-offt>;
  speed-upload-t            :: <curlinfo-offt>;
  header-size               :: <curlinfo-long>;
  request-size              :: <curlinfo-long>;
  ssl-verifyresult          :: <curlinfo-long>;
  filetime-t                :: <curlinfo-offt>;
  content-length-download-t :: <curlinfo-offt>;
  content-length-upload-t   :: <curlinfo-offt>;
  starttransfer-time        :: <curlinfo-double>;
  content-type              :: <curlinfo-string>;
  redirect-time             :: <curlinfo-double>;
  redirect-count            :: <curlinfo-long>;
  private                   :: <curlinfo-string>;
  http-connectcode          :: <curlinfo-long>;
  httpauth-avail            :: <curlinfo-long>;
  proxyauth-avail           :: <curlinfo-long>;
  os-errno                  :: <curlinfo-long>;
  num-connects              :: <curlinfo-long>;
  ssl-engines               :: <curlinfo-slist>;
  cookielist                :: <curlinfo-slist>;
  lastsocket                :: <curlinfo-long>;
  ftp-entry-path            :: <curlinfo-string>;
  redirect-url              :: <curlinfo-string>;
  primary-ip                :: <curlinfo-string>;
  appconnect-time           :: <curlinfo-double>;
  certinfo                  :: <curlinfo-ptr>;
  condition-unmet           :: <curlinfo-long>;
  rtsp-session-id           :: <curlinfo-string>;
  rtsp-client-cseq          :: <curlinfo-long>;
  rtsp-server-cseq          :: <curlinfo-long>;
  rtsp-cseq-recv            :: <curlinfo-long>;
  primary-port              :: <curlinfo-long>;
  local-ip                  :: <curlinfo-string>;
  local-port                :: <curlinfo-long>;
  // TODO:   socket activesocket
  tls-ssl-ptr               :: <curlinfo-ptr>;
  http-version              :: <curlinfo-long>;
  proxy-ssl-verifyresult    :: <curlinfo-long>;
  protocol                  :: <curlinfo-long>;
  scheme                    :: <curlinfo-string>;
  total-time-t              :: <curlinfo-offt>;
  namelookup-time-t         :: <curlinfo-offt>;
  connect-time-t            :: <curlinfo-offt>;
  pretransfer-time-t        :: <curlinfo-offt>;
  starttransfer-time-t      :: <curlinfo-offt>;
  redirect-time-t           :: <curlinfo-offt>;
  appconnect-time-t         :: <curlinfo-offt>;
  retry-after               :: <curlinfo-offt>;
  effective-method          :: <curlinfo-string>;
  proxy-error               :: <curlinfo-long>;
  referer                   :: <curlinfo-string>;
  cainfo                    :: <curlinfo-string>;
  capath                    :: <curlinfo-string>;
  xfer-id                   :: <curlinfo-offt>;
  conn-id                   :: <curlinfo-offt>;
  queue-time-t              :: <curlinfo-offt>;
  used-proxy                :: <curlinfo-long>;
  posttransfer-time-t       :: <curlinfo-offt>;
  earlydata-sent-t          :: <curlinfo-offt>;
end curl-easy-getinfo-options;
