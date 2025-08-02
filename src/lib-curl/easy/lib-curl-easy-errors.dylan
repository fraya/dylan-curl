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

define abstract class <curl-error> (<error>)
  constant slot curl-error-code :: <integer>,
    required-init-keyword: code:;
  constant virtual slot curl-error-message :: <string>;
end;

define class <curl-easy-error> (<curl-error>)
end;

define method curl-error-message
    (err :: <curl-easy-error>)
 => (message :: <string>)
  curl-easy-strerror(err.curl-error-code)
end;

//
// Initialization errors
//

define class <curl-easy-init-error> (<curl-easy-error>)
  inherited slot curl-error-code,
    init-value: $curle-failed-init;
end;
