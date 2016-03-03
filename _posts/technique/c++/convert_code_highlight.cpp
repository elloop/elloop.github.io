#include <iostream>
#include <regex>
#include <string>
#include <vector>
#include <fstream>
using namespace std;

void read_from_file(const string& file_name, vector<string>& output)
{
   if (file_name.empty()) {
      cout << "bad input file name!" << endl;
      return;
   }

   ifstream in_stream(file_name.c_str(), ifstream::in);
   if (in_stream.is_open()) {
      output.clear();
      string line;
      while (getline(in_stream, line)) {
	 output.push_back(line);
      }
      in_stream.close();
   }
}

void convert_highlight(vector<string>& content, char* cmd)
{
   string pattern_begin;
   string pattern_end;
   regex regex_begin;
   regex regex_end;
   string replace_begin;
   string replace_end;

   if (string(cmd) == "--to-dot")
   {
      // match {% highlight <lan> %} and {% endhighlight %}, then replace with ```<lan> and ```.
      pattern_begin = "\\{[\\s\\t]*%[\\s\\t]*\\bhighlight[\\s\\t]*(\\S+)[\\s\\t]*%[\\s\\t]*\\}[\\s\\t]*";
      regex_begin = pattern_begin;
      pattern_end = "\\{[\\s\\t]*%[\\s\\t]*endhighlight[\\s\\t]*%[\\s\\t]*\\}";
      regex_end = pattern_end;
      replace_begin = "```$1";
      replace_end = "```";
   }
   else
   {
      // match ```<lan> and ```, then replace with {% highlight <lan> %} and {% endhighlight %}.
      pattern_begin = "```(\\S+)[\\s\\t]*";
      regex_begin = pattern_begin;
      pattern_end = "```[\\s\\t]*";
      regex_end = pattern_end;
      replace_begin = "{% highlight $1 %}";
      replace_end = "{% endhighlight %}";
   }

   // check every line, try to match begin and end.
   vector<string> backup;
   backup.swap(content);

   size_t match_count(0);
   for (auto & line : backup)
   {
      smatch sm;
      // try to match begin.
      regex_match(line, sm, regex_begin);
      if (sm.size() == 2)
      {
#ifdef Debug
	 cout << "replace: " << line << endl;
#endif
	 line = regex_replace(line, regex_begin, replace_begin);
	 ++match_count;
	 continue;
      }

      regex_match(line, sm, regex_end);
      if (sm.size() == 1)
      {
#ifdef Debug
	 cout << "replace: " << line << endl;
#endif
	 line = regex_replace(line, regex_end
, replace_end);
	 ++match_count;
      }
   }

   // override contents.
   content.swap(backup);
#ifdef Debug
   cout << "total replace: " << match_count << endl;
#endif
}

void write_to_file(const string& file_name, const vector<string>& content)
{
   if (file_name.empty())
   {
      return;
   }

   ofstream out(file_name.c_str(), fstream::out);
   if (out.is_open())
   {
      for (const auto& line : content)
      {
	 out << line << endl;
      }
      out.close();
   }
}

void printUsage()
{
   string help =
      "usage:                           \n"
      "                                 \n"
      " --to-rouge <file-name> : convert style from ```<language> to {% highlight <language> %} style \n"
      " --to-dot   <file-name> : convert from {% highlight <language> %} to ```<language>\n";
   cout << help;
}

#define Debug

int main(int argc, char** argv) 
{
   if (argc != 3)
   {
      printUsage();
      return 1;
   }
   
   string srcfile_name(argv[2]);
   string dstfile_name = srcfile_name.substr(0, srcfile_name.rfind('.')) + "-for-csdn.md";

#ifdef Debug
   cout << "src: " << srcfile_name << endl;
   cout << "dst: " << dstfile_name << endl;
#endif


   vector<string> content;
   read_from_file(srcfile_name, content);
   convert_highlight(content, argv[1]);
   write_to_file(dstfile_name, content);

   return 0;
}
