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

  CGWindowListOption listOptions = kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements;
  CFArrayRef windowList = CGWindowListCopyWindowInfo(listOptions, kCGNullWindowID);

  auto obj = Napi::Object::New(env);
  obj.Set("os", "macos");
	obj.Set("windowClass", "");
	obj.Set("windowName", "");
	obj.Set("windowDesktop", "0");
	obj.Set("windowType", "0");
	obj.Set("windowPid", "0");
	obj.Set("idleTime", "0");

  for (NSDictionary *info in (NSArray *)windowList) {
    NSNumber *ownerPid = info[(id)kCGWindowOwnerPID];
    NSNumber *windowNumber = info[(id)kCGWindowNumber];

    auto app = [NSRunningApplication runningApplicationWithProcessIdentifier: [ownerPid intValue]];

    if (![app isActive]) {
      continue;
    }

    int handle = [windowNumber intValue]
    auto wInfo = getWindowInfo(handle);
    if (wInfo) {
      NSString *windowName = wInfo[(id)kCGWindowOwnerName];
      obj.Set("windowName", std::string([windowName UTF8String]));
    }

    CFRelease(windowList);

    return obj;
  }

  if (windowList) {
    CFRelease(windowList);
  }

  return obj
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
    exports.Set(Napi::String::New(env, "getActiveWindow"),
                Napi::Function::New(env, getActiveWindow));

    return exports;
}

NODE_API_MODULE(mezonaddon, Init)
