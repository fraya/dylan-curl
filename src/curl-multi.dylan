Module:    curl-multi-impl
Synopsis:  Curl multi API
Author:    Fernando Raya
Copyright: Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:   See License.txt in this distribution for details.

///////////////////////////////////////////////////////////////////////////////
//
// Curl multi error codes
//
// See: https://curl.se/libcurl/c/libcurl-errors.html
//
///////////////////////////////////////////////////////////////////////////////

define constant $curlm-call-multi-perform    = -1;
define constant $curlm-ok                    = 0;
define constant $curlm-bad-handle            = 1;
define constant $curlm-bad-easy-handle       = 2;
define constant $curlm-out-of-memory         = 3;
define constant $curlm-internal-error        = 4;
define constant $curlm-bad-socket            = 5;
define constant $curlm-unknown-option        = 6;
define constant $curlm-added-already         = 7;
define constant $curlm-recursive-api-call    = 8;
define constant $curlm-wakeup-failure        = 9;
define constant $curlm-bad-function-argument = 10;
define constant $curlm-aborted-by-callback   = 11;
define constant $curlm-unrecoverable-poll    = 12;

///////////////////////////////////////////////////////////////////////////////
//
// Curl Message encapsulates information about individual transfers.
//
// See: https://curl.se/libcurl/c/curl_multi_info_read.html
//
///////////////////////////////////////////////////////////////////////////////

define constant <curlmsg-status> = <integer>;

define constant $curlmsg-none :: <curlmsg-status> = 0;
define constant $curlmsg-done :: <curlmsg-status> = 1;

define C-union <curlmsg-data>
  constant slot curlmsg-data-whatever :: <C-void*>;  // message-specific data
  constant slot curlmsg-data-result   :: <C-int>;    // return code for transfer
end;

define C-struct <curlmsg>
  constant slot curlmsg-msg         :: <C-int>;
  constant slot curlmsg-easy-handle :: <curl-easy-handle>;
  constant slot curlmsg-data        :: <curlmsg-data>;
  pointer-type-name: <curlmsg*>; 
end C-struct;

define function curlmsg-done?
    (message :: <curlmsg*>) => (done? :: <boolean>)
  message.curlmsg-msg = $curlmsg-done
end;

define function curlmsg-none?
    (message :: <curlmsg*>) => (none? :: <boolean>)
  message.curlmsg-msg = $curlmsg-none
end;

///////////////////////////////////////////////////////////////////////////////
//
// <curl-waitfd>
//
///////////////////////////////////////////////////////////////////////////////

// TODO: curl-waitfd-fd is 'curl_socket_t' type
// TODO: are slots contants?
define C-struct <curl-waitfd>
  constant slot curl-waitfd-fd      :: <C-void*>;
  constant slot curl-waitfd-events  :: <C-unsigned-short>;
  constant slot curl-waitfd-revents :: <C-unsigned-short>;
  pointer-type-name: <curl-waitfd*>;
end C-struct;

///////////////////////////////////////////////////////////////////////////////
//
// Curl multi subtypes
//
///////////////////////////////////////////////////////////////////////////////

define C-subtype <curl-multi-handle> (<C-void*>) end;

///////////////////////////////////////////////////////////////////////////////
//
// Curl multi error exceptions
//
///////////////////////////////////////////////////////////////////////////////

define class <curl-multi-error> (<curl-error>) end;

// Error produced setting a multi option

define class <curl-multi-option-error> (<curl-multi-error>) end;

// Error produced doing a multiple request

define class <curl-multi-perform-error> (<curl-multi-error>) end;

define method curl-error-message
    (err :: <curl-multi-error>) => (message :: <string>)
  c-curl-multi-strerror(err.curl-error-code)
end;

///////////////////////////////////////////////////////////////////////////////
//
// Curl multi C bindings
//
///////////////////////////////////////////////////////////////////////////////

// https://curl.se/libcurl/c/curl_multi_init.html

define C-function c-curl-multi-init
  result multi :: <curl-multi-handle>;
  c-name: "curl_multi_init";
end C-function;

// https://curl.se/libcurl/c/curl_multi_cleanup.html

define C-function c-curl-multi-cleanup
   input parameter multi :: <curl-multi-handle>;
   result code :: <C-int>;
   c-name: "curl_multi_cleanup";
end C-function;

// https://curl.se/libcurl/c/curl_multi_strerror.html

define C-function c-curl-multi-strerror
  input parameter code :: <C-int>;
  result message :: <C-string>;
  c-name: "curl_multi_strerror";
end C-function;

// https://curl.se/libcurl/c/curl_multi_add_handle.html

define C-function c-curl-multi-add-handle
  input parameter multi :: <curl-multi-handle>;
  input parameter easy  :: <curl-easy-handle>;
  result code :: <C-int>;
  c-name: "curl_multi_add_handle";
end C-function;

// https://curl.se/libcurl/c/curl_multi_remove_handle.html

define C-function c-curl-multi-remove-handle
  input parameter multi :: <curl-multi-handle>;
  input parameter easy  :: <curl-easy-handle>;
  result code :: <C-int>;
  c-name: "curl_multi_remove_handle";
end C-function;

// https://curl.se/libcurl/c/curl_multi_get_handles.html

define C-function c-curl-multi-get-handles
  input parameter multi :: <curl-multi-handle>;
  result handles :: <curl-easy-handle*>;
  c-name: "curl_multi_get_handles";
end C-function;

// https://curl.se/libcurl/c/curl_multi_info_read.html

define C-function c-curl-multi-info-read
  input  parameter multi-handle  :: <curl-multi-handle>;
  output parameter msgs-in-queue :: <C-int*>;
  result curl-msg :: <curlmsg*>;
  c-name: "curl_multi_info_read";
end C-function;

// https://curl.se/libcurl/c/curl_multi_perform.html

define C-function c-curl-multi-perform
  input  parameter multi-handle    :: <curl-multi-handle>;
  output parameter running-handles :: <C-int*>;
  result curlmcode :: <C-int>;
  c-name: "curl_multi_perform";
end C-function;

///////////////////////////////////////////////////////////////////////////////
//
// Curl multi handle
//
///////////////////////////////////////////////////////////////////////////////

define class <curl-multi> (<curl>)
  constant slot curl-multi-handle :: <curl-multi-handle>
    = c-curl-multi-init();
end;

///////////////////////////////////////////////////////////////////////////////
//
// Curl multi wrappers functions around c-bindings
//
///////////////////////////////////////////////////////////////////////////////

define function curl-multi-cleanup
    (handle :: <curl-multi>) => ()
  let code = c-curl-multi-cleanup(handle.curl-multi-handle);
  if (code ~= $curlm-ok)
    error(make(<curl-multi-error>, code: code))
  end
end;

define function curl-multi-do
    (f :: <function>, multi :: <curl-multi>, easy :: <curl-easy>)
 => (multi :: <curl-multi>)
  let code = f(multi.curl-multi-handle, easy.curl-easy-handle);
  if (code ~= $curlm-ok)
    error(make(<curl-multi-error>, code: code))
  end;
  multi
end;

define function curl-multi-add!
    (multi :: <curl-multi>, easy :: <curl-easy>)
 => (multi :: <curl-multi>)
  curl-multi-do(c-curl-multi-add-handle, multi, easy) 
end;

define function curl-multi-remove!
    (multi :: <curl-multi>, easy :: <curl-easy>)
 => (multi :: <curl-multi>)
  curl-multi-do(c-curl-multi-remove-handle, multi, easy)
end;

define function curl-multi-get-handles
    (multi :: <curl-multi>)
 => (handles :: <curl-easy-vector>)
  let c-handles = #f;
  block ()
    c-handles := c-curl-multi-get-handles(multi.curl-multi-handle);
    iterate loop (i = 0, handles = make(<curl-easy-vector>))
      if (null-pointer?(c-handles[i]))
        handles
      else
        let easy = make(<curl-easy>, handle: c-handles[i]);
        loop(i + 1, add(handles, easy))
      end if
    end iterate
  cleanup
    c-curl-free(c-handles);
  end block; 
end function;

define function curl-multi-info-read
    (multi :: <curl-multi>)
 => (message :: false-or(<curlmsg*>), messages-in-queue :: <integer>)

  let handle = multi.curl-multi-handle;
  let (message, messages-in-queue)
    = c-curl-multi-info-read(handle);

  values(if (null-pointer?(message)) #f else message end,
         messages-in-queue)
end function;

define function curl-multi-perform
    (multi :: <curl-multi>)
 => (running-handles :: <integer>)

  let (running-handles, code)
    = c-curl-multi-perform(multi.curl-multi-handle);

  if (code ~= $curlm-ok)
    error(make(<curl-multi-perform-error>), code: code)
  end;

  running-handles

end function;

define macro with-curl-multi
  { with-curl-multi (?multi:variable = ?handler:expression) ?body:body end }
    => { let _multi = #f; 
         block ()
           _multi := ?handler;
           let ?multi :: <curl-multi> = _multi;
           ?body
         cleanup
           if (_multi)
             let handles = curl-multi-get-handles(_multi);
             for (easy-handle in handles)
               curl-multi-remove!(_multi, easy-handle);
               curl-easy-cleanup(easy-handle);
             end;
             curl-multi-cleanup(_multi);
           end if;
         end block }
end macro with-curl-multi;

//////////////////////////////////////////////////////////////////////////////
//
// `curl-multi-setopt` shim functions.
//
// A "shim" function is created for each `$curlm-setopt-xxx` constant to
// streamline the process of working with the variadic function
// `curl_multi_setopt`.
//
//////////////////////////////////////////////////////////////////////////////

define C-function curlm-setopt-long
  input parameter handle :: <curl-multi-handle>;
  input parameter option :: <C-int>;
  input parameter value :: <C-long>;
  result curlm-code :: <C-int>;
  c-name: "curlm_setopt_long";
end C-function;

define C-function curlm-setopt-objectpoint
  input parameter handle :: <curl-multi-handle>;
  input parameter option :: <C-int>;
  input parameter value :: <C-void*>;
  result curlm-code :: <C-int>;
  c-name: "curlm_setopt_objectpoint";
end C-function;

define C-function curlm-setopt-functionpoint
  input parameter handle :: <curl-multi-handle>;
  input parameter option :: <C-int>;
  input parameter value :: <C-function-pointer>;
  result curlm-code :: <C-int>;
  c-name: "curlm_setopt_functionpoint";
end C-function;

define C-function curlm-setopt-off-t
  input parameter handle :: <curl-multi-handle>;
  input parameter option :: <C-int>;
  input parameter value :: <C-long>;
  result curlm-code :: <C-int>;
  c-name: "curlm_setopt_off_t";
end C-function;

///////////////////////////////////////////////////////////////////////////////
//
// Curl multiple options macro definer
//
///////////////////////////////////////////////////////////////////////////////

define macro curlmopt-definer
  { define curlmopt ?type:name ?id:name = ?number:expression }
    => { define constant "$curlmopt-" ## ?id
           = "$curlopttype-" ## ?type + ?number;            

         define method "curl-multi-" ## ?id ## "-setter"
             (option :: "<curlopt-" ## ?type ## ">", curlm :: <curl-multi>)
          => (option :: "<curlopt-" ## ?type ## ">")
           let handle = curlm.curl-multi-handle;
           let code = "curlm-setopt-" ## ?type (handle, "$curlmopt-" ## ?id, option);
           if (code ~= $curlm-ok)
             error(make(<curl-multi-option-error>, code: code))
           end;
           option;
         end }
end macro;

define curlmopt functionpoint socketfunction      = 1;
define curlmopt objectpoint socketdata            = 2;
define curlmopt long pipelining                   = 3;
define curlmopt functionpoint timerfunction       = 4;
define curlmopt objectpoint timerdata             = 5;
define curlmopt long maxconnects                  = 6;
define curlmopt long max-host-connections         = 7;
define curlmopt long max-pipeline-length          = 8;
define curlmopt off-t content-length-penalty-size = 9;
define curlmopt off-t chunk-length-penalty-size   = 10;
define curlmopt objectpoint pipelining-site-bl    = 11;
define curlmopt objectpoint pipelining-server-bl  = 12;
define curlmopt long max-total-connections        = 13;
define curlmopt functionpoint pushfunction        = 14;
define curlmopt objectpoint pushdata              = 15;
define curlmopt long max-concurrent-streams       = 16;
