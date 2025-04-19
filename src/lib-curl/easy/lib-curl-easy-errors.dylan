Module:      %lib-curl-easy
Synopsis:    Libcurl "curl-easy" errors
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

///////////////////////////////////////////////////////////////////////////////
//
//
//
///////////////////////////////////////////////////////////////////////////////

define class <curl-error> (<error>)
  constant slot curl-error-code :: <integer>,
    required-init-keyword: curle:;
  constant virtual slot curl-error-message :: <string>;
end;

define method curl-error-message
    (err :: <curl-error>)
 => (message :: <string>)
  curl-easy-strerror(err.curl-error-code)
end;

//
// Initialization errors
//

define class <curl-init-error> (<curl-error>)
  inherited slot curl-error-code,
    init-value: $curle-failed-init;
end;
