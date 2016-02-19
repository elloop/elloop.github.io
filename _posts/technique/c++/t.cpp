#include <iostream>
#include <string>
using namespace std;
int main() {

    string s("hello.md");
    string sub = s.substr(0, s.rfind('.'));
    string news = sub.append("-for-csdn.md");
    cout << news << endl;
    return 0;
}
