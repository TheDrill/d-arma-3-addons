@set PATH=%PATH%;D:\MinGW\bin

@g++ -static -DTEST_EXE_MODE --std=c++11 src/main.cpp src/sqm_to_map.cpp src/win32_file_handling.cpp -o d_zeus_mini_editor.exe || pause

