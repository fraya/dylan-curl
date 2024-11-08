# dylan-curl
[Opendylan](https://opendylan.org) binding around [libcurl](https://curl.se/libcurl/)

This software is alpha.

## Usage

### Install curl library

Gnu TLS variant in Debian/Ubuntu:

```
sudo apt install libcurl4-gnutls-dev
```

or OpenSSL variant

```
sudo apt install libcurl4-openssl-dev
```

### Install dylan-curl library

- Add `dylan-curl` as a dependency to your `dylan-package.json`.

- Add `dylan-curl;` to your library definition.

- Add `easy-curl;` to your module definition.

### Update

```
dylan update
```

## Tests

1. Clone the repository.

2. See [README](./tests/README.md) in test directory.

3. Build the tests:

```
dylan build curl-easy-test-suite
```

4. Run the tests:

```
_build/bin/curl-easy-test-suite
```

## Documentation

See https://github.com/fraya/dylan-curl
