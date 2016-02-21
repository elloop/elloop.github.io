#include <iostream>
#include <string>
#include <regex>

using namespace std;
int main() {

    string s("{% highlight cpp %}");
    cout << s << endl;

    regex e("\\b({% highlight})(*)(%})");

    cout << regex_replace(s, e, "c++") << endl;

    return 0;
}
