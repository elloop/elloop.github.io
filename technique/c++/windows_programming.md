# Windows Programming
===

# Unicode in windows
## _T and __T
```
#ifdef UNICODE
#define __T(x)      L ## x
#else
#define __T(x)      x
#endif

#define _T(x) __T(x)
```
## how to define UNICODE in VS.
In Project setting -> common -> character set : Unicdoe or Mutibytes.

## an example of command line args parsing, with Unicode support.
 ```
 auto args = elloop_test::StringUtil::split(cmd_line, ' ');
    //auto args = GameMaths::tokenize(cmd_line, _T" ");
    auto iter = args.begin();
    while (iter != args.end())
    {
        if (*iter == _T("--no-console")) {
            use_console = false;
            ++iter;
        }
        else if (*iter == _T("--window-size")) {
            if ((iter + 1) != args.end() && (iter + 2) != args.end()) {
                auto width = *(iter + 1);
                #ifdef UNICODE
                DWORD len = WideCharToMultiByte(CP_OEMCP,NULL,width.c_str(),-1,NULL,0,NULL,FALSE);
                char *width_val;
                width_val = new char[len];
                WideCharToMultiByte(CP_OEMCP, NULL, width.c_str(), -1, width_val, len, NULL, FALSE);
                int w = StringConverter::parseInt(width_val, 0);
                if (w > 0) {
                    win_width = w;
                }
                delete [] width_val;
                #else
                int w = StringConverter::parseInt(width, 0);
                if (w > 0) {
                    win_width = w;
                }
                #endif

                auto height = *(iter + 2);
                #ifdef UNICODE
                len = WideCharToMultiByte(CP_OEMCP, NULL, height.c_str(), -1, NULL, 0, NULL, FALSE);
                char * height_val = new char[len];
                WideCharToMultiByte(CP_OEMCP, NULL, height.c_str(), -1, height_val, len, NULL, FALSE);
                int h = StringConverter::parseInt(height_val, 0);
                if (h > 0) {
                    win_height = h;
                }
                delete[] height_val;
                #else
                int h = StringConverter::parseInt(height, 0);
                if (h > 0) {
                    win_height = h;
                }
                #endif

                iter += 2;
            }
        }
        else {
            ++iter;
        }
    }
 ```
