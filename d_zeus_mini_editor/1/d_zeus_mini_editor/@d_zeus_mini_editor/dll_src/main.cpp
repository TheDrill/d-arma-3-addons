
//#include <fstream>
#include <sstream>
#include <string>
#include <map>
#include <cstdlib>
#include <vector>




#ifdef TEST_EXE_MODE
#include <iostream>
#endif


#include "sqm_to_map.h"
#include "win32_file_handling.h"

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
	
	catch (string s)
	{
		outputSize -= 1;
		strncpy(output, ("FAILED: " + s).c_str(), outputSize);
		
		return;
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




#ifdef TEST_EXE_MODE
int main()
{
	char buf[10240];
	string s;
	while (true)
	{
		cout << "Enter command: ";
		getline(cin, s);
		cout << endl;
		
		if (s == "") return 0;
		
		_RVExtension(buf, 10240, s.c_str());
		
		cout << "Response: " << buf << endl << endl;
	}	
	
	return 0;
};
#endif


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Evaluation of the commands taken from Arma




namespace app
{
	
	
	wstring current_mission_path;
	_class current_mission_map;
	bool inited_state = false;
	
	
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
			char c;
			ss.get(c);
			getline(ss, s);
			current_mission_path = win::get_my_documents_path() + L"\\" +
				win::convert_to_wide(s);
			current_mission_map = read_sqm_file(current_mission_path);
			
			inited_state = true;
		}
		///////
		else if (s == "END")
		{
			if (inited_state)
			{
				inited_state = false;
				
				write_to_sqm_file(current_mission_path, current_mission_map);
			}
			else
			{
				throw string("Need issue BEGIN command first");
			}
		}
		///////
		else if (s == "SET")
		{
			if (!inited_state) throw string("Need issue BEGIN command first");
			
			string id;
			ss >> id;
			
			_class& vehs = current_mission_map.classes["Mission"].classes["Vehicles"];
			
			_class* item_ptr = 0;
			
			
			if (id != "none")  for (auto& x : vehs.classes)
				if (x.second.values["text"] == id)
				{
					item_ptr = &x.second;
					break;
				}
				
			// have to create new vehicle
			if (!item_ptr)
			{
				// find id for new vehicle. Would need find max id 
				// among all vehicles and groups
				
				int max_oid = -1;
				
				for (auto& x : current_mission_map.classes["Mission"].classes["Groups"].classes)
					for (auto& y : x.second.classes["Vehicles"].classes)
						{
							int iid = str_to_int(y.second.values["id"]);
							if (max_oid < iid) max_oid = iid;
						}
						
				for (auto& x : vehs.classes)
					{
						int iid = str_to_int(x.second.values["id"]);
						if (max_oid < iid) max_oid = iid;
					}
					
				
				// need to generate new id if there's no one
				if (id == "none")
				{
					int max_id = 0;
					
					for (auto& x : vehs.classes)
					{
						// id is of form "__dzte_1"
						string itext = x.second.values["text"];
						
						if (itext.size() < 10)  continue;
						
						int cur_id = str_to_int(
							itext.substr(8, itext.size() - 9));
						if (cur_id > max_id)  max_id = cur_id;
					}
					
					stringstream tss;
					tss << '"' << "__dzte_" << max_id + 1 << '"';
					id = tss.str();
				}
				
				
				
				// adding new item
				int items = str_to_int(vehs.values["items"]);
				vehs.values["items"] = int_to_str(items + 1);
				
				stringstream ss0;
				ss0 << "Item" << items;
					
				_class cl;
				cl.values["id"] = int_to_str(max_oid + 1);
				cl.values["text"] = id;
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
		else if (s == "UNIMPORT_ALL")
		{
			_class& vehs = current_mission_map.classes["Mission"].classes["Vehicles"];
			
			// id is of form "__dzte_*"
			
			for (auto& x : vehs.classes)
				if (x.second.values["text"].substr(0, 8) == "\"__dzte_")
					x.second.values.erase("text");
		}
		///////
		else if (s == "IMPORT_ALL")
		{
			_class& vehs = current_mission_map.classes["Mission"].classes["Vehicles"];
			
			// id is of form "__dzte_*"
			int max_id = 0;
			
			for (auto& x : vehs.classes)
			{
				// id is of form "__dzte_1"
				string itext = x.second.values["text"];
				
				if (itext.size() < 10)  continue;
				
				int cur_id = str_to_int(
					itext.substr(8, itext.size() - 9));
				if (cur_id > max_id)  max_id = cur_id;
			}
			
			
			for (auto& x : vehs.classes)
				if (x.second.values["text"] == "" &&
					x.second.values["side"] == "\"EMPTY\"")
				{
					stringstream tss;
					tss << '"' << "__dzte_" << ++max_id << '"';
					x.second.values["text"] = tss.str();
				}
			
		}
		///////
		else if (s == "MAKE_ALL_PLAYABLE")
		{
			if (!inited_state) throw string("Need issue BEGIN command first");
			
			for (auto& x : current_mission_map.classes["Mission"].classes["Groups"].classes)
			{
				string side = x.second.values["side"];
				if (!(
					side == "\"WEST\"" ||
					side == "\"EAST\"" ||
					side == "\"GUER\"" ||
					side == "\"CIV\""					
				))  continue;
				
				for (auto& y : x.second.classes["Vehicles"].classes)
				{
					y.second.values["player"] = "\"PLAY CDG\"";
					y.second.values["special"] = "\"NONE\"";
				}
			}
		}
		///////
		else
		{
			throw string("Unknown command");
		}
				
	}
	
	
}
