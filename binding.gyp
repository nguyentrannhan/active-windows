{
  "targets": [
    {
      "target_name": "wm",
      "sources": [ "cppsrc/main.cpp"],
      "cflags": ["-fexceptions -std=c++11"],
      "cflags_cc": ["-fexceptions"],
      'conditions': [
         ['OS=="linux"', {
           'sources': ["cppsrc/main.cpp", "cppsrc/linux/windowlinux.cpp"],
           'libraries': [
               "-lX11",
               "-lXss",
               "-lxcb"
             ],
             'cflags': ["-fexceptions -std=c++11 -lX11 -lXext -lXss"],
             'cflags_cc': ["-fexceptions -lX11 -lXext -lXss"],
           }
         ],
         ['OS=="win"', {
           'sources': ["cppsrc/main.cpp", "cppsrc/windows/windowwindows.cpp"]
            }
         ],
         ['OS=="mac"', {
           'sources': ["cppsrc/macos/macos.mm"],
           'libraries': ["-framework AppKit", "-framework ApplicationServices"],
           'variables': {
            'clang_version':
              '<!(cc -v 2>&1 | perl -ne \'print $1 if /clang version ([0-9]+(\\.[0-9]+){2,})/\')'
            },
           'xcode_settings': {
             'GCC_ENABLE_CPP_EXCEPTIONS': 'YES'
            },
           'conditions': [
            # Use Perl v-strings to compare versions.
            ['clang_version and <!(perl -e \'print <(clang_version) cmp 12.0.0\')==1', {
              'xcode_settings': {
                'OTHER_CFLAGS': ['-arch arm64'],
                'OTHER_LDFLAGS': ['-arch arm64']
              }
            }]
           ]
         }],
      ],
      'include_dirs': [
           "<!@(node -p \"require('node-addon-api').include\")"
       ],
      'dependencies': [
         "<!(node -p \"require('node-addon-api').gyp\")"
       ],
       'defines': [ 'NAPI_DISABLE_CPP_EXCEPTIONS' ]
    },
  ]
}
