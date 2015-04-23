#include "win32_file_handling.h"

#include <windows.h>
#include <Shlobj.h>

using namespace std;

namespace win
{
	
	
	
	void File::open(const std::wstring& fn, bool read)
	{
		file = CreateFileW(
			fn.c_str(), 
			read ? GENERIC_READ : GENERIC_WRITE,
			0,
			0,
			read ? OPEN_EXISTING : TRUNCATE_EXISTING,
			FILE_ATTRIBUTE_NORMAL,
			0 
		);
		
		if (file == INVALID_HANDLE_VALUE)  file = 0;
		
		has_peek_value = false;
		
		if (!file) throw string("Failed to open the file");
	}
	
	
	
	void File::close()
	{
		if (!file) return;
		
		CloseHandle(file);
		file = 0;		
	}
	
	
	
	File::operator bool()
	{
		return file && last_read_succeded;		
	}
	
	
	
	File& File::get(char& c)
	{
		if (!file) return *this;
		
		if (has_peek_value)
		{
			has_peek_value = false;
			c = peek_value;
			return *this;
		}
		
		
		char buf[1];
		
		last_read_succeded = ReadFile(
			file,
			buf,
			1,
			0, 
			0
		);
		
		c = buf[0];
		
		return *this;
	}
	
	
	
	char File::peek(char c)
	{
		if (!file) return 0;
		
		if (has_peek_value)  return peek_value;
		
		char buf[1];
		
		bool rfr = ReadFile(
			file,
			buf,
			1,
			0, 
			0
		);
		
		has_peek_value = true;
		peek_value = rfr ? buf[0] : 0;
		return peek_value;
	}
	
	
	
	void File::write(const string& s)
	{
		if (!file) return;
		
		WriteFile(
			file,
			s.c_str(),
			s.size(),
			0,
			0
		);
	}
	
	
	
	
	
	
	
	
	
	wstring get_my_documents_path()
	{
		/*
		PWSTR* str;
		
		HRESULT res = SHGetKnownFolderPathW(
			FOLDERID_Documents,
			0,
			0,
			str
		);*/
		
		wchar_t buf[MAX_PATH];
		
		HRESULT res = SHGetFolderPathW(
			0,
			CSIDL_PERSONAL,
			0,
			0,
			buf
		);
		
		if (res != S_OK) throw string("Failed to get path to the user documents");
		
		wstring resstr(buf);
		//CoTaskMemFree(str);
		
		return resstr;
	}
	
	
	
	wstring convert_to_wide(const string& si)
	{
		wchar_t* buf = new wchar_t[si.size() + 1];
		
		int rv = MultiByteToWideChar(
			CP_OEMCP,
			MB_PRECOMPOSED,
			si.c_str(),
			-1,
			buf,
			si.size() + 1
		);
		
		if (!rv) throw string("Failed to convert string to UTF16");
		
		wstring resstr(buf);
		delete[] buf;
		
		return resstr;
	}

	
}
