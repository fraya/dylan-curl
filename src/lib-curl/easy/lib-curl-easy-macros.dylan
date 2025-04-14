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

         define function "curl-setopt-" ## ?id
             (option :: "<curlopt-" ## ?type ## ">", handle :: <curl-easy-handle>)
          => ()
           let code = "curl-setopt-" ## ?type (handle, "$curlopt-" ## ?id, option);
           if (code ~= $curle-ok)
             error(make(<curl-option-set-error>, code: code))
           end;
           option
         end; }
end macro curlopt-definer;

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

         define function "curl-" ## ?id
              (handle :: <curl-easy-handle>)
           => (result :: "<curlinfo-" ## ?type ## ">")
            let (result, code)
              = "curl-easy-getinfo-" ## ?type (handle, "$curlinfo-" ## ?id);
            unless (code = $curle-ok)
              signal(make(<curl-info-error>, code: code))
            end;
            result
         end }
end macro;
