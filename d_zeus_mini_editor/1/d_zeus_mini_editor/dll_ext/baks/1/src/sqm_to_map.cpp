//#include <iostream>
#include "sqm_to_map.h"

#include <fstream>
#include <iostream>


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
	
	string read_quoted_string(ifstream& fi)
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
	
	_class read_subclass(ifstream& fi)
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

//				cout << "~" << "cl:" << buf2 << endl;
				
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
				
//				cout << "~" << buf << "<-" << buf2 << endl;
			}
				
			
			
			if (!fi)
				throw string("Unexpected EOF (buf)") + buf;
			

			
		}
		
		return cl;
	}
	
	_class read_sqm_file(const string& fn)
	{
		ifstream fi(fn.c_str());
		
		try
		{
			return read_subclass(fi);
		}
		
		catch(const string& s)
		{
			cerr << "Exception occured: " << s.c_str() << endl;
			
			return _class();
		}
	}
	
	////
	//
	// write-to-sqm part
	//
	////
	
	void write_tabs(ofstream& fo, int tabs)
	{
		for (int i = 0; i < tabs; ++i)
			fo << "\t";
	}
	
	
	void write_subclass(ofstream& fo, const _class& cl, int tabs)
	{

		for (const auto& x : cl.values)
		{
			write_tabs(fo, tabs);
			fo << x.first << "=" << x.second << ";" << endl;
		}

		for (const auto& x : cl.classes)
		{
			write_tabs(fo, tabs);
			fo << "class " << x.first << endl;
			
			write_tabs(fo, tabs);
			fo << "{" << endl;
			
			write_subclass(fo, x.second, tabs + 1);

			write_tabs(fo, tabs);
			fo << "};" << endl;
		}

	}
	
	
	
	void write_to_sqm_file(const std::string& fn, const _class& cl)
	{
		ofstream fo(fn.c_str());
		
		write_subclass(fo, cl, 0);
	};
	
	
}
