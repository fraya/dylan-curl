Installation
------------

Install curl library
^^^^^^^^^^^^^^^^^^^^

Install the Gnu TLS variant

.. example-code::

   .. code-block:: Debian/Ubuntu

      sudo apt install libcurl4-gnutls-dev

   .. code-block:: Opensuse Tumbleweed

      sudo zypper in libcurl-devel

Configure your Opendylan project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Add ``dylan-curl`` as a dependency to your ``dylan-package.json``.

Update the packages:

.. code-block:: console

   dylan update

- Add ``dylan-curl;`` to your library definition.
- Add ``easy-curl;`` to your module definition.
