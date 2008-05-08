#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <iostream>
#include <fstream>
#include <string>

#ifdef _MSC_VER
# define CYGWIN_PATH "c:\\cygwin\\bin\\"
# define GIT_PATH "git.exe"
# define WC_PATH "wc.exe"
#elif defined __MACH__
# define CYGWIN_PATH ""
# define GIT_PATH "/opt/local/bin/git"
# define WC_PATH  "/usr/bin/wc"
#else
# define CYGWIN_PATH ""
# define GIT_PATH "/usr/bin/git"
# define WC_PATH  "/usr/bin/wc"
#endif

using namespace std;

#include "crc.h"

int GetGitRevisionNumber ( const char *_rootPath );

int main ( int argc, char **argv )
{
	char currentPath[2048];
	char buildNumberPath[2048];
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

	sprintf ( fileBuffer, "#ifndef __included_build_number_h\n" );

	sprintf ( temp, "#define __included_build_number_h\n" );
	strcat ( fileBuffer, temp );

	sprintf ( temp, "\n#define BUILD_NUMBER %d\n\n",
		GetGitRevisionNumber ( currentPath ) );
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

int GetGitRevisionNumber ( const char *_rootPath )
{
	char command[2048];
	sprintf ( command, "%s rev-list --all | %s -l > .rev-temp",
		CYGWIN_PATH GIT_PATH, CYGWIN_PATH WC_PATH );
	int ret = system ( command );
	if ( ret != 0 )
	{
		printf ( "Command didn't work.\n" );
		return 0;
	}
	FILE *rev = fopen ( ".rev-temp", "r" );
	if ( !rev )
	{
		printf ( "Output didn't show up as expected.\n" );
		return 0;
	}
	char buffer[64];
	fgets ( buffer, 63, rev );
	fclose ( rev );
	remove ( ".rev-temp" );
	return atoi(buffer);
}
