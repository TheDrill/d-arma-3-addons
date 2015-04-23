#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <map>
#include <cstdlib>

#include "sqm_to_map.h"

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
// Windows Header Files:
#include <windows.h>





using namespace std;

namespace app
{
	void eval_cmd(const string& s);
}





////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Entry point for Arma 

//
// Had to name the function as _RVExtension (instead of RVExtension).
// Otherwise the dll didn't work (compiled on MinGW).
//

extern "C"
{
  __declspec(dllexport) __stdcall void _RVExtension(char *output, int outputSize, const char *function); 
}
 
__stdcall void _RVExtension(char *output, int outputSize, const char *function)
{
	try
	{
		app::eval_cmd(function);
	}
	
	catch (...) 
	{
		outputSize -= 1;
		strncpy(output, "FAILED", outputSize);
		
		return;
	};
 
	outputSize -= 1;
	strncpy(output, "OK", outputSize);
}



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Evaluation of the commands taken from Arma




namespace app
{
	
	
	string current_mission_path;
	_class current_mission_map;
	
	
	
	int str_to_int(const string& s)
	{
		return atoi(s.c_str());
	};

	string int_to_str(int n)
	{
		stringstream ss;
		ss << n;
		return ss.str();
	};
	
	
	
	
	void eval_cmd(const string& cmds)
	{
		stringstream ss(cmds);
		
		string s;
		
		ss >> s;
		
		if (s == "BEGIN")
		{
			getline(ss, s);
			current_mission_path = s;
			current_mission_map = read_sqm_file("mission.sqm");
		}
		///////
		else if (s == "END")
		{
			write_to_sqm_file(current_mission_path + ".out", current_mission_map);
		}
		///////
		else if (s == "ADD")
		{
			string id;
			ss >> id;
			
			_class& vehs = current_mission_map.classes["Mission"].classes["Vehicles"];
			
			_class* item_ptr = 0;
			
			for (auto& x : vehs.classes)
				if (x.second.values["skill"] == id)
				{
					item_ptr = &x.second;
					break;
				}
				
			// have to create new vehicle
			if (!item_ptr)
			{
				// find id for new vehicle. Would need find max id 
				// among all vehicles and groups
				
				int max_id = -1;
				
				for (auto& x : current_mission_map.classes["Mission"].classes["Groups"].classes)
					for (auto& y : x.second.classes["Vehicles"].classes)
						{
							int iid = str_to_int(y.second.values["id"]);
							if (max_id < iid) max_id = iid;
						}
						
				for (auto& x : vehs.classes)
					{
						int iid = str_to_int(x.second.values["id"]);
						if (max_id < iid) max_id = iid;
					}
					
				
				
				
				// adding new item
				int items = str_to_int(vehs.values["items"]);
				vehs.values["items"] = int_to_str(items + 1);
				
				stringstream ss0;
				ss0 << "Item" << items;
					
				_class cl;
				cl.values["id"] = int_to_str(max_id + 1);
				cl.values["skill"] = id;
				cl.values["position[]"] = "{0,0,0}";
				cl.values["side"] = "\"EMPTY\"";
				
				vehs.classes[ss0.str()] = cl;
				item_ptr = &vehs.classes[ss0.str()];
			}
			
			
			
			// found needed item. Updating its attributes nwo
			_class& item = *item_ptr;
			
			string cmd;
			
			while (ss >> cmd)
			{
				if (cmd == "position[]")
				{
					string x, y, z;
					ss >> x >> y >> z;
					
					item.values["position[]"] = "{" + x + "," + y + "," + z + "}";
				}
				///////
				else if (cmd == "offsetY")
				{
					string x;
					ss >> x;
					
					if (x == "0")
						item.values.erase("offsetY");
					else
						item.values["offsetY"] = x;
				}
				///////
				else if (cmd == "azimut")
				{
					string x;
					ss >> x;
					
					if (x == "0")
						item.values.erase("azimut");
					else
						item.values["azimut"] = x;
				}
				///////
				else if (cmd == "vehicle")
				{
					string x;
					ss >> x;
					
					item.values["vehicle"] = x;
				}
			}
			
			
			
				
			
		}
		///////
		else if (s == "MAKE_ALL_PLAYABLE")
		{
			for (auto& x : current_mission_map.classes["Mission"].classes["Groups"].classes)
				for (auto& y : x.second.classes["Vehicles"].classes)
					y.second.values["player"] = "\"PLAY CDG\"";
		}
				
	}
	
	
}
