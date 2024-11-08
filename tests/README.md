# dylan-curl tests

Some of the tests use `httpbin.org`. It may happen that the website
rejects requests because they are too frequent. To avoid this problem
and to make testing faster, it is recommended to use a local Docker
image.

## Testing using a Docker image

With docker:

```bash
sudo docker run --rm -d -p 8080:80 kennethreitz/httpbin
```

or with podman:

```bash
podman run --rm -d -p 8080:80 docker.io/kennethreitz/httpbin
```

Then we will run the tests by setting the following environment
variables:

- `HTTPBIN` (defaults to `httpbin.org` if not set) and
- `HTTPBIN_PORT` (defaults to `80` if not set).

```bash
HTTPBIN=localhost HTTPBIN_PORT=8080 _build/bin/curl-easy-test-suite
```