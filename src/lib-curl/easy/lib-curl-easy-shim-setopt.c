#include <curl/curl.h>

/**
 *  CURL options shim functions
 */

CURLcode curl_setopt_long(CURL *handle, CURLoption option, int value)
{
  return curl_easy_setopt(handle, option, (long) value);
}

CURLcode curl_setopt_objectpoint(CURL *handle, CURLoption option, void *value)
{
  return curl_easy_setopt(handle, option, value);
}

CURLcode curl_setopt_functionpoint(CURL *handle, CURLoption option, void *f)
{
  return curl_easy_setopt(handle, option, f);
}

CURLcode curl_setopt_offt(CURL *handle, CURLoption option, curl_off_t value)
{
  return curl_easy_setopt(handle, option, value);
}

CURLcode curl_setopt_blob(CURL *handle, CURLoption option, struct curl_blob *stblob)
{
  return curl_easy_setopt(handle, option, stblob);
}

CURLcode curl_setopt_stringpoint(CURL *handle, CURLoption option, char *string)
{
  return curl_easy_setopt(handle, option, string);
}

CURLcode curl_setopt_slistpoint(CURL *handle, CURLoption option, struct curl_slist *slist)
{
  return curl_easy_setopt(handle, option, slist);
}

CURLcode curl_setopt_cbpoint(CURL *handle, CURLoption option, void *f)
{
  return curl_easy_setopt(handle, option, f);
}

CURLcode curl_setopt_values(CURL *handle, CURLoption option, int values)
{
  return curl_easy_setopt(handle, option, (long) values);
}

CURLcode curl_setopt_boolean(CURL *handle, CURLoption option, int value)
{
  return curl_easy_setopt(handle, option, (long) value);
}

