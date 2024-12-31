#include <napi.h>

#ifdef __linux__
#include "linux/windowlinux.h"
#endif

#ifdef _WIN32
#include "windows/windowwindows.h"
#endif

#ifdef _WIN32 
Napi::Object InitAll(Napi::Env env, Napi::Object exports) {
	return windowwindows::Init(env, exports);
}

NODE_API_MODULE(mezonaddon, InitAll)
#elif __linux
Napi::Object InitAll(Napi::Env env, Napi::Object exports) {
	return windowlinux::Init(env, exports);
}

NODE_API_MODULE(mezonaddon, InitAll)
#endif
