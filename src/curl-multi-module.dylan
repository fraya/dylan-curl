Module: dylan-user

define module curl-multi
  
  // curl multi error codes

  create
    $curlm-call-multi-perform,
    $curlm-ok,
    $curlm-bad-handle,
    $curlm-bad-easy-handle,
    $curlm-out-of-memory,
    $curlm-internal-error,
    $curlm-bad-socket,
    $curlm-unknown-option,
    $curlm-added-already,
    $curlm-recursive-api-call,
    $curlm-wakeup-failure,
    $curlm-bad-function-argument,
    $curlm-aborted-by-callback,
    $curlm-unrecoverable-poll;

  // curlmsg

  create
    <curlmsg>,
    <curlmsg*>,
    curlmsg-msg,
    curlmsg-easy-handle,
    curlmsg-data,
    curlmsg-done?,
    curlmsg-none?;

  // curlmsg data

  create
    <curlmsg-data>,
    curlmsg-data-whatever,
    curlmsg-data-result;

  // curl-waitfd
  
  create
    <curl-waitfd>,
    curl-waitfd-fd,
    curl-waitfd-events,
    curl-waitfd-revents;

  create
    <curl-multi-error>,
    <curl-multi-option-error>,
    <curl-multi-perform-error>;

  create
    <curl-multi>,
    with-curl-multi;

  create
    curl-multi-cleanup,
    // curl-multi-get-handles,
    curl-multi-info-read,
    curl-multi-perform,
    curl-multi-poll,
    curl-multi-wait;

  create
    curl-multi-add!,
    curl-multi-remove!;

  // Option setters

  create
    curl-multi-socketfunction-setter,
    curl-multi-socketdata-setter,
    curl-multi-pipelining-setter,
    curl-multi-timerfunction-setter,
    curl-multi-timerdata-setter,
    curl-multi-maxconnects-setter,
    curl-multi-max-host-connections-setter,
    curl-multi-max-pipeline-length-setter,
    curl-multi-content-length-penalty-size-setter,
    curl-multi-chunk-length-penalty-size-setter,
    curl-multi-pipelining-site-bl-setter,
    curl-multi-pipelining-server-bl-setter,
    curl-multi-max-total-connections-setter,
    curl-multi-pushfunction-setter,
    curl-multi-pushdata-setter,
    curl-multi-max-concurrent-streams-setter;

end module curl-multi;

define module curl-multi-impl
  use curl-easy;
  use curl-easy-impl;
  use curl-multi;

  use common-dylan;
  use c-ffi;
  use format;
  use format-out;
end module;
