#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

#include "crc.h"

int GetSubversionRevisionNumber ( const char *_fromFile );

int main ( int argc, char **argv )
{
	char currentPath[2048];
	char buildNumberPath[2048];
	char inputEntriesFile[2048];
	char fileBuffer[8192];
	char temp[256];

	if ( argc < 2 )
	{
		fprintf ( stderr, "Not enough parameters!\n" );
		return 1;
	}

	memset ( currentPath, 0, sizeof(currentPath) );

	for ( int i = 1; i < argc; i++ )
	{
		strcat ( currentPath, argv[i] );
		if ( i < argc - 1 )
			strcat ( currentPath, " " );
	}

	sprintf ( buildNumberPath, "%s/build_number.h", currentPath );
	sprintf ( inputEntriesFile, "%s/.svn/entries", currentPath );

	sprintf ( fileBuffer, "#ifndef __included_build_number_h\n" );

	sprintf ( temp, "#define __included_build_number_h\n" );
	strcat ( fileBuffer, temp );

	sprintf ( temp, "\n#define BUILD_NUMBER %d\n\n",
		GetSubversionRevisionNumber ( inputEntriesFile ) );
	strcat ( fileBuffer, temp );

	sprintf ( temp, "#endif\n" );
	strcat ( fileBuffer, temp );

	CRC crcTemp, crcFinal;
	crcTemp.Process ( fileBuffer, strlen(fileBuffer) );
	crcFinal.ProcessFile ( buildNumberPath );

	fprintf ( stderr, "File CRC: %08x, Data CRC: %08x\n", crcTemp.GetCRC(), crcFinal.GetCRC() );

	if ( crcTemp.GetCRC() != crcFinal.GetCRC() ) {
		FILE *outfile = fopen ( buildNumberPath, "w" );
		if ( !outfile )
		{
			fprintf ( stderr, "Output file '%s' couldn't be opened!\n", buildNumberPath );
			return 1;
		}
		fprintf ( outfile, "%s", fileBuffer );
		fclose ( outfile );
	} else {
		fprintf ( stderr, "build_number.h is already up to date.\n" );
	}

	return 0;
}

int GetSubversionRevisionNumber ( const char *_fromFile )
{
	string line;
	ifstream file;
	file.open ( _fromFile, ios::in );
	if ( file.is_open() )
	{
		getline ( file, line );
		getline ( file, line );
		getline ( file, line );
		getline ( file, line );
		file.close();
		int retval = atoi ( line.c_str() );
		return retval;
	} else {
		return 0;
	}
}
