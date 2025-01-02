#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <ApplicationServices/ApplicationServices.h>
#include <napi.h>
#include <string>
#include <map>
#include <thread>
#include <fstream>

Napi::Object getActiveWindow(const Napi::CallbackInfo &info) {
  Napi::Env env{info.Env()};

  auto obj = Napi::Object::New(env);
  obj.Set("os", "macos");
	//obj.Set("windowClass", "");
	//obj.Set("windowName", "");
	obj.Set("windowDesktop", "0");
	obj.Set("windowType", "0");
	obj.Set("windowPid", "0");
	obj.Set("idleTime", "0");

  NSRunningApplication* runningApp = [[NSWorkspace sharedWorkspace] frontmostApplication];
  NSString *name = [runningApp localizedName];
  if (name != NULL) {
    obj.Set("windowClass", std::string([name UTF8String]));
	  obj.Set("windowName", std::string([name UTF8String]));
  }

  return obj;
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
    exports.Set(Napi::String::New(env, "getActiveWindow"),
                Napi::Function::New(env, getActiveWindow));

    return exports;
}

NODE_API_MODULE(mezonaddon, Init)
