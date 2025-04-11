Module:      %lib-curl-easy
Synopsis:    Libcurl "curl-easy" macros
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

//////////////////////////////////////////////////////////////////////////////
//
// `curl-easy-setopt` shim functions.
//
// A "shim" function is created for each `$curl-setopt-xxx` constant to
// streamline the process of working with the variadic function
// `curl_easy_setopt`.
//
// See: "lib-curl-easy-setopt-shim.dylan"
//
//////////////////////////////////////////////////////////////////////////////

define macro shim-curl-setopt-definer
  { define shim-curl-setopt ?:name ?type:expression }
    => { define C-function "curl-setopt-" ## ?name
           input parameter handle :: <curl-easy-handle>;
           input parameter option :: <curl-option-id>;
           input parameter value  :: ?type;
           result curl-code :: <C-int>;
           c-name: "curl_setopt_" ?"name";
         end C-function; }
end macro;

//////////////////////////////////////////////////////////////////////////////
//
// The `curlopt-definer` macro serves two purposes:
//
// 1. Defines a constant for each identifier by adding the base index
//    to the identifier's numeric value.
//
// 2. Creates a function to set the option.
//    This function calls the corresponding shim function and checks
//    the status code to handle errors appropriately.
//
//////////////////////////////////////////////////////////////////////////////

define macro curlopt-definer
  { define curlopt ?type:name ?id:name = ?number:expression }
    => { define constant "$curlopt-" ## ?id
           = "$curlopttype-" ## ?type + ?number;

         define function "curl-easy-setopt-" ## ?id
             (handle :: <curl-easy-handle>, option :: "<curlopt-" ## ?type ## ">")
          => (curl-code :: <integer>)
           "curl-setopt-" ## ?type (handle, "$curlopt-" ## ?id, option);
         end }
end macro;

//////////////////////////////////////////////////////////////////////////////
//
// `curl-easy-getinfo` shim functions.
//
// A "shim" function is created for each `$curlinfo-xxx` constant to
// streamline the process of working with the variadic function
// `curl_easy_getinfo`.
//
//////////////////////////////////////////////////////////////////////////////

define macro shim-curl-getinfo-definer
  { define shim-curl-getinfo ?:name ?type:expression }
    => { define C-function "curl-easy-getinfo-" ## ?name
           input  parameter handle    :: <curl-easy-handle>;
           input  parameter option    :: <curl-info-option-id>;
           output parameter curl-code :: <C-int*>;
           result value :: ?type;
           c-name: "curl_easy_getinfo_" ?"name";
         end C-function; }
end macro;

//////////////////////////////////////////////////////////////////////////////
//
// The `curlinfo-definer` macro serves two purposes:
//
// 1. Defines a constant for each identifier by adding the base index
//    to the identifier's numeric value.
// 2. Creates a function to retrieve information about the identifier.
//    This function calls the corresponding shim function and checks
//    the status code to handle errors appropriately.
//
//////////////////////////////////////////////////////////////////////////////

define macro curlinfo-definer
  { define curlinfo ?type:name ?id:name = ?number:expression }
    => { define constant "$curlinfo-" ## ?id
           = "$curlinfo-" ## ?type + ?number;

         define function "curl-easy-getinfo-" ## ?id
              (handle :: <curl-easy-handle>)
           => (result :: "<curlinfo-" ## ?type ## ">", curl-code :: <integer>)
            "curl-easy-getinfo-" ## ?type (handle, "$curlinfo-" ## ?id);
         end }
end macro;

///////////////////////////////////////////////////////////////////////////////
//
// with-curl-easy-handle:
//
// Macro to release a handle.
//
///////////////////////////////////////////////////////////////////////////////

define macro with-curl-easy-handle
  { with-curl-easy-handle (?curl:variable) ?body:body end }
    => { with-curl-easy-handle (?curl = curl-easy-init()) ?body end }
  { with-curl-easy-handle (?curl:variable = ?handler:expression) ?body:body end }
    => { let _curl = #f;
         block ()
           _curl := ?handler;
           let ?curl :: <curl-easy-handle> = _curl;
           if (null-pointer?(?curl))
             error(make(<curl-init-error>))
           end;
           ?body
         cleanup
           if (_curl)
             curl-easy-cleanup(_curl)
           end;
         end block }
end macro;

///////////////////////////////////////////////////////////////////////////////
//
// with-curl-global:
//
// Macro to global initialization and release of the library.
//
///////////////////////////////////////////////////////////////////////////////

define macro with-curl-global
  { with-curl-global () ?body:body end }
    => { with-curl-global($curl-global-default) ?body end }
  { with-curl-global (?flags:expression) ?body:body end }
    => { let code = curl-global-init(?flags);
         if (code ~= $curle-ok)
           error(make(<curl-error>, curle: code))
         end;
         block ()
           ?body
         cleanup
           curl-global-cleanup()
         end block }
end macro;
