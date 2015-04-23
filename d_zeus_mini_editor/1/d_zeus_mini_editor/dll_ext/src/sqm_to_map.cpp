
#include "sqm_to_map.h"

#include "win32_file_handling.h"

//#define DEBUG

#ifdef DEBUG
#include <iostream>
#endif



using namespace std;


namespace app
{
	
	
	// private functions
	
	//
	// read sqm file
	//
	

	bool whitespace(char c)
	{
		return c == '\t' || c == '\n' || c == '\r' || c == ' '; 
	}
	
	//
	// read quoted string like this "Message is ""The message!""."
	//
	
	string read_quoted_string(win::File& fi)
	{
		string s;
		char c;
		
		while (fi.get(c))
		{
			if (c == '"')
			{
				char pc = (char) fi.peek();
				
				// ""
				if (pc == '"')
				{
					fi.get(c);
					
					s += "\"\"";
					
					continue;
				}
				// " - end of string
				else
					break;
			}
			
			s += c;
		}
		
		if (!fi) throw string("Unexpected EOF (q) (buf)") + s;
		
		return s;
	}
	
	//
	// read current-level class from sqm 
	//
	
	_class read_subclass(win::File& fi)
	{
		
		
		char c;
		_class cl;
		
		while (fi)
		{
			while (fi.get(c) && whitespace(c));
			
			// end of current class
			if (!fi || c == '}')
				break;
			
			string buf;
			buf += c;
			
			while (fi.get(c) && !(whitespace(c) || c == '='))
				buf += c;
			
			// have a subclass here
			if (whitespace(c) && buf == "class")
			{
				string buf2;
				
				while(whitespace(c) && fi.get(c));
				
				buf2 += c;
				while(fi.get(c) && !(whitespace(c) || c == '{'))   buf2 += c;


#ifdef DEBUG				
				cout << "~" << "cl:" << buf2 << endl;
#endif
				
				while(whitespace(c) && fi.get(c));
				
				cl.classes[buf2] = read_subclass(fi);
				
				while(fi.get(c) && whitespace(c));
			}
			
			// seems to be a parameter
			else
			{
				string buf2;
				
				while(c != '=' && fi.get(c));
				
				while (fi.get(c) && c != ';')
				{
					if (c == '"')
					{
						buf2 += '"' + read_quoted_string(fi) + '"';
					}
					else
						if (!whitespace(c))
							buf2 += c;
				};
				
				cl.values[buf] = buf2;

#ifdef DEBUG				
				cout << "~" << buf << "<-" << buf2 << endl;
#endif
			}
				
			
			
			if (!fi)
				throw string("Unexpected EOF (buf)") + buf;
			

			
		}
		
		return cl;
	}
	
	_class read_sqm_file(const wstring& fn)
	{
		win::File fi(fn.c_str());
		
		_class cl = read_subclass(fi);
		
		return cl;
	}
	
	////
	//
	// write-to-sqm part
	//
	////
	
	void write_tabs(win::File& fo, int tabs)
	{
		for (int i = 0; i < tabs; ++i)
			fo.write("\t");
	}
	
	
	void write_subclass(win::File& fo, const _class& cl, int tabs)
	{

		for (const auto& x : cl.values)
		{
			write_tabs(fo, tabs);
			fo.write(x.first + "=" + x.second + ";" + "\n");
		}

		for (const auto& x : cl.classes)
		{
			write_tabs(fo, tabs);
			fo.write("class " + x.first + "\n");
			
			write_tabs(fo, tabs);
			fo.write(string("{") + "\n");
			
			write_subclass(fo, x.second, tabs + 1);

			write_tabs(fo, tabs);
			fo.write(string("};") + "\n");
		}

	}
	
	
	
	void write_to_sqm_file(const std::wstring& fn, const _class& cl)
	{
		win::File fo(fn.c_str(), false);
		
		write_subclass(fo, cl, 0);
	};
	
	
}
