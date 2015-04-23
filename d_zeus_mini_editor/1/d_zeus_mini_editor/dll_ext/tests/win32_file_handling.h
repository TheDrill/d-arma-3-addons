#ifndef __WIN32_FILE_HANDLING_H__
#define __WIN32_FILE_HANDLING_H__

#include <string>
#include <windows.h>

namespace win
{
	class File
	{
	private:
		HANDLE file = 0;
		bool last_read_succeded = true;
		
		bool has_peek_value = false;
		char peek_value;
	public:
	
		File(const std::wstring& fn, bool read = true) {open(fn, read);};
		~File() {close();};
		
		operator bool();
		
		File& get(char& c);
		char peek(char c);
		
		void write(const std::string& s);
		
		void close();
		void open(const std::wstring& fn, bool read = true);
			
		
	};
	
	
	
	std::wstring get_my_documents_path();
	
	std::wstring convert_to_wide(const std::string& si);
};


#endif 
