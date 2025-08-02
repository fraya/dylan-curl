#include <curl/curl.h>

CURLSHcode curl_share_setopt_callback ( CURLSH *share, CURLSHoption option, void *cb )
{
  return curl_share_setopt(share, option, cb);
}

CURLSHcode curl_share_setopt_long ( CURLSH *share, CURLSHoption option, long type )
{
  return curl_share_setopt(share, option, type);
}

CURLSHcode curl_share_setopt_clientp ( CURLSH *share, CURLSHoption option, void *clientp )
{
  return curl_share_setopt(share, option, clientp);
}
