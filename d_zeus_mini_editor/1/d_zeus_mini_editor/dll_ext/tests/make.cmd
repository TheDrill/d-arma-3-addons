@set PATH=%PATH%;D:\MinGW\bin

@g++ -static --std=c++11 main.cpp win32_file_handling.cpp -o main.exe       || pause

