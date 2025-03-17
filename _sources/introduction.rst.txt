Introduction
============

``dylan-curl`` is a wrapper around the popular libcurl library,
providing a way to interact with network resources from within Open
Dylan programs. This wrapper tries to simplify the complexities of
libcurl, offering a Dylan-friendly API while maintaining the core
capabilities of the underlying C library.

**Key Features**

Protocols offered by ``libcurl``:
  Support for a variety of protocols, including HTTP, HTTPS, FTP,
  FTPS, SCP, SFTP, TFTP, LDAP, and more.  Enables secure data transfer
  with HTTPS through SSL/TLS support.

Dylan Integration:
  Uses Dylan idioms to provide an interface that feels natural to
  Dylan developers.  Converts libcurl's low-level C-style error
  handling into Dylan's exception mechanism for cleaner and more
  reliable error management.

How to convert a libcurl program
--------------------------------

When converting a libcurl-based C program to the Open Dylan wrapper, a
few conventions streamline the process. Below are the main conventions
and their corresponding Open Dylan equivalents.

Creating a CURL Handle
^^^^^^^^^^^^^^^^^^^^^^

In libcurl, you create a handle using `curl_easy_init
<https://curl.se/libcurl/c/curl_easy_init.html>`_. In the Open Dylan
wrapper, you create an object of the :class:`<curl-easy>` class.

.. code-block:: C
   :caption: C example

   CURL *curl = curl_easy_init();
   if (curl) {
     ...
     curl_easy_cleanup(curl);
   }

The macro :macro:`with-curl-easy` handles both initialization and
automatic cleanup when it is no longer accessible. If initialization
fails, a :class:`<curl-init-error>` exception is raised.

.. code-block:: dylan
   :caption: Dylan example

   block ()
     with-curl-easy (curl = make(<curl-easy>))
       // perform request
       // gather information about the request
     end;
   exception (err :: <curl-init-error>)
     format-err("Error initializing curl: %s\n",
                 err.curl-error-message)
   end;

Setting Parameters
^^^^^^^^^^^^^^^^^^

In libcurl, parameters are configured using `curl_easy_setopt
<https://curl.se/libcurl/c/curl_easy_setopt.html>`_, where a constant
representing the option name is paired with its value. In the Open
Dylan wrapper, options are set directly using property syntax, such as
``curl.curl-option-name := value``. If an error occurs while setting a
parameter, a :class:`<curl-option-error>` exception is raised.

.. code-block:: c
   :caption: Example showing the error checking, usually hidden in examples.	 

   CURLCODE code = curl_easy_setopt(curl, CURLOPT_URL, "https://example.com");
   if (code != CURLE_OK) {
      fprintf(stderr,
              "Error setting option: %s\n",
              curl_easy_strerror(res));
      return 1;
   }

In libcurl, each parameter should be validated after calling the
``curl_easy_setopt`` function, although this step is often omitted in
examples for simplicity. The libcurl documentation cautions: *"A
real-world application will, of course, properly check every return
value and exit correctly at the first serious error."*

In Open Dylan, whenever an option is set, the result is automatically
checked. If an error occurs, an exception is raised, allowing it to be
handled either immediately at the point of the operation or deferred
to another method for centralized error handling.

.. code-block:: dylan
   :caption: In Dylan errors can be captured in a block.

   block ()
     with-curl-easy (curl = make(<curl-easy>))
       curl.curl-url := "https://example.com";
       // perform request
       // gather information
     end;
   exception (err :: <curl-option-error>)
     format-err("Error setting option: %s\n",
                 err.curl-error-message)
   end block;

If you need to set a lot of options, you can pass them to the
:drm:`make` method with less verbosity.

.. code-block:: dylan

   block ()
     with-curl-easy (curl = make(<curl-easy>,
                                 url: "https://example.org",
                                 ssl-verifypeer: #f,
                                 ssl-verifyhost: 1,
                                 ca-cache-timeout: 604800))
       // perform request
       // gather information
     end with-curl-easy;
   exception (err :: <curl-option-error>)
     format-err("Error setting option: %s\n",
                 err.curl-error-message)
   end block;

Performing the Request
^^^^^^^^^^^^^^^^^^^^^^

In libcurl, the request is executed using `curl_easy_perform`. The
Open Dylan equivalent is the method :func:`curl-easy-perform`.

.. code-block:: C
   :caption: C Example

   CURLcode res = curl_easy_perform(curl);

   if (res != CURLE_OK) {
     fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
   } else {
     printf("Request completed successfully.\n");
   }

In Opendylan :func:`curl-perform` raises a
:class:`<curl-perform-error>`.

.. code-block:: dylan
   :caption: Dylan example

   block ()
     curl-easy-perform(curl);
     format-out("Request completed successfully.\n")
   exception (err :: <curl-perform-error>)
      format-err("Curl failed: %s\n",
                  curl.curl-error-message)
   end block;

Retrieving Information
^^^^^^^^^^^^^^^^^^^^^^

In libcurl, retrieving information is done with ``curl_easy_getinfo``,
passing a constant for the type of information. In the Open Dylan
wrapper, you access the information directly using property syntax.

.. code-block:: c
   :caption: C example getting the total time of previous transfer

   double total_time;
   CURLCODE res;

   curl_easy_setopt(curl, CURLOPT_URL, "https://example.com/");
   res = curl_easy_perform(curl);
   if (CURLE_OK == res) {
     res = curl_easy_getinfo(curl, CURLINFO_TOTAL_TIME, &total_time);
     if (CURLE_OK == res) {
       printf("Time: %.1f", total_time);
     } else {
       fprintf(stderr, "curl_easy_getinfo() failed: %s\n",
                       curl_easy_strerror(res));
     }
   } else {
     fprintf(stderr, "curl_easy_perform() failed: %s\n",
             curl_easy_strerror(res));
   }
   /* always cleanup */
   curl_easy_cleanup(curl);

.. code-block:: dylan
   :caption: Dylan Example

   block ()
      with-curl-easy (curl = make(<curl>,
                                  url: "https://example.com/"))
        curl-easy-perform(curl);
        format-out("Time: %d", curl.total-time)
      end;
   exception (err :: <curl-info-error>)
      format-err("curl easy getinfo failed: %s\n",
                 err.curl-error-message)
   exception (err :: <curl-perform-error>)
      format-err("curl easy perform failed: %s\n",
                 err.curl-error-message)
   end block;

Headers
-------

Libcurl offers manipulation of HTTP headers using `CURLOPT_HTTPHEADER`
option.

Libcurl's `CURLOPT_HTTPHEADER` option allows you to send custom HTTP
headers with your requests.  The option accepts a linked list of
header strings, which you build using `curl_slist` and `curl_slist_append`.

.. code-block:: C
   :caption: Libcurl example using HTTP headers

   CURL *curl;
   CURLcode res;

   curl_global_init(CURL_GLOBAL_DEFAULT);
   curl = curl_easy_init();

   struct curl_slist *headers = NULL;
   headers = curl_slist_append(headers, "Content-Type: application/json");
   headers = curl_slist_append(headers, "Authorization: Bearer your_token_here");
   headers = curl_slist_append(headers, "X-Custom-Header: Custom Value");

   if (curl) {
     curl_easy_setopt(curl, CURLOPT_URL, "https://api.example.com/data");
     curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

     // ... other curl options ...

     res = curl_easy_perform(curl);

     if (res != CURLE_OK) {
        fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
     }

     curl_slist_free_all(headers);
     curl_easy_cleanup(curl);
   }
   curl_global_cleanup();

The above example could be translated to Opendylan in three ways:

.. code-block:: dylan
   :caption: Using `add-header!`

   with-curl-global($curl-global-default)
     with-curl-easy(curl = make(<curl-easy>,
                                url: "https://api.example.com/data"))

       add-header!(curl,
                   "Content-Type: application/json",
                   "Authorization: Bearer your_token_here",
                   "X-Custom-Header: Custom Value");

       // ... other curl options ...

       curl-easy-perform(curl);

       end with-curl-easy;
   end with-curl-global;

Or passing the options to :drm:`make` method:

.. code-block:: dylan
   :caption: Using `make` keywords

   with-curl-global($curl-global-default)
     with-curl-easy(curl = make(<curl-easy>,
                                url: "https://api.example.com/data",
                                header: "Content-Type: application/json",
                                header: "Authorization: Bearer your_token_here",
                                header: "X-Custom-Header: Custom Value"))

       // ... other curl options ...

       curl-easy-perform(curl);

     end with-curl-easy;
   end with-curl-global;

Or using the setter method :meth:`curl-header-setter`

.. code-block:: dylan
   :caption: Using `curl-header-setter`

   with-curl-global($curl-global-default)
     with-curl-easy(curl = make(<curl-easy>,
                                url: "https://api.example.com/data"))

       curl.curl-header := "Content-Type: application/json";
       curl.curl-header := "Authorization: Bearer your_token_here";
       curl.curl-header := "X-Custom-Header: Custom Value";

       // ... other curl options ...

       curl-easy-perform(curl);

     end with-curl-easy;
   end with-curl-global;
