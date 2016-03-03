
// regex_match example
#include <iostream>
#include <string>
#include <regex>
using namespace std;
int main ()
{

/*
  string s("{%    highlight  c++   %} ");
  cout << "target: " << s << endl;

  string pattern("\\{[\\s\\t]*%[\\s\\t]*\\bhighlight[\\s\\t]*(\\S+)[\\s\\t]*%[\\s\\t]*\\}[\\s\\t]*");
  regex e(pattern.c_str());
  cout << "pattern: " << pattern << endl;

  smatch sm;
  regex_match(s, sm, e);
  if (sm.size() == 2)
  {
  cout << regex_replace(s, e, "```$1") << endl;      
  }
*/

/*
   string s1e("{   %      endhighlight    	  %   }");

   string pat2("\\{[\\s\\t]*%[\\s\\t]*endhighlight[\\s\\t]*%[\\s\\t]*\\}");
   regex e2(pat2.c_str());
   cout << "pattern e2: " << pat2 << endl;

   smatch sm1e;
   regex_match(s1e, sm1e, e2);
   cout << "size: " << sm1e.size() << endl;
   if (sm1e.size() == 1)
   {
      cout << regex_replace(s1e, e2, "```") << endl;
   }
*/

/*
   string s2b("```c++      ");
   string pat2("```(\\S+)[\\s\\t]*");
   regex e3(pat2.c_str());
   cout << "pattern 2b: " << pat2 << endl;

   smatch sm2b;
   regex_match(s2b, sm2b, e3);
   if (sm2b.size() == 2)
   {
      cout << regex_replace(s2b, e3, "{% highlight $1 %}");
   }
*/

   string s2e("```           \n");
   string pat3("```[\\s\\t]*");
   regex e4;
   e4 = pat3;
   cout << "pattern : " << pat3 << endl;
   
   smatch sm2e;
   regex_match(s2e, sm2e, e4);
   if (sm2e.size() == 1)
   {
      cout << regex_replace(s2e, e4, "{% endhighlight %}");
   }
 
   /*
     if (std::regex_match ("subject", std::regex("(sub)(.*)") ))
     std::cout << "string literal matched\n";

     const char cstr[] = "subject";
     std::string s ("subject");
     std::regex e ("(sub)(.*)");

     if (std::regex_match (s,e))
     std::cout << "string object matched\n";

     if ( std::regex_match ( s.begin(), s.end(), e ) )
     std::cout << "range matched\n";

     std::cmatch cm;    // same as std::match_results<const char*> cm;
     std::regex_match (cstr,cm,e);
     std::cout << "string literal with " << cm.size() << " matches\n";

     std::smatch sm;    // same as std::match_results<string::const_iterator> sm;
     std::regex_match (s,sm,e);
     std::cout << "string object with " << sm.size() << " matches\n";

     std::regex_match ( s.cbegin(), s.cend(), sm, e);
     std::cout << "range with " << sm.size() << " matches\n";

     // using explicit flags:
     std::regex_match ( cstr, cm, e, std::regex_constants::match_default );

     std::cout << "the matches were: ";
     for (unsigned i=0; i<sm.size(); ++i) {
     std::cout << "[" << sm[i] << "] ";
     }

     std::cout << std::endl;

   */

   return 0;
}
