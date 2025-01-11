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

  NSArray *codeEditor = @[ 
    @"code",
    @"sublime",
    @"atom",
    @"notepad",
    @"coffee",
    @"text",
    @"bluefish",
    @"vim",
    @"netbean",
    @"emacs",
    @"edit",
    @"nova",
    @"unity",
    @"figma",
    @"spotify",
    @"photoshop"
  ];

  for (NSDictionary *info in (NSArray *)windowList) {
    if (info == NULL) {
      continue;
    }

    NSNumber *ownerPid    = info[(id)kCGWindowNumber];
    NSString *windowName  = info[(id)kCGWindowName];
    NSString *windowClass = info[(id)kCGWindowOwnerName];

    obj.Set("windowPid", std::string([[ownerPid stringValue] UTF8String]));

    if (windowName == NULL && windowClass == NULL) {      
      continue;
    }

    for (NSString *key in codeEditor) {
      if ([windowClass localizedCaseInsensitiveContainsString:key]) {
        obj.Set("windowClass", std::string([windowClass UTF8String]));
    
        if (windowName != NULL) {
          obj.Set("windowName", std::string([windowName UTF8String]));
        }

        CFRelease(windowList);

        return obj;
      }
    }
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
