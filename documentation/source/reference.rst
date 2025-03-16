*********
Reference
*********

.. current-library:: dylan-curl
.. current-module:: curl-easy

Global initialization
=====================

.. global_constants

Initialization constants
------------------------

Bit flags used to configure the library's global initialization
options.

.. note::

   See `curl_global_init
   <https://curl.se/libcurl/c/curl_global_init.html>`_ in libcurl's
   documentation for a complete description of this flags.

- :const:`$curl-global-ssl`
- :const:`$curl-global-win32`
- :const:`$curl-global-all`
- :const:`$curl-global-nothing`
- :const:`$curl-global-default`
- :const:`$curl-global-ack-eintr`

Functions
---------

.. function:: curl-library-initialized?

   :signature:

      curl-library-initialized? => *initialized?*

   :value initialized?:

      An instance of :drm:`<boolean>`. Returns :drm:`#t` if the
      library has been globally initialized, :drm:`#f` otherwise.

   :seealso:

      - :func:`curl-library-setup`
      - :func:`curl-library-cleanup`

.. function:: curl-library-setup

   Initializes globally the library.

   This function ensures that the curl library is properly
   initialized, preventing problems when it has already been
   initialized elsewhere.

   It makes that :func:`curl-library-initialized?` returns :drm:`#t`.

   :signature:

      curl-library-setup *flags* => ()

   :param #key flags:

      A bit pattern that tells libcurl exactly what features to init.
      In normal operation, you must use :const:`$curl-global-all` or
      :const:`$curl-global-default` since right now are the same.
      An instance of :drm:`<integer>`. Default value is
      :const:`$curl-global-default`.

   :signals:

      A :class:`<curl-init-error>` if there was an error initializing
      the library. The rest of functions/methods cannot be used.

   :example:

      .. code-block:: dylan

         curl-library-setup();
	 curl-library-setup(#key flags: $curl-global-ssl);

   :discussion:

      This function avoids that repeated calls to `curl_global_init
      <https://curl.se/libcurl/c/curl_global_init.html>`_ cause
      problems.

      Use this in test suites to setup the library before using
      functions that depend on it being initialized.

      .. code-block:: dylan

	 define suite my-test-suite
	    (setup-function: curl-library-setup,
	     cleanup-function: curl-library-cleanup)
	    // test suite
	 end suite;

   :seealso:

      - `Initialization constants`_
      - :func:`curl-library-initialized?`
      - :func:`curl-library-cleanup`
      - :macro:`with-curl-global`

.. function:: curl-library-cleanup

   Release resources adquired by the library.

   :signature:

      curl-library-cleanup => ()

   :discussion:

      Calling this function actually makes that
      :func:`curl-library-initialized?` returns :drm:`#f`. These can
      change in the future to avoid problems with nested calls. See
      :macro:`with-curl-global`.

   :seealso:

      - :func:`curl-library-initialized?`
      - :func:`curl-library-setup`
      - :macro:`with-curl-global`

Functions
=========

General
-------

.. function:: curl-easy-perform

   :signature:

      curl-easy-perform (*curl-handler*) => ()

   :seealso:

     `curl_easy_perform
     <https://curl.se/libcurl/c/curl_easy_perform.html>`_ in `libcurl
     <https://curl.se/libcurl/>`_

Macros
======

.. dylan:macro:: with-curl-easy
   :statement:

   :macrocall:
     .. parsed-literal::
        with-curl-easy (*variable* = *expression*, *option* = *value*, ...) body end

   :example:

     .. code-block:: dylan
        :caption: Simple macro form

        with-curl-easy (curl = make(<curl-easy>))
          curl.curl-url := "http://example.com";
          curl-easy-perform(curl);
        end;

   :example:

     .. code-block:: dylan
        :caption: Passing options to macro

        with-curl-easy (curl = make(<curl-easy>),
                        url = "http://example.com",
                        verbose = #t)
          curl-easy-perform(curl);
        end;

   :signals:

      :class:`<curl-init-error>` if the curl handle could not be
      initialized.

      :class:`<curl-option-error>` if an option is incorrect.

   :discussion:

     This macro is more or less equivalent to:

     .. code-block:: dylan

        let curl = #f;
        block ()
          curl := make(<curl-easy>);
          body ...
        cleanup
          curl-easy-cleanup(curl)
        end block;

.. dylan:macro:: with-curl-global
   :statement:

   This macro simplifies the initialization and cleanup of the
   `libcurl` library in Open Dylan.  It ensures that `libcurl`'s
   global variables are initialized before the code is executed and
   properly cleaned up afterwards.

   :macrocall:
      .. parsed-literal::
         with-curl-global (*flags*) body end

   :discussion:

      This code is equivalent to:

      .. code-block:: dylan

         block()
           curl-library-setup(flags)
           body;
         rescue
           curl-library-cleanup()
         end;

   :example:

     .. code-block:: dylan

        with-curl-global ($curl-global-all)
          with-curl-easy (curl)
            curl.curl-url := "https://example.com";
            curl-easy-perform(curl);
            // retrieve information
          end;
        end with-curl-global;

   :seealso:

      * `Global preparation <https://curl.se/libcurl/c/libcurl-tutorial.html>`_.
      * `Global flags <#global-flags>`_
      * :func:`curl-library-setup`
      * :func:`curl-library-cleanup`

Headers
=======

.. function:: add-header!

   :signature:

      add-header! (*curl* #rest *headers*) => (*curl*)

   :parameter curl:
      An instance of :class:`<curl-easy>`
   :parameter #rest headers:
      0 or more :drm:`<string>` headers
   :value curl:
      An instance of :class:`<curl-easy>`

   :example:

      .. code-block:: dylan

         add-header!("Content-type: application/json",
                     "Authorization: Bearer you_token_here");

.. method:: curl-header-setter
   :specializer: <string>

   :signature:

      curl-header-setter (header curl) => (header)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter header: An instance of :drm:`<string>`
   :value header: An instance of :drm:`<string>`

   :description:

      Sets a HTTP header. Each use adds a header to the headers
      list.

      If the key is repeated the values are appended, not replaced.

      .. code-block:: dylan

         curl.curl-header := "X-friend: you";
         curl.curl-header := "X-friend: her";
         // "X-friend: you, her"

Options
=======

.. method:: curl-writedata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-writedata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_WRITEDATA.html

.. method:: curl-url-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-url-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_URL.html

.. method:: curl-port-setter
   :specializer: <curl-long>

   :signature:

     curl-port-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PORT.html

.. method:: curl-proxy-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY.html

.. method:: curl-userpwd-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-userpwd-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_USERPWD.html

.. method:: curl-proxyuserpwd-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxyuserpwd-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXYUSERPWD.html

.. method:: curl-range-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-range-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_RANGE.html

.. method:: curl-readdata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-readdata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_READDATA.html

.. method:: curl-errorbuffer-setter
   :specializer: <curl-objectpoint>

   :signature:

     curl-errorbuffer-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-objectpoint>`
   :value option: An instance of :class:`<curl-objectpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_ERRORBUFFER.html

.. method:: curl-writefunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-writefunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_WRITEFUNCTION.html

.. method:: curl-readfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-readfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_READFUNCTION.html

.. method:: curl-timeout-setter
   :specializer: <curl-long>

   :signature:

     curl-timeout-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TIMEOUT.html

.. method:: curl-infilesize-setter
   :specializer: <curl-long>

   :signature:

     curl-infilesize-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_INFILESIZE.html

.. method:: curl-postfields-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-postfields-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_POSTFIELDS.html

.. method:: curl-referer-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-referer-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_REFERER.html

.. method:: curl-ftpport-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-ftpport-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FTPPORT.html

.. method:: curl-useragent-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-useragent-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_USERAGENT.html

.. method:: curl-low-speed-limit-setter
   :specializer: <curl-long>

   :signature:

     curl-low-speed-limit-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_LOW_SPEED_LIMIT.html

.. method:: curl-low-speed-time-setter
   :specializer: <curl-long>

   :signature:

     curl-low-speed-time-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_LOW_SPEED_TIME.html

.. method:: curl-resume-from-setter
   :specializer: <curl-long>

   :signature:

     curl-resume-from-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_RESUME_FROM.html

.. method:: curl-cookie-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-cookie-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_COOKIE.html

.. method:: curl-httpheader-setter
   :specializer: <curl-slistpoint>

   :signature:

     curl-httpheader-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-slistpoint>`
   :value option: An instance of :class:`<curl-slistpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HTTPHEADER.html

.. method:: curl-httppost-setter
   :specializer: <curl-objectpoint>

   :signature:

     curl-httppost-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-objectpoint>`
   :value option: An instance of :class:`<curl-objectpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HTTPPOST.html

.. method:: curl-sslcert-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-sslcert-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSLCERT.html

.. method:: curl-keypasswd-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-keypasswd-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_KEYPASSWD.html

.. method:: curl-crlf-setter
   :specializer: <curl-boolean>

   :signature:

     curl-crlf-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CRLF.html

.. method:: curl-quote-setter
   :specializer: <curl-slistpoint>

   :signature:

     curl-quote-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-slistpoint>`
   :value option: An instance of :class:`<curl-slistpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_QUOTE.html

.. method:: curl-headerdata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-headerdata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HEADERDATA.html

.. method:: curl-cookiefile-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-cookiefile-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_COOKIEFILE.html

.. method:: curl-sslversion-setter
   :specializer: <curl-values>

   :signature:

     curl-sslversion-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSLVERSION.html

.. method:: curl-timecondition-setter
   :specializer: <curl-values>

   :signature:

     curl-timecondition-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TIMECONDITION.html

.. method:: curl-timevalue-setter
   :specializer: <curl-long>

   :signature:

     curl-timevalue-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TIMEVALUE.html

.. method:: curl-customrequest-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-customrequest-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CUSTOMREQUEST.html

.. method:: curl-stderr-setter
   :specializer: <curl-objectpoint>

   :signature:

     curl-stderr-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-objectpoint>`
   :value option: An instance of :class:`<curl-objectpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_STDERR.html

.. method:: curl-postquote-setter
   :specializer: <curl-slistpoint>

   :signature:

     curl-postquote-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-slistpoint>`
   :value option: An instance of :class:`<curl-slistpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_POSTQUOTE.html

.. method:: curl-verbose-setter
   :specializer: <curl-boolean>

   :signature:

     curl-verbose-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_VERBOSE.html

.. method:: curl-header-setter
   :specializer: <curl-boolean>

   :signature:

     curl-header-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HEADER.html

.. method:: curl-noprogress-setter
   :specializer: <curl-boolean>

   :signature:

     curl-noprogress-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_NOPROGRESS.html

.. method:: curl-nobody-setter
   :specializer: <curl-boolean>

   :signature:

     curl-nobody-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_NOBODY.html

.. method:: curl-failonerror-setter
   :specializer: <curl-boolean>

   :signature:

     curl-failonerror-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FAILONERROR.html

.. method:: curl-upload-setter
   :specializer: <curl-boolean>

   :signature:

     curl-upload-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_UPLOAD.html

.. method:: curl-post-setter
   :specializer: <curl-boolean>

   :signature:

     curl-post-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_POST.html

.. method:: curl-dirlistonly-setter
   :specializer: <curl-boolean>

   :signature:

     curl-dirlistonly-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DIRLISTONLY.html

.. method:: curl-append-setter
   :specializer: <curl-long>

   :signature:

     curl-append-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_APPEND.html

.. method:: curl-netrc-setter
   :specializer: <curl-values>

   :signature:

     curl-netrc-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_NETRC.html

.. method:: curl-followlocation-setter
   :specializer: <curl-long>

   :signature:

     curl-followlocation-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FOLLOWLOCATION.html

.. method:: curl-transfertext-setter
   :specializer: <curl-boolean>

   :signature:

     curl-transfertext-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TRANSFERTEXT.html

.. method:: curl-put-setter
   :specializer: <curl-boolean>

   :signature:

     curl-put-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PUT.html

.. method:: curl-progressfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-progressfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROGRESSFUNCTION.html

.. method:: curl-xferinfodata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-xferinfodata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_XFERINFODATA.html

.. method:: curl-autoreferer-setter
   :specializer: <curl-boolean>

   :signature:

     curl-autoreferer-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_AUTOREFERER.html

.. method:: curl-proxyport-setter
   :specializer: <curl-long>

   :signature:

     curl-proxyport-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXYPORT.html

.. method:: curl-postfieldsize-setter
   :specializer: <curl-long>

   :signature:

     curl-postfieldsize-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_POSTFIELDSIZE.html

.. method:: curl-httpproxytunnel-setter
   :specializer: <curl-boolean>

   :signature:

     curl-httpproxytunnel-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HTTPPROXYTUNNEL.html

.. method:: curl-interface-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-interface-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_INTERFACE.html

.. method:: curl-krblevel-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-krblevel-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_KRBLEVEL.html

.. method:: curl-ssl-verifypeer-setter
   :specializer: <curl-boolean>

   :signature:

     curl-ssl-verifypeer-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSL_VERIFYPEER.html

.. method:: curl-cainfo-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-cainfo-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CAINFO.html

.. method:: curl-maxredirs-setter
   :specializer: <curl-long>

   :signature:

     curl-maxredirs-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAXREDIRS.html

.. method:: curl-filetime-setter
   :specializer: <curl-boolean>

   :signature:

     curl-filetime-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FILETIME.html

.. method:: curl-telnetoptions-setter
   :specializer: <curl-slistpoint>

   :signature:

     curl-telnetoptions-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-slistpoint>`
   :value option: An instance of :class:`<curl-slistpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TELNETOPTIONS.html

.. method:: curl-maxconnects-setter
   :specializer: <curl-long>

   :signature:

     curl-maxconnects-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAXCONNECTS.html

.. method:: curl-fresh-connect-setter
   :specializer: <curl-boolean>

   :signature:

     curl-fresh-connect-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FRESH_CONNECT.html

.. method:: curl-forbid-reuse-setter
   :specializer: <curl-boolean>

   :signature:

     curl-forbid-reuse-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FORBID_REUSE.html

.. method:: curl-random-file-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-random-file-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_RANDOM_FILE.html

.. method:: curl-egdsocket-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-egdsocket-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_EGDSOCKET.html

.. method:: curl-connecttimeout-setter
   :specializer: <curl-long>

   :signature:

     curl-connecttimeout-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CONNECTTIMEOUT.html

.. method:: curl-headerfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-headerfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HEADERFUNCTION.html

.. method:: curl-httpget-setter
   :specializer: <curl-boolean>

   :signature:

     curl-httpget-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HTTPGET.html

.. method:: curl-ssl-verifyhost-setter
   :specializer: <curl-long>

   :signature:

     curl-ssl-verifyhost-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSL_VERIFYHOST.html

.. method:: curl-cookiejar-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-cookiejar-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_COOKIEJAR.html

.. method:: curl-ssl-cipher-list-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-ssl-cipher-list-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSL_CIPHER_LIST.html

.. method:: curl-http-version-setter
   :specializer: <curl-values>

   :signature:

     curl-http-version-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HTTP_VERSION.html

.. method:: curl-ftp-use-epsv-setter
   :specializer: <curl-boolean>

   :signature:

     curl-ftp-use-epsv-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FTP_USE_EPSV.html

.. method:: curl-sslcerttype-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-sslcerttype-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSLCERTTYPE.html

.. method:: curl-sslkeytype-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-sslkeytype-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSLKEYTYPE.html

.. method:: curl-sslengine-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-sslengine-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSLENGINE.html

.. method:: curl-sslengine-default-setter
   :specializer: <curl-long>

   :signature:

     curl-sslengine-default-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSLENGINE_DEFAULT.html

.. method:: curl-dns-use-global-cache-setter
   :specializer: <curl-boolean>

   :signature:

     curl-dns-use-global-cache-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DNS_USE_GLOBAL_CACHE.html

.. method:: curl-dns-cache-timeout-setter
   :specializer: <curl-long>

   :signature:

     curl-dns-cache-timeout-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DNS_CACHE_TIMEOUT.html

.. method:: curl-prequote-setter
   :specializer: <curl-slistpoint>

   :signature:

     curl-prequote-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-slistpoint>`
   :value option: An instance of :class:`<curl-slistpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PREQUOTE.html

.. method:: curl-debugfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-debugfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DEBUGFUNCTION.html

.. method:: curl-debugdata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-debugdata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DEBUGDATA.html

.. method:: curl-cookiesession-setter
   :specializer: <curl-boolean>

   :signature:

     curl-cookiesession-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_COOKIESESSION.html

.. method:: curl-capath-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-capath-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CAPATH.html

.. method:: curl-buffersize-setter
   :specializer: <curl-long>

   :signature:

     curl-buffersize-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_BUFFERSIZE.html

.. method:: curl-nosignal-setter
   :specializer: <curl-boolean>

   :signature:

     curl-nosignal-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_NOSIGNAL.html

.. method:: curl-share-setter
   :specializer: <curl-objectpoint>

   :signature:

     curl-share-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-objectpoint>`
   :value option: An instance of :class:`<curl-objectpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SHARE.html

.. method:: curl-proxytype-setter
   :specializer: <curl-values>

   :signature:

     curl-proxytype-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXYTYPE.html

.. method:: curl-accept-encoding-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-accept-encoding-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_ACCEPT_ENCODING.html

.. method:: curl-private-setter
   :specializer: <curl-objectpoint>

   :signature:

     curl-private-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-objectpoint>`
   :value option: An instance of :class:`<curl-objectpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PRIVATE.html

.. method:: curl-http200aliases-setter
   :specializer: <curl-slistpoint>

   :signature:

     curl-http200aliases-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-slistpoint>`
   :value option: An instance of :class:`<curl-slistpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HTTP200ALIASES.html

.. method:: curl-unrestricted-auth-setter
   :specializer: <curl-boolean>

   :signature:

     curl-unrestricted-auth-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_UNRESTRICTED_AUTH.html

.. method:: curl-ftp-use-eprt-setter
   :specializer: <curl-boolean>

   :signature:

     curl-ftp-use-eprt-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FTP_USE_EPRT.html

.. method:: curl-httpauth-setter
   :specializer: <curl-values>

   :signature:

     curl-httpauth-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HTTPAUTH.html

.. method:: curl-ssl-ctx-function-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-ssl-ctx-function-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSL_CTX_FUNCTION.html

.. method:: curl-ssl-ctx-data-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-ssl-ctx-data-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSL_CTX_DATA.html

.. method:: curl-ftp-create-missing-dirs-setter
   :specializer: <curl-long>

   :signature:

     curl-ftp-create-missing-dirs-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FTP_CREATE_MISSING_DIRS.html

.. method:: curl-proxyauth-setter
   :specializer: <curl-values>

   :signature:

     curl-proxyauth-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXYAUTH.html

.. method:: curl-server-response-timeout-setter
   :specializer: <curl-long>

   :signature:

     curl-server-response-timeout-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SERVER_RESPONSE_TIMEOUT.html

.. method:: curl-ipresolve-setter
   :specializer: <curl-values>

   :signature:

     curl-ipresolve-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_IPRESOLVE.html

.. method:: curl-maxfilesize-setter
   :specializer: <curl-long>

   :signature:

     curl-maxfilesize-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAXFILESIZE.html

.. method:: curl-infilesize-large-setter
   :specializer: <curl-off-t>

   :signature:

     curl-infilesize-large-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-off-t>`
   :value option: An instance of :class:`<curl-off-t>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_INFILESIZE_LARGE.html

.. method:: curl-resume-from-large-setter
   :specializer: <curl-off-t>

   :signature:

     curl-resume-from-large-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-off-t>`
   :value option: An instance of :class:`<curl-off-t>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_RESUME_FROM_LARGE.html

.. method:: curl-maxfilesize-large-setter
   :specializer: <curl-off-t>

   :signature:

     curl-maxfilesize-large-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-off-t>`
   :value option: An instance of :class:`<curl-off-t>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAXFILESIZE_LARGE.html

.. method:: curl-netrc-file-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-netrc-file-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_NETRC_FILE.html

.. method:: curl-use-ssl-setter
   :specializer: <curl-values>

   :signature:

     curl-use-ssl-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_USE_SSL.html

.. method:: curl-postfieldsize-large-setter
   :specializer: <curl-off-t>

   :signature:

     curl-postfieldsize-large-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-off-t>`
   :value option: An instance of :class:`<curl-off-t>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_POSTFIELDSIZE_LARGE.html

.. method:: curl-tcp-nodelay-setter
   :specializer: <curl-boolean>

   :signature:

     curl-tcp-nodelay-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TCP_NODELAY.html

.. method:: curl-ftpsslauth-setter
   :specializer: <curl-values>

   :signature:

     curl-ftpsslauth-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FTPSSLAUTH.html

.. method:: curl-ioctlfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-ioctlfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_IOCTLFUNCTION.html

.. method:: curl-ioctldata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-ioctldata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_IOCTLDATA.html

.. method:: curl-ftp-account-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-ftp-account-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FTP_ACCOUNT.html

.. method:: curl-cookielist-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-cookielist-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_COOKIELIST.html

.. method:: curl-ignore-content-length-setter
   :specializer: <curl-long>

   :signature:

     curl-ignore-content-length-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_IGNORE_CONTENT_LENGTH.html

.. method:: curl-ftp-skip-pasv-ip-setter
   :specializer: <curl-long>

   :signature:

     curl-ftp-skip-pasv-ip-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FTP_SKIP_PASV_IP.html

.. method:: curl-ftp-filemethod-setter
   :specializer: <curl-values>

   :signature:

     curl-ftp-filemethod-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FTP_FILEMETHOD.html

.. method:: curl-localport-setter
   :specializer: <curl-long>

   :signature:

     curl-localport-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_LOCALPORT.html

.. method:: curl-localportrange-setter
   :specializer: <curl-long>

   :signature:

     curl-localportrange-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_LOCALPORTRANGE.html

.. method:: curl-connect-only-setter
   :specializer: <curl-long>

   :signature:

     curl-connect-only-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CONNECT_ONLY.html

.. method:: curl-max-send-speed-large-setter
   :specializer: <curl-off-t>

   :signature:

     curl-max-send-speed-large-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-off-t>`
   :value option: An instance of :class:`<curl-off-t>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAX_SEND_SPEED_LARGE.html

.. method:: curl-max-recv-speed-large-setter
   :specializer: <curl-off-t>

   :signature:

     curl-max-recv-speed-large-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-off-t>`
   :value option: An instance of :class:`<curl-off-t>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAX_RECV_SPEED_LARGE.html

.. method:: curl-ftp-alternative-to-user-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-ftp-alternative-to-user-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FTP_ALTERNATIVE_TO_USER.html

.. method:: curl-sockoptfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-sockoptfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SOCKOPTFUNCTION.html

.. method:: curl-sockoptdata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-sockoptdata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SOCKOPTDATA.html

.. method:: curl-ssl-sessionid-cache-setter
   :specializer: <curl-long>

   :signature:

     curl-ssl-sessionid-cache-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSL_SESSIONID_CACHE.html

.. method:: curl-ssh-auth-types-setter
   :specializer: <curl-values>

   :signature:

     curl-ssh-auth-types-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSH_AUTH_TYPES.html

.. method:: curl-ssh-public-keyfile-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-ssh-public-keyfile-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSH_PUBLIC_KEYFILE.html

.. method:: curl-ssh-private-keyfile-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-ssh-private-keyfile-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSH_PRIVATE_KEYFILE.html

.. method:: curl-ftp-ssl-ccc-setter
   :specializer: <curl-long>

   :signature:

     curl-ftp-ssl-ccc-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FTP_SSL_CCC.html

.. method:: curl-timeout-ms-setter
   :specializer: <curl-long>

   :signature:

     curl-timeout-ms-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TIMEOUT_MS.html

.. method:: curl-connecttimeout-ms-setter
   :specializer: <curl-long>

   :signature:

     curl-connecttimeout-ms-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CONNECTTIMEOUT_MS.html

.. method:: curl-http-transfer-decoding-setter
   :specializer: <curl-long>

   :signature:

     curl-http-transfer-decoding-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HTTP_TRANSFER_DECODING.html

.. method:: curl-http-content-decoding-setter
   :specializer: <curl-long>

   :signature:

     curl-http-content-decoding-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HTTP_CONTENT_DECODING.html

.. method:: curl-new-file-perms-setter
   :specializer: <curl-long>

   :signature:

     curl-new-file-perms-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_NEW_FILE_PERMS.html

.. method:: curl-new-directory-perms-setter
   :specializer: <curl-long>

   :signature:

     curl-new-directory-perms-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_NEW_DIRECTORY_PERMS.html

.. method:: curl-postredir-setter
   :specializer: <curl-values>

   :signature:

     curl-postredir-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_POSTREDIR.html

.. method:: curl-ssh-host-public-key-md5-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-ssh-host-public-key-md5-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSH_HOST_PUBLIC_KEY_MD5.html

.. method:: curl-opensocketfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-opensocketfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_OPENSOCKETFUNCTION.html

.. method:: curl-opensocketdata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-opensocketdata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_OPENSOCKETDATA.html

.. method:: curl-copypostfields-setter
   :specializer: <curl-objectpoint>

   :signature:

     curl-copypostfields-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-objectpoint>`
   :value option: An instance of :class:`<curl-objectpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_COPYPOSTFIELDS.html

.. method:: curl-proxy-transfer-mode-setter
   :specializer: <curl-long>

   :signature:

     curl-proxy-transfer-mode-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_TRANSFER_MODE.html

.. method:: curl-seekfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-seekfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SEEKFUNCTION.html

.. method:: curl-seekdata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-seekdata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SEEKDATA.html

.. method:: curl-crlfile-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-crlfile-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CRLFILE.html

.. method:: curl-issuercert-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-issuercert-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_ISSUERCERT.html

.. method:: curl-address-scope-setter
   :specializer: <curl-long>

   :signature:

     curl-address-scope-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_ADDRESS_SCOPE.html

.. method:: curl-certinfo-setter
   :specializer: <curl-boolean>

   :signature:

     curl-certinfo-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CERTINFO.html

.. method:: curl-username-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-username-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_USERNAME.html

.. method:: curl-password-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-password-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PASSWORD.html

.. method:: curl-proxyusername-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxyusername-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXYUSERNAME.html

.. method:: curl-proxypassword-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxypassword-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXYPASSWORD.html

.. method:: curl-noproxy-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-noproxy-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_NOPROXY.html

.. method:: curl-tftp-blksize-setter
   :specializer: <curl-long>

   :signature:

     curl-tftp-blksize-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TFTP_BLKSIZE.html

.. method:: curl-socks5-gssapi-service-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-socks5-gssapi-service-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SOCKS5_GSSAPI_SERVICE.html

.. method:: curl-socks5-gssapi-nec-setter
   :specializer: <curl-long>

   :signature:

     curl-socks5-gssapi-nec-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SOCKS5_GSSAPI_NEC.html

.. method:: curl-protocols-setter
   :specializer: <curl-long>

   :signature:

     curl-protocols-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROTOCOLS.html

.. method:: curl-redir-protocols-setter
   :specializer: <curl-long>

   :signature:

     curl-redir-protocols-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_REDIR_PROTOCOLS.html

.. method:: curl-ssh-knownhosts-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-ssh-knownhosts-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSH_KNOWNHOSTS.html

.. method:: curl-ssh-keyfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-ssh-keyfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSH_KEYFUNCTION.html

.. method:: curl-ssh-keydata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-ssh-keydata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSH_KEYDATA.html

.. method:: curl-mail-from-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-mail-from-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAIL_FROM.html

.. method:: curl-mail-rcpt-setter
   :specializer: <curl-slistpoint>

   :signature:

     curl-mail-rcpt-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-slistpoint>`
   :value option: An instance of :class:`<curl-slistpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAIL_RCPT.html

.. method:: curl-ftp-use-pret-setter
   :specializer: <curl-long>

   :signature:

     curl-ftp-use-pret-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FTP_USE_PRET.html

.. method:: curl-rtsp-request-setter
   :specializer: <curl-values>

   :signature:

     curl-rtsp-request-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_RTSP_REQUEST.html

.. method:: curl-rtsp-session-id-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-rtsp-session-id-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_RTSP_SESSION_ID.html

.. method:: curl-chunk-data-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-chunk-data-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CHUNK_DATA.html

.. method:: curl-fnmatch-data-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-fnmatch-data-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_FNMATCH_DATA.html

.. method:: curl-resolve-setter
   :specializer: <curl-slistpoint>

   :signature:

     curl-resolve-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-slistpoint>`
   :value option: An instance of :class:`<curl-slistpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_RESOLVE.html

.. method:: curl-tlsauth-username-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-tlsauth-username-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TLSAUTH_USERNAME.html

.. method:: curl-tlsauth-password-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-tlsauth-password-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TLSAUTH_PASSWORD.html

.. method:: curl-tlsauth-type-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-tlsauth-type-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TLSAUTH_TYPE.html

.. method:: curl-transfer-encoding-setter
   :specializer: <curl-long>

   :signature:

     curl-transfer-encoding-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TRANSFER_ENCODING.html

.. method:: curl-closesocketfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-closesocketfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CLOSESOCKETFUNCTION.html

.. method:: curl-closesocketdata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-closesocketdata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CLOSESOCKETDATA.html

.. method:: curl-gssapi-delegation-setter
   :specializer: <curl-values>

   :signature:

     curl-gssapi-delegation-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_GSSAPI_DELEGATION.html

.. method:: curl-dns-servers-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-dns-servers-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DNS_SERVERS.html

.. method:: curl-accepttimeout-ms-setter
   :specializer: <curl-long>

   :signature:

     curl-accepttimeout-ms-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_ACCEPTTIMEOUT_MS.html

.. method:: curl-tcp-keepalive-setter
   :specializer: <curl-long>

   :signature:

     curl-tcp-keepalive-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TCP_KEEPALIVE.html

.. method:: curl-tcp-keepidle-setter
   :specializer: <curl-long>

   :signature:

     curl-tcp-keepidle-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TCP_KEEPIDLE.html

.. method:: curl-tcp-keepintvl-setter
   :specializer: <curl-long>

   :signature:

     curl-tcp-keepintvl-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TCP_KEEPINTVL.html

.. method:: curl-ssl-options-setter
   :specializer: <curl-values>

   :signature:

     curl-ssl-options-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSL_OPTIONS.html

.. method:: curl-mail-auth-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-mail-auth-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAIL_AUTH.html

.. method:: curl-sasl-ir-setter
   :specializer: <curl-boolean>

   :signature:

     curl-sasl-ir-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SASL_IR.html

.. method:: curl-xferinfofunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-xferinfofunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_XFERINFOFUNCTION.html

.. method:: curl-xoauth2-bearer-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-xoauth2-bearer-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_XOAUTH2_BEARER.html

.. method:: curl-dns-interface-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-dns-interface-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DNS_INTERFACE.html

.. method:: curl-dns-local-ip4-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-dns-local-ip4-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DNS_LOCAL_IP4.html

.. method:: curl-dns-local-ip6-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-dns-local-ip6-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DNS_LOCAL_IP6.html

.. method:: curl-login-options-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-login-options-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_LOGIN_OPTIONS.html

.. method:: curl-ssl-enable-alpn-setter
   :specializer: <curl-boolean>

   :signature:

     curl-ssl-enable-alpn-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSL_ENABLE_ALPN.html

.. method:: curl-expect-100-timeout-ms-setter
   :specializer: <curl-long>

   :signature:

     curl-expect-100-timeout-ms-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_EXPECT_100_TIMEOUT_MS.html

.. method:: curl-proxyheader-setter
   :specializer: <curl-slistpoint>

   :signature:

     curl-proxyheader-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-slistpoint>`
   :value option: An instance of :class:`<curl-slistpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXYHEADER.html

.. method:: curl-headeropt-setter
   :specializer: <curl-values>

   :signature:

     curl-headeropt-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HEADEROPT.html

.. method:: curl-pinnedpublickey-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-pinnedpublickey-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PINNEDPUBLICKEY.html

.. method:: curl-unix-socket-path-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-unix-socket-path-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_UNIX_SOCKET_PATH.html

.. method:: curl-ssl-verifystatus-setter
   :specializer: <curl-boolean>

   :signature:

     curl-ssl-verifystatus-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSL_VERIFYSTATUS.html

.. method:: curl-ssl-falsestart-setter
   :specializer: <curl-boolean>

   :signature:

     curl-ssl-falsestart-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSL_FALSESTART.html

.. method:: curl-path-as-is-setter
   :specializer: <curl-boolean>

   :signature:

     curl-path-as-is-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PATH_AS_IS.html

.. method:: curl-proxy-service-name-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-service-name-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SERVICE_NAME.html

.. method:: curl-service-name-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-service-name-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SERVICE_NAME.html

.. method:: curl-pipewait-setter
   :specializer: <curl-boolean>

   :signature:

     curl-pipewait-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PIPEWAIT.html

.. method:: curl-default-protocol-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-default-protocol-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DEFAULT_PROTOCOL.html

.. method:: curl-stream-weight-setter
   :specializer: <curl-long>

   :signature:

     curl-stream-weight-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_STREAM_WEIGHT.html

.. method:: curl-stream-depends-setter
   :specializer: <curl-objectpoint>

   :signature:

     curl-stream-depends-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-objectpoint>`
   :value option: An instance of :class:`<curl-objectpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_STREAM_DEPENDS.html

.. method:: curl-stream-depends-e-setter
   :specializer: <curl-objectpoint>

   :signature:

     curl-stream-depends-e-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-objectpoint>`
   :value option: An instance of :class:`<curl-objectpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_STREAM_DEPENDS_E.html

.. method:: curl-tftp-no-options-setter
   :specializer: <curl-boolean>

   :signature:

     curl-tftp-no-options-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TFTP_NO_OPTIONS.html

.. method:: curl-connect-to-setter
   :specializer: <curl-slistpoint>

   :signature:

     curl-connect-to-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-slistpoint>`
   :value option: An instance of :class:`<curl-slistpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CONNECT_TO.html

.. method:: curl-tcp-fastopen-setter
   :specializer: <curl-boolean>

   :signature:

     curl-tcp-fastopen-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TCP_FASTOPEN.html

.. method:: curl-keep-sending-on-error-setter
   :specializer: <curl-long>

   :signature:

     curl-keep-sending-on-error-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_KEEP_SENDING_ON_ERROR.html

.. method:: curl-proxy-cainfo-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-cainfo-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_CAINFO.html

.. method:: curl-proxy-capath-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-capath-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_CAPATH.html

.. method:: curl-proxy-ssl-verifypeer-setter
   :specializer: <curl-boolean>

   :signature:

     curl-proxy-ssl-verifypeer-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SSL_VERIFYPEER.html

.. method:: curl-proxy-ssl-verifyhost-setter
   :specializer: <curl-long>

   :signature:

     curl-proxy-ssl-verifyhost-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SSL_VERIFYHOST.html

.. method:: curl-proxy-sslversion-setter
   :specializer: <curl-values>

   :signature:

     curl-proxy-sslversion-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-values>`
   :value option: An instance of :class:`<curl-values>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SSLVERSION.html

.. method:: curl-proxy-tlsauth-username-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-tlsauth-username-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_TLSAUTH_USERNAME.html

.. method:: curl-proxy-tlsauth-password-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-tlsauth-password-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_TLSAUTH_PASSWORD.html

.. method:: curl-proxy-tlsauth-type-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-tlsauth-type-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_TLSAUTH_TYPE.html

.. method:: curl-proxy-sslcert-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-sslcert-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SSLCERT.html

.. method:: curl-proxy-sslcerttype-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-sslcerttype-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SSLCERTTYPE.html

.. method:: curl-proxy-sslkey-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-sslkey-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SSLKEY.html

.. method:: curl-proxy-sslkeytype-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-sslkeytype-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SSLKEYTYPE.html

.. method:: curl-proxy-keypasswd-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-keypasswd-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_KEYPASSWD.html

.. method:: curl-proxy-ssl-cipher-list-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-ssl-cipher-list-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SSL_CIPHER_LIST.html

.. method:: curl-proxy-crlfile-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-crlfile-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_CRLFILE.html

.. method:: curl-proxy-ssl-options-setter
   :specializer: <curl-long>

   :signature:

     curl-proxy-ssl-options-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SSL_OPTIONS.html

.. method:: curl-pre-proxy-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-pre-proxy-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PRE_PROXY.html

.. method:: curl-proxy-pinnedpublickey-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-pinnedpublickey-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_PINNEDPUBLICKEY.html

.. method:: curl-abstract-unix-socket-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-abstract-unix-socket-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_ABSTRACT_UNIX_SOCKET.html

.. method:: curl-suppress-connect-headers-setter
   :specializer: <curl-long>

   :signature:

     curl-suppress-connect-headers-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SUPPRESS_CONNECT_HEADERS.html

.. method:: curl-request-target-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-request-target-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_REQUEST_TARGET.html

.. method:: curl-socks5-auth-setter
   :specializer: <curl-long>

   :signature:

     curl-socks5-auth-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SOCKS5_AUTH.html

.. method:: curl-ssh-compression-setter
   :specializer: <curl-long>

   :signature:

     curl-ssh-compression-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSH_COMPRESSION.html

.. method:: curl-mimepost-setter
   :specializer: <curl-objectpoint>

   :signature:

     curl-mimepost-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-objectpoint>`
   :value option: An instance of :class:`<curl-objectpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MIMEPOST.html

.. method:: curl-timevalue-large-setter
   :specializer: <curl-off-t>

   :signature:

     curl-timevalue-large-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-off-t>`
   :value option: An instance of :class:`<curl-off-t>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TIMEVALUE_LARGE.html

.. method:: curl-happy-eyeballs-timeout-ms-setter
   :specializer: <curl-long>

   :signature:

     curl-happy-eyeballs-timeout-ms-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HAPPY_EYEBALLS_TIMEOUT_MS.html

.. method:: curl-resolver-start-function-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-resolver-start-function-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_RESOLVER_START_FUNCTION.html

.. method:: curl-resolver-start-data-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-resolver-start-data-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_RESOLVER_START_DATA.html

.. method:: curl-haproxyprotocol-setter
   :specializer: <curl-long>

   :signature:

     curl-haproxyprotocol-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HAPROXYPROTOCOL.html

.. method:: curl-dns-shuffle-addresses-setter
   :specializer: <curl-long>

   :signature:

     curl-dns-shuffle-addresses-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DNS_SHUFFLE_ADDRESSES.html

.. method:: curl-tls13-ciphers-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-tls13-ciphers-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TLS13_CIPHERS.html

.. method:: curl-proxy-tls13-ciphers-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-tls13-ciphers-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_TLS13_CIPHERS.html

.. method:: curl-disallow-username-in-url-setter
   :specializer: <curl-long>

   :signature:

     curl-disallow-username-in-url-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DISALLOW_USERNAME_IN_URL.html

.. method:: curl-doh-url-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-doh-url-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DOH_URL.html

.. method:: curl-upload-buffersize-setter
   :specializer: <curl-long>

   :signature:

     curl-upload-buffersize-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_UPLOAD_BUFFERSIZE.html

.. method:: curl-upkeep-interval-ms-setter
   :specializer: <curl-long>

   :signature:

     curl-upkeep-interval-ms-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_UPKEEP_INTERVAL_MS.html

.. method:: curl-curlu-setter
   :specializer: <curl-objectpoint>

   :signature:

     curl-curlu-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-objectpoint>`
   :value option: An instance of :class:`<curl-objectpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CURLU.html

.. method:: curl-trailerfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-trailerfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TRAILERFUNCTION.html

.. method:: curl-trailerdata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-trailerdata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TRAILERDATA.html

.. method:: curl-http09-allowed-setter
   :specializer: <curl-long>

   :signature:

     curl-http09-allowed-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HTTP09_ALLOWED.html

.. method:: curl-altsvc-ctrl-setter
   :specializer: <curl-long>

   :signature:

     curl-altsvc-ctrl-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_ALTSVC_CTRL.html

.. method:: curl-altsvc-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-altsvc-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_ALTSVC.html

.. method:: curl-maxage-conn-setter
   :specializer: <curl-long>

   :signature:

     curl-maxage-conn-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAXAGE_CONN.html

.. method:: curl-sasl-authzid-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-sasl-authzid-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SASL_AUTHZID.html

.. method:: curl-mail-rcpt-allowfails-setter
   :specializer: <curl-long>

   :signature:

     curl-mail-rcpt-allowfails-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAIL_RCPT_ALLOWFAILS.html

.. method:: curl-sslcert-blob-setter
   :specializer: <curl-blob>

   :signature:

     curl-sslcert-blob-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-blob>`
   :value option: An instance of :class:`<curl-blob>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSLCERT_BLOB.html

.. method:: curl-sslkey-blob-setter
   :specializer: <curl-blob>

   :signature:

     curl-sslkey-blob-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-blob>`
   :value option: An instance of :class:`<curl-blob>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSLKEY_BLOB.html

.. method:: curl-proxy-sslcert-blob-setter
   :specializer: <curl-blob>

   :signature:

     curl-proxy-sslcert-blob-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-blob>`
   :value option: An instance of :class:`<curl-blob>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SSLCERT_BLOB.html

.. method:: curl-proxy-sslkey-blob-setter
   :specializer: <curl-blob>

   :signature:

     curl-proxy-sslkey-blob-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-blob>`
   :value option: An instance of :class:`<curl-blob>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_SSLKEY_BLOB.html

.. method:: curl-issuercert-blob-setter
   :specializer: <curl-blob>

   :signature:

     curl-issuercert-blob-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-blob>`
   :value option: An instance of :class:`<curl-blob>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_ISSUERCERT_BLOB.html

.. method:: curl-proxy-issuercert-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-proxy-issuercert-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_ISSUERCERT.html

.. method:: curl-proxy-issuercert-blob-setter
   :specializer: <curl-blob>

   :signature:

     curl-proxy-issuercert-blob-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-blob>`
   :value option: An instance of :class:`<curl-blob>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_ISSUERCERT_BLOB.html

.. method:: curl-ssl-ec-curves-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-ssl-ec-curves-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSL_EC_CURVES.html

.. method:: curl-hsts-ctrl-setter
   :specializer: <curl-long>

   :signature:

     curl-hsts-ctrl-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HSTS_CTRL.html

.. method:: curl-hsts-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-hsts-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HSTS.html

.. method:: curl-hstsreadfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-hstsreadfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HSTSREADFUNCTION.html

.. method:: curl-hstsreaddata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-hstsreaddata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HSTSREADDATA.html

.. method:: curl-hstswritefunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-hstswritefunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HSTSWRITEFUNCTION.html

.. method:: curl-hstswritedata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-hstswritedata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HSTSWRITEDATA.html

.. method:: curl-aws-sigv4-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-aws-sigv4-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_AWS_SIGV4.html

.. method:: curl-doh-ssl-verifypeer-setter
   :specializer: <curl-boolean>

   :signature:

     curl-doh-ssl-verifypeer-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DOH_SSL_VERIFYPEER.html

.. method:: curl-doh-ssl-verifyhost-setter
   :specializer: <curl-long>

   :signature:

     curl-doh-ssl-verifyhost-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DOH_SSL_VERIFYHOST.html

.. method:: curl-doh-ssl-verifystatus-setter
   :specializer: <curl-boolean>

   :signature:

     curl-doh-ssl-verifystatus-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-boolean>`
   :value option: An instance of :class:`<curl-boolean>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_DOH_SSL_VERIFYSTATUS.html

.. method:: curl-cainfo-blob-setter
   :specializer: <curl-blob>

   :signature:

     curl-cainfo-blob-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-blob>`
   :value option: An instance of :class:`<curl-blob>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CAINFO_BLOB.html

.. method:: curl-proxy-cainfo-blob-setter
   :specializer: <curl-blob>

   :signature:

     curl-proxy-cainfo-blob-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-blob>`
   :value option: An instance of :class:`<curl-blob>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROXY_CAINFO_BLOB.html

.. method:: curl-ssh-host-public-key-sha256-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-ssh-host-public-key-sha256-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSH_HOST_PUBLIC_KEY_SHA256.html

.. method:: curl-prereqfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-prereqfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PREREQFUNCTION.html

.. method:: curl-prereqdata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-prereqdata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PREREQDATA.html

.. method:: curl-maxlifetime-conn-setter
   :specializer: <curl-long>

   :signature:

     curl-maxlifetime-conn-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MAXLIFETIME_CONN.html

.. method:: curl-mime-options-setter
   :specializer: <curl-long>

   :signature:

     curl-mime-options-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_MIME_OPTIONS.html

.. method:: curl-ssh-hostkeyfunction-setter
   :specializer: <curl-functionpoint>

   :signature:

     curl-ssh-hostkeyfunction-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-functionpoint>`
   :value option: An instance of :class:`<curl-functionpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSH_HOSTKEYFUNCTION.html

.. method:: curl-ssh-hostkeydata-setter
   :specializer: <curl-cbpoint>

   :signature:

     curl-ssh-hostkeydata-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-cbpoint>`
   :value option: An instance of :class:`<curl-cbpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SSH_HOSTKEYDATA.html

.. method:: curl-protocols-str-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-protocols-str-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_PROTOCOLS_STR.html

.. method:: curl-redir-protocols-str-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-redir-protocols-str-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_REDIR_PROTOCOLS_STR.html

.. method:: curl-ws-options-setter
   :specializer: <curl-long>

   :signature:

     curl-ws-options-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_WS_OPTIONS.html

.. method:: curl-ca-cache-timeout-setter
   :specializer: <curl-long>

   :signature:

     curl-ca-cache-timeout-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_CA_CACHE_TIMEOUT.html

.. method:: curl-quick-exit-setter
   :specializer: <curl-long>

   :signature:

     curl-quick-exit-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_QUICK_EXIT.html

.. method:: curl-haproxy-client-ip-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-haproxy-client-ip-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_HAPROXY_CLIENT_IP.html

.. method:: curl-server-response-timeout-ms-setter
   :specializer: <curl-long>

   :signature:

     curl-server-response-timeout-ms-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_SERVER_RESPONSE_TIMEOUT_MS.html

.. method:: curl-ech-setter
   :specializer: <curl-stringpoint>

   :signature:

     curl-ech-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-stringpoint>`
   :value option: An instance of :class:`<curl-stringpoint>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_ECH.html

.. method:: curl-tcp-keepcnt-setter
   :specializer: <curl-long>

   :signature:

     curl-tcp-keepcnt-setter (curl option) => (option)

   :parameter curl: An instance of :class:`<curl-easy>`
   :parameter option: An instance of :class:`<curl-long>`
   :value option: An instance of :class:`<curl-long>`

   :description:

   :seealso:

     https://curl.se/libcurl/c/CURLOPT_TCP_KEEPCNT.html
