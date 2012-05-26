// sizeof_win32.cpp : Defines the entry point for the console application.
//

//#include "stdafx.h"
//
//
//int _tmain(int argc, _TCHAR* argv[])
//{
//	return 0;
//}

#include <ctime>
#include <iostream>
#include <iomanip>
#include <cmath>
#include <cstring>

void print(const char *type, int size)
{
	std::cout << "sizeof(" << type << "):" << std::setw(11 - strlen(type)) << ""
		<< std::setw(5) << size
		<< std::setw(9) << floor(log10(pow(2.,8*size)-1))+1 
		<< std::endl;
}

int main (int argc, char **argv)
{
	std::cout << std::setw(20) << "type" 
		<< std::setw(5) << "size" 
		<< std::setw(9) << "decimals"
		<< std::endl;
	print("char", sizeof(char));
	print("short", sizeof(short));
	print("int", sizeof(int));
	print("long", sizeof(long));
	print("long long", sizeof(long long));
	print("__int64", sizeof(__int64));
	std::cout << std::endl;
	print("float", sizeof(float));
	print("double", sizeof(double));
	print("long double", sizeof(long double));
	std::cout << std::endl;
	print("time_t", sizeof(time_t));

	long long llint = 123456789123456789;
	__int64 int64 = llint;

	std::cout << (llint == int64);

	char one[2];
	std::cin >> one;
}
