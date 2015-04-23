#ifndef __SQM_TO_MAP_H__
#define __SQM_TO_MAP_H__

#include <map>
#include <string>


namespace app
{
	struct _class
	{
		std::map<std::string, std::string> values;
		std::map<std::string, _class> classes;
	};


	_class read_sqm_file(const std::wstring& fn);
	
	void write_to_sqm_file(const std::wstring& fn, const _class& cl);

	
}




#endif
