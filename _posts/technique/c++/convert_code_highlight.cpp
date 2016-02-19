#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
using namespace std;

void read_from_file(const string& file_name, string& output)
{
    if (file_name.empty()) {
        return;
    }

    ifstream in_stream(file_name.c_str(), ifstream::in);
    if (in_stream.is_open()) {
        output.clear();
        string line;
        while (getline(in_stream, line)) {
            output.append(line + "\n");
        }
        in_stream.close();
    }
}

void convert_highlight(string& content)
{
    string backup;
    backup.swap(content);
    stringstream s_stream(backup);
    string line;
    while (getline(s_stream, line)) {
        string::size_type pos = line.find("{\% highlight");
        if (pos != string::npos) {
            string temp = 
        }
    }
}

void write_to_file(const string& file_name, const string& content)
{

}

int main() 
{
    string srcfile_name;
    cout << "input the src file name:";
    cin >> srcfile_name;

    string dstfile_name = srcfile_name.substr(0, srcfile_name.rfind('.')) + "-for-csdn.md";

    string content;
    read_from_file(srcfile_name, content);
    convert_highlight(content);
    write_to_file(dstfile_name, content);


    return 0;
}
