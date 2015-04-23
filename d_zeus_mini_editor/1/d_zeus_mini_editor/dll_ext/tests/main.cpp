#include <iostream>
#include <string>
#include <fstream>

#include "win32_file_handling.h"

using namespace std;


int main()
{
	win::File fi(L"untitled");
	
	char c;
	
	for (int i = 0; i < 10; ++i)
	{
		fi.get(c);
		cout << c;
	}
	
	fi.close();
	
	fi.open(L"untitled", false);
	
//	fi.write((char*) win::get_my_documents_path().c_str());
	
	wofstream fo("test");
	fo << (win::get_my_documents_path() + win::convert_to_wide("/Arma 3"));
	
	
	return 0;
};
