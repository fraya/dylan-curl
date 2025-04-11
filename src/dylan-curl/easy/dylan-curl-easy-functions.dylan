Module:      %dylan-curl-easy
Synopsis:    Dylan "curl-easy" functions
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

define generic curl-easy-cleanup
  (curl :: <curl-easy>) => ();

define generic curl-easy-perform
  (curl :: <curl-easy>) => ();

define method curl-easy-cleanup
    (curl :: <curl-easy>) => ()
  lib-curl/curl-easy-cleanup(curl.curl-easy-handle)
end;

define method curl-easy-perform
    (curl :: <curl-easy>) => ()
  dynamic-bind(*curl-write-callback*    = curl.curl-easy-write-callback,
               *curl-progress-callback* = curl.curl-easy-progress-callback,
               *curl-debug-callback*    = curl.curl-easy-debug-callback)

    // export dylan stream to C language to write data in it
    let stream = curl.curl-easy-write-data-stream;
    register-c-dylan-object(stream);
    curl.curl-easy-writedata := export-c-dylan-object(stream);

    // perform request
    let curle = lib-curl/curl-easy-perform(curl.curl-easy-handle);
    if (curle ~= $curle-ok)
      make(<curl-error>, curle: curle)
    end;

    unregister-c-dylan-object(curl.curl-easy-write-data-stream);
  end dynamic-bind;
end;
