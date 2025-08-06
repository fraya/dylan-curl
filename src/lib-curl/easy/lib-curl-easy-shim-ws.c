#include <curl/curl.h>

CURLcode shim_curl_ws_send ( CURL *curl, const void *buffer, size_t buflen, curl_off_t fragsize, unsigned int flags, size_t *sent)
{
  return curl_ws_send(curl, buffer, buflen, sent, fragsize, flags);
}
