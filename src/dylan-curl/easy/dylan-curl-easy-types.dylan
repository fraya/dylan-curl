Module:      %dylan-curl-easy
Synopsis:    Dylan "curl-easy" datatypes
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

define class <curl-easy> (<object>)
  constant slot curl-easy-handle :: <curl-easy-handle> = curl-easy-init(),
    init-keyword: handle:;
  constant slot curl-easy-debug-callback :: <function> = %null-debug-callback,
    init-keyword: debug-callback:;
  constant slot curl-easy-progress-callback :: <function> = %null-progress-callback,
    init-keyword: progress-callback:;
  constant slot curl-easy-write-callback :: <function> = default-write-callback,
    init-keyword: write-callback:;
  slot curl-easy-write-data-stream :: <stream> = *standard-output*,
    init-keyword: write-data-stream:;
end;

define method make
    (class == <curl-easy>, #rest options, #key)
 => (curl :: <curl-easy>)

  let curl = next-method();

  // check that slot has been initialized
  
  if (null-pointer?(curl.curl-easy-handle))
    error(make(<curl-init-error>))
  end;
  
  // Set all curl options passed as keywords
  // `options` contains a vector with keywords and values, e.g.
  // ..., #"url", "http://example.com", ...
  // if the keyword is recognized as a curl option call the setter
  // curl-url-setter("http://example.com", curl)
  //
  
  for (i from 0 below options.size - 1 by 2)
    let keyword = options[i];
    let value   = options[i + 1];
    let setter  = element(*curl-option-setters*, keyword, default: #f);
    if (setter)
      setter(value, curl)
    end;
  end for;  

  // Set callback functions

  curl.curl-easy-debugfunction    := $curl-debug-callback;
  curl.curl-easy-xferinfofunction := $curl-progress-callback;
  curl.curl-easy-writefunction    := $curl-write-callback;

  curl
end;
