Module:      %lib-curl-easy
Synopsis:    Libcurl "curl-easy" shim functions
Author:      Fernando Raya
Copyright:   Copyright (C) 2025, Dylan Hackers. All rights reserved.
License:     See License.txt in this distribution for details.
Reference:   See "lib-curl-easy-macros.dylan"

// setopt shim functions

define shim-curl-setopt long <C-long>;
define shim-curl-setopt objectpoint <C-void*>;
define shim-curl-setopt functionpoint <C-function-pointer>;
define shim-curl-setopt offt <C-long>;
define shim-curl-setopt blob <curlopt-blob>;
define shim-curl-setopt stringpoint <C-string>;
define shim-curl-setopt slistpoint <curlopt-slistpoint>;
define shim-curl-setopt cbpoint <C-void*>;
define shim-curl-setopt values <C-long>;
define shim-curl-setopt boolean <curl-boolean>;

// getinfo shim functions

define shim-curl-getinfo string <C-string>;
define shim-curl-getinfo long <C-long>;
define shim-curl-getinfo double <C-double>;
define shim-curl-getinfo offt <C-int>;
define shim-curl-getinfo slist <curl-slist*>;
define shim-curl-getinfo ptr <C-void*>;
