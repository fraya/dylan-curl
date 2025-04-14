Module:      %lib-curl-easy
Synopsis:    Libcurl "curl-easy" errors
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

define abstract class <curl-error> (<error>)
  constant slot curl-error-code :: <integer>,
    required-init-keyword: code:;
  constant virtual slot curl-error-message :: <string>;
end;

define generic curl-error-message
  (err :: <curl-error>) => (message :: <string>);

define method curl-error-message
    (err :: <curl-error>) => (message :: <string>)
  curl-easy-strerror(err.curl-error-code)
end;

define method as
    (type == <string>, err :: <curl-error>)
 => (string :: <string>)
  curl-error-message(err)
end;

//
// Initialization errors
//

define class <curl-init-error> (<curl-error>)
  inherited slot curl-error-code, init-value: $curle-failed-init;
end;

define class <curl-init-callback-error> (<curl-init-error>)
  constant slot curl-error-callback :: <string>,
    required-init-keyword: callback:;
end;

define method curl-error-message
    (err :: <curl-init-callback-error>) => (message :: <string>)
  format-to-string("%s: %s", next-method(), err.curl-error-callback)
end;

//
// Option related errors
//

define abstract class <curl-option-error> (<curl-error>) end;

// Error produced when an option is set

define class <curl-option-set-error> (<curl-option-error>) end;

// Error produced trying to set an option that does not exists

define class <curl-option-unknown-error> (<curl-option-error>)
  inherited slot curl-error-code = $curle-unknown-option;
  constant slot curl-error-keyword :: <symbol>,
    required-init-keyword: keyword:;
end;

define method curl-error-message
    (err :: <curl-option-unknown-error>) => (message :: <string>)
  format-to-string("%s: %=", next-method(), err.curl-error-keyword)
end;

// Error produced performing the request

define class <curl-perform-error> (<curl-error>) end;

// Error produced trying to get information about the request

define class <curl-info-error> (<curl-error>) end;

