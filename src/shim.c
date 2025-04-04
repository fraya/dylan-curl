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

/*****************************************************************************
 *
 *  CURLM options shim functions
 *
 *****************************************************************************/

 CURLcode curlm_setopt_long(CURLM *handle, CURLoption option, int value)
 {
   return curl_multi_setopt(handle, option, (long) value);
 }
 
 CURLcode curlm_setopt_objectpoint(CURLM *handle, CURLoption option, void *value)
 {
   return curl_multi_setopt(handle, option, value);
 }
 
 CURLcode curlm_setopt_functionpoint(CURLM *handle, CURLoption option, void *f)
 {
   return curl_multi_setopt(handle, option, f);
 }
 
 CURLcode curlm_setopt_offt(CURLM *handle, CURLoption option, curl_off_t value)
 {
   return curl_multi_setopt(handle, option, value);
 }
