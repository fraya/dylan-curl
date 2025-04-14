Module: dylan-user

define module lib-curl-multi
  
  // curl multi error codes

  create
    $curlm-aborted-by-callback,
    $curlm-added-already,
    $curlm-bad-easy-handle,
    $curlm-bad-function-argument,
    $curlm-bad-handle,
    $curlm-bad-socket,
    $curlm-call-multi-perform,
    $curlm-internal-error,
    $curlm-ok,
    $curlm-out-of-memory,
    $curlm-recursive-api-call,
    $curlm-unknown-option,
    $curlm-unrecoverable-poll,
    $curlm-wakeup-failure;

  // curlmsg

  create
    $curlmsg-done,
    $curlmsg-none;

  create
    <curl-multi-handle>,
    <curlm-code>;
  
  create
    <curlmsg>,
    <curlmsg*>,
    curlmsg-msg,
    curlmsg-curl-easy-handle,
    curlmsg-data;
  
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
    curl-multi-add-handle,
    curl-multi-cleanup,
    curl-multi-get-handles,
    curl-multi-info-read,
    curl-multi-init,
    curl-multi-perform,
    curl-multi-poll,
    curl-multi-remove-handle,
    curl-multi-strerror,
    curl-multi-wait;

  // create
  //   <curl-multi-error>,
  //   <curl-multi-option-error>,
  //   <curl-multi-perform-error>;


  // create
  //   curl-multi-add!,
  //   curl-multi-remove!;

  // // Option setters

  // create
  //   curl-multi-socketfunction-setter,
  //   curl-multi-socketdata-setter,
  //   curl-multi-pipelining-setter,
  //   curl-multi-timerfunction-setter,
  //   curl-multi-timerdata-setter,
  //   curl-multi-maxconnects-setter,
  //   curl-multi-max-host-connections-setter,
  //   curl-multi-max-pipeline-length-setter,
  //   curl-multi-content-length-penalty-size-setter,
  //   curl-multi-chunk-length-penalty-size-setter,
  //   curl-multi-pipelining-site-bl-setter,
  //   curl-multi-pipelining-server-bl-setter,
  //   curl-multi-max-total-connections-setter,
  //   curl-multi-pushfunction-setter,
  //   curl-multi-pushdata-setter,
  //   curl-multi-max-concurrent-streams-setter;

end module;

define module %lib-curl-multi
  use lib-curl-multi;
  use lib-curl-easy,
    import: { <curl-easy-handle>,
              <curl-easy-handle*> };

  use common-dylan;
  use c-ffi;
end module;
