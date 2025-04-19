Module:      %dylan-curl-easy
Synopsis:    Dylan "curl-easy" datatypes
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

define class <curl-easy> (<object>)
  constant slot curl-easy-handle :: <curl-easy-handle>
    = curl-easy-init(),
    init-keyword: handle:;
end;

define method make
    (class == <curl-easy>, #rest options, #key)
 => (curl :: <curl-easy>)

  // Assign slot default initialization or values passed with
  // 'options'

  let curl = next-method();

  // check that slot has been initialized
  
  if (null-pointer?(curl.curl-easy-handle))
    error(make(<curl-init-error>))
  end;

  
  // ..., #"url", "http://example.com", ...
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
  
  curl
end;
