Curl global
===========

..
   .. current-library:: curl
   .. current-module:: easy-curl		     

Global setup
------------

See `Global preparation <https://curl.se/libcurl/c/libcurl-tutorial.html>`_.

Global flags
------------

- :const:`$curl-global-ssl`
- :const:`$curl-global-win32`
- :const:`$curl-global-all`
- :const:`$curl-global-nothing`
- :const:`$curl-global-default`
- :const:`$curl-global-ack-eintr`

Functions
---------

- :func:`curl-global-init`
- :func:`curl-global-cleanup`

.. function:: curl-global-init
	      
   :signature:

      curl-global-init *flags* => *code*

   :description:      

   See `curl_global_init <https://curl.se/libcurl/c/curl_global_init.html>`_

.. function:: curl-global-cleanup

   :signature:

      curl-global-cleanup => ()
   
   See `curl_global_cleanup <https://curl.se/libcurl/c/curl_global_cleanup.html>`_


