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
  let curle = lib-curl/curl-easy-perform(curl.curl-easy-handle);
  if (curle ~= $curle-ok)
    make(<curl-error>, curle: curle)
  end
end;
