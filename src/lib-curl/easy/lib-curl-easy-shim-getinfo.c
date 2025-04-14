#include <curl/curl.h>

/**
 * CURL info functions shim
 */

char* curl_easy_getinfo_string (CURL *handle, CURLINFO option, CURLcode *code)
{
  char* result = NULL;
  *code = curl_easy_getinfo(handle, option, &result);
  return result;
}

long curl_easy_getinfo_long (CURL *handle, CURLINFO option, CURLcode *code)
{
  long result;
  *code = curl_easy_getinfo(handle, option, &result);
  return result;
}

double curl_easy_getinfo_double (CURL *handle, CURLINFO option, CURLcode *code)
{
  double result;
  *code = curl_easy_getinfo(handle, option, &result);
  return result;
}

curl_off_t curl_easy_getinfo_offt (CURL *handle, CURLINFO option, CURLcode *code)
{
  curl_off_t result;
  *code = curl_easy_getinfo(handle, option, &result);
  return result;
}

struct curl_slist* curl_easy_getinfo_slist (CURL *handle, CURLINFO option, CURLcode *code)
{
  struct curl_slist* result = NULL;
  *code = curl_easy_getinfo(handle, option, &result);
  return result;
}

void* curl_easy_getinfo_ptr (CURL *handle, CURLINFO option, CURLcode *code)
{
  void* result = NULL;
  *code = curl_easy_getinfo(handle, option, result);
  return result;
}

/* struct curl_tlssessioninfo* curl_easy_getinfo_tlssessioninfo (CURL *handle, CURLINFO option, CURLcode *code) */
/* { */
/*   struct curl_tlssessioninfo* result = NULL; */
/*   *code = curl_easy_getinfo(handle, option, &result); */
/*   return result; */
/* } */

/* struct curl_certinfo* curl_easy_getinfo_certinfo (CURL *handle, CURLINFO option, CURLcode *code) */
/* { */
/*   struct curl_certinfo* result = NULL; */
/*   *code = curl_easy_getinfo(handle, option, &result); */
/*   return result; */
/* } */
