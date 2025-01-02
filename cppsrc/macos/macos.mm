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

  Napi::Function consoleLog = env.Global().Get("console").As<Napi::Object>().Get("log").As<Napi::Function>();

  NSRunningApplication* runningApp = [[NSWorkspace sharedWorkspace] frontmostApplication];
  NSString *name = [runningApp localizedName];
  consoleLog.Call({ Napi::String::New(env, [name UTF8String]) });

  for (NSDictionary *info in (NSArray *)windowList) {
    if (info == NULL) {
      return obj;
    }

    NSNumber *ownerPid    = info[(id)kCGWindowNumber];
    NSString *windowName  = info[(id)kCGWindowName];
    NSString *windowClass = info[(id)kCGWindowOwnerName];
    
    auto app = [NSRunningApplication runningApplicationWithProcessIdentifier: [ownerPid intValue]];
    if (![app isActive]) {
      consoleLog.Call({ Napi::Boolean::New(env, [app isActive]) });
      if (windowClass != NULL) {
        consoleLog.Call({ Napi::String::New(env, [windowClass UTF8String]) });
      }
      continue;
    }

    if (windowClass != NULL) {
      obj.Set("windowClass", std::string([windowClass UTF8String]));
    }
    if (windowName != NULL) {
      obj.Set("windowName", std::string([windowName UTF8String]));
    }

    CFRelease(windowList);

    return obj;
  }

  if (windowList) {
    CFRelease(windowList);
  }

  return obj;
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
    exports.Set(Napi::String::New(env, "getActiveWindow"),
                Napi::Function::New(env, getActiveWindow));

    return exports;
}

NODE_API_MODULE(mezonaddon, Init)
