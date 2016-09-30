#include <iostream>
#include <regex>
#include <string>
#include <vector>
#include <fstream>
using namespace std;

void readFromFile(const string& fileName, vector<string>& output) {
    if (fileName.empty()) {
        cout << "bad input file name!" << endl;
        return;
    }

    ifstream inStream(fileName.c_str(), ifstream::in);
    if (inStream.is_open()) {
        output.clear();
        string line;
        while (getline(inStream, line)) {
            output.push_back(line);
        }
        inStream.close();
    }
}

size_t convertHighlight(vector<string>& content, char* cmd) {
    string patternBegin;
    string patternEnd;
    regex regexBegin;
    regex regexEnd;
    string replaceBegin;
    string replaceEnd;

    if (string(cmd) == "--to-dot") {
        // match {% highlight <lan> %} and {% endhighlight %}, then replace with ```<lan> and ```.
        patternBegin = "[\\s\\t]*\\{[\\s\\t]*%[\\s\\t]*\\bhighlight[\\s\\t]*(\\S+)[\\s\\t]*%[\\s\\t]*\\}[\\s\\t]*";
        regexBegin = patternBegin;
        patternEnd = "[\\s\\t]*\\{[\\s\\t]*%[\\s\\t]*endhighlight[\\s\\t]*%[\\s\\t]*\\}";
        regexEnd = patternEnd;
        replaceBegin = "```$1";
        replaceEnd = "```";
    }
    else {
        // match ```<lan> and ```, then replace with {% highlight <lan> %} and {% endhighlight %}.
        patternBegin = "[\\s\\t]*```(\\S+)[\\s\\t]*";
        regexBegin = patternBegin;
        patternEnd = "[\\s\\t]*```[\\s\\t]*";
        regexEnd = patternEnd;
        replaceBegin = "{% highlight $1 %}";
        replaceEnd = "{% endhighlight %}";
    }

    // check every line, try to match begin and end.
    vector<string> backup;
    backup.swap(content);

    size_t matchCount(0);
    for (auto & line : backup) {
        smatch sm;
        // try to match begin.
        regex_match(line, sm, regexBegin);
        if (sm.size() == 2) {
            cout << "replace: " << line << endl;
            line = regex_replace(line, regexBegin, replaceBegin);
            ++matchCount;
            continue;
        }

        regex_match(line, sm, regexEnd);
        if (sm.size() == 1) {
            cout << "replace: " << line << endl;
            line = regex_replace(line, regexEnd, replaceEnd);
            ++matchCount;
        }
    }

    cout << "================ total replace: " << matchCount << "================ " << endl;
    if (matchCount > 0) {
        // write back to contents.
        content.swap(backup);
    }

    return matchCount;
}

void writeToFile(const string& fileName, const vector<string>& content) {
    if (fileName.empty()) { return; }

    ofstream out(fileName.c_str(), fstream::out);
    if (out.is_open()) {
        for (const auto& line : content) {
            out << line << endl;
        }
        out.close();
    }
}

void printUsage() {
    string help =
        "usage:                           \n"
        "                                 \n"
        " This program is used for converting highlight style of a markdown file(or any other text files):\n"
        " convert between style: {% highlight <language> %} and style: ```<language>.\n"
        "\n"
        " Choose a method, either --to-rouge or --to-dot: \n"
        " --to-rouge <file-name> : convert style from ```<language> to {% highlight <language> %} style \n"
        " --to-dot   <file-name> : convert from {% highlight <language> %} to ```<language>\n"
        "\n"
        " Then choose a modifying strategy, override the file or save as a new file: \n"
        " --override : override original file\n"
        " --backup   : save as a new file\n"
        " \n"
        " Example: convertHighlight --override --to-rouge hello.md\n"
        " or     : convertHighlight --backup   --to-rouge hello.md\n";
    cout << help;
}

int main(int argc, char** argv) {
    if (argc != 4) {
        printUsage();
        return 1;
    }

    string srcFileName(argv[3]);
    string dstFileName;

    string strategy(argv[1]);
    if ("--override" == strategy) {
        dstFileName = srcFileName;
    }
    else {
        dstFileName = srcFileName.substr(0, srcFileName.rfind('.')) + "-for-csdn.md";
    }

    cout << "src: " << srcFileName << endl;
    cout << "dst: " << dstFileName << endl;

    vector<string> content;
    size_t replaceCount(0);

    readFromFile(srcFileName, content);

    replaceCount = convertHighlight(content, argv[2]);

    if (replaceCount > 0) {
        writeToFile(dstFileName, content);
        cout << "writting to file" << dstFileName << endl;
    }
    else {
        cout << "SKIP writting to file: " << dstFileName << endl;
    }

    return 0;
}

