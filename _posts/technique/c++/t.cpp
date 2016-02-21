#include <iostream>
#include <string>
using namespace std;
int main() {

    string s("{% high %}");
    cout << s << endl;

    string::size_type pos = s.find("{% hg");
    cout << pos << endl;
    cout << string::npos << endl;

    string sub = s.substr(0, pos);
    cout << sub << endl;

    string news = sub.append("-for-csdn.md");
    cout << news << endl;
    return 0;
}
