Module:      %dylan-curl-easy
Synopsis:    Dylan "curl-easy" macros
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.

//
// Associates option name (as symbol) with the setter method
//
// E.g.:
//
//   *curl-option-setters*[#"url"] -> curl-url-setter
//

define variable *curl-option-setters*
  = make(<table>);

//////////////////////////////////////////////////////////////////////////////
//
// The `curl-easy-option-definer` macro serves two purposes:
//
// 1. Creates a setter method to set the option.
//    This method calls the corresponding libcurl method.
//    The status code raise a condition.
//
// 2. Adds the setter method to a <table> to initialize the
//    <curl-easy> object with keywords. See "dylan-curl-easy-types.dylan"
//
//////////////////////////////////////////////////////////////////////////////

define macro curl-easy-option-definer
  { define curl-easy-option ?id:name :: ?type:name }
    => { define method "curl-easy-" ## ?id ## "-setter"
             (option :: ?type, curl :: <curl-easy>) => (option :: ?type)
             let code
               = "curl-easy-setopt-" ## ?id(curl.curl-easy-handle, option);
             if (code ~= $curle-ok)
               error(make(<curl-error>, curle: code))
             end;
             option
         end;

         *curl-option-setters*[?#"id"] := "curl-easy-" ## ?id ## "-setter" }
end macro;

define macro curl-easy-options-definer
    { define curl-easy-options end }
      => { }
    { define curl-easy-options ?id:name :: ?type:name ; ?more:* end }
      => { define curl-easy-option ?id :: ?type ;
           define curl-easy-options ?more end }
end macro;

//////////////////////////////////////////////////////////////////////////////
//
// The `curl-easy-info-definer` macro serves two purposes:
//
// 1. Creates a getter accersor to retrieve information about the identifier.
// 2. Check for errors and signal a condition.
//
//////////////////////////////////////////////////////////////////////////////

define macro curl-easy-info-definer
  { define curl-easy-info ?id:name :: ?type:name }
    => { define method "curl-easy-" ## ?id
             (curl :: <curl-easy>) => (result :: ?type)
           let (result, code)
             = "curl-easy-getinfo-" ## ?id (curl.curl-easy-handle);
           if (code ~= $curle-ok)
             error(make(<curl-error>, curle: code))
           end;
           result
         end }
end macro;

define macro curl-easy-getinfo-options-definer
    { define curl-easy-getinfo-options end }
      => { }
    { define curl-easy-getinfo-options ?id:name :: ?type:name ; ?more:* end }
      => { define curl-easy-info ?id :: ?type ;
           define curl-easy-getinfo-options ?more end }
end macro;

///////////////////////////////////////////////////////////////////////////////
//
// with-curl-easy:
//
// Macro to release a handle.
//
///////////////////////////////////////////////////////////////////////////////

define function %curl-easy
    (url :: <string>, #rest keywords, #key #all-keys)
 => (_ :: <curl-easy>)
  apply(make, <curl-easy>, url: url, keywords)
end;

define macro with-curl-easy
  { with-curl-easy (?curl:variable = ?url:expression,
                    #rest ?keys:expression)
      ?body:body
    end }
  => {  let _curl = #f;
        block ()
          _curl := %curl-easy(?url, ?keys);
          let ?curl :: <curl-easy> = _curl;
          ?body
        cleanup
          if (_curl)
            curl-easy-cleanup(_curl)
          end;
        end block;
  }
end macro;
