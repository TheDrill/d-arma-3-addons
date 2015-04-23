
#include "main.hpp"




FUNC(readConfigFile) =
{
	PV(_space) = (toArray " ") select 0;
	PV(_newline) = 10;
	
	PV(_file) = toArray (preprocessFile _this);
	_file set [count _file, _newline];
	
	PV(_rlines) = [];
	
	PV(_cur_line) = [];
	PV(_cur_el) = [];
	
	{
		PV(_unhandled) = true;
		
		if (_x == _newline) then
		{
			if (count _cur_el > 0) then
			{
				_cur_line set [count _cur_line, toString _cur_el];
			};
			_cur_el = [];
			
			if (count _cur_line > 0) then
			{
				_rlines set [count _rlines, _cur_line];
			};
			_cur_line = [];
			
			
			_unhandled = false;
		};
		
		
		if (_unhandled && _x == _space) then
		{
			if (count _cur_el > 0) then
			{
				_cur_line set [count _cur_line, toString _cur_el];
			};
			_cur_el = [];
			
			_unhandled = false;
		};
		
		
		if (_unhandled) then
		{
			_cur_el set [count _cur_el, _x];
			
			_unhandled = false;
		};
		
		
	} forEach _file;
	
	
	_rlines;	
};








FUNC(stringToNumber) =
{
	PV(_ra) = (toArray _this) - ((toArray _this) - (toArray "0123456789-."));
	
	if (count _ra > 0) then
	{
		[] call compile (toString _ra);
	}
	else
	{
		objNull;
	};
};
