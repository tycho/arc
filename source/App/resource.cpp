/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#if defined ( TARGET_COMPILER_VC ) || defined ( TARGET_COMPILER_ICC )
#   pragma comment (lib, "unrar.lib")
#endif

#include "App/app.h"
#include "App/file_utils.h"
#include "App/resource.h"

#ifndef TARGET_OS_WINDOWS
inline static void strlwr ( char *_string )
{
    for ( char *p = _string; p && *p != '\0'; p++ )
        *p = tolower(*p);
}
#endif

Resource::Resource()
{
}

Resource::~Resource()
{
    Data::DArray<MemMappedFile *> *files = m_resourceFiles.ConvertToDArray();
    for ( size_t i = 0; i < files->size(); i++ )
    {
        if ( !files->valid ( i ) ) continue;
        delete files->get ( i );
    }
    delete files;
}

void Resource::ParseArchive ( const char *_dataFile, const char *_password )
{
    if (!FileExists( _dataFile))
        return;

    UncompressedArchive    *mainData = NULL;

    try
    {
        mainData = new UncompressedArchive(_dataFile, _password);
    }
    catch( ... )
    {
        return;
    }

    for (size_t i = 0; i < mainData->m_numFiles; ++i)
    {
        MemMappedFile *file = mainData->m_files[i];
        if (file->m_size > 0)
        {
            strlwr(file->m_filename);
            
            // Subsequent archives may override existing resources
            
            MemMappedFile *oldFile = m_resourceFiles.find(file->m_filename, NULL);
            if (oldFile) {
                m_resourceFiles.erase(file->m_filename);
                delete oldFile;
            }
            
            m_resourceFiles.insert(file->m_filename, file);
        }
    }

    delete mainData;
}

BinaryReader *Resource::GetBinaryReader ( char const *_filename )
{
    BinaryReader *reader = NULL;
    char fullFilename[256];

    // TODO: Implement moddability and themes, etc.
#if 0
    if ( m_modName )
    {
        sprintf( fullFilename, "%smods/%s/%s", g_app->GetProfileDirectory(), m_modName, _filename );
        if ( FileExists ( fullFilename) ) reader = new BinaryFileReader(fullFilename);
    }
#endif

    if ( !reader )
    {
        sprintf( fullFilename, "%s%s", g_app->GetApplicationSupportPath(), _filename );
        if ( FileExists ( fullFilename) ) reader = new BinaryFileReader(fullFilename);
    }

    if ( !reader )
    {
        if ( FileExists ( _filename ) ) reader = new BinaryFileReader(_filename);
    }

    if ( !reader )
    {
        MemMappedFile *mmfile = GetUncompressedFile(_filename);
        if (mmfile) reader = new BinaryDataReader(mmfile->m_data, mmfile->m_size, _filename);        
    }

    return reader;
}

SDL_Surface *Resource::GetImage ( char const *_filename )
{
    char buffer[2048];
    MemMappedFile *memmap = NULL;
    SDL_Surface *surf = NULL;

    if ( !surf )
    {
        sprintf ( buffer, "%s%s", g_app->GetResourcePath(), _filename );
        surf = IMG_Load ( buffer );
    }

    memmap = GetUncompressedFile ( _filename );
    if ( !surf && memmap )
    {
        SDL_RWops *data = SDL_RWFromMem ( memmap->m_data, memmap->m_size );
        surf = IMG_Load_RW ( data, 0 );
        ARCReleaseAssert ( surf );
    }

    return surf;
}

#ifdef USE_SDLMIXER
Mix_Chunk *Resource::GetSound ( char const *_filename )
{
    char buffer[2048];
    MemMappedFile *memmap = NULL;
    Mix_Chunk *chunk = NULL;

    if ( !chunk )
    {
        sprintf ( buffer, "%s%s", g_app->GetResourcePath(), _filename );
        chunk = Mix_LoadWAV ( buffer );
    }

    memmap = GetUncompressedFile ( _filename );
    if ( !chunk && memmap )
    {
        SDL_RWops *data = SDL_RWFromMem ( memmap->m_data, memmap->m_size );
        chunk = Mix_LoadWAV_RW ( data, 0 );
    }

    return chunk;
}
#endif

TextReader *Resource::GetTextReader(char const *_filename)
{
    TextReader *reader = NULL;
    char fullFilename[256];

    fullFilename[0] = 0;

#if 0
    if( m_modName )
    {
        sprintf( fullFilename, "%smods/%s/%s", g_app->GetProfileDirectory(), m_modName, _filename );
        if( DoesFileExist(fullFilename) ) 
            reader = new TextFileReader(fullFilename);

#ifdef TARGET_OS_VISTA
        // The Oberon build bundles the Perdition mod
        if( !reader )
        {
            sprintf( fullFilename, "mods/%s/%s", m_modName, _filename );
            if( DoesFileExist(fullFilename) ) 
                reader = new TextFileReader(fullFilename);
        }
#endif
    }
#endif

    if( !reader )
    {
        sprintf( fullFilename, "data/%s", _filename );
        if ( FileExists ( fullFilename ) ) 
            reader = new TextFileReader(fullFilename);        
    }

    if( !reader )
    {
        sprintf( fullFilename, "data/%s", _filename );
        MemMappedFile *mmfile = GetUncompressedFile(fullFilename);
        if ( mmfile ) 
            reader = new TextDataReader((char*)mmfile->m_data, mmfile->m_size, fullFilename);        
    }

    return reader;
}

MemMappedFile *Resource::GetUncompressedFile(char const *_filename)
{
	char           fullFilename[2048];

	MemMappedFile *file = NULL;

	if (!file) {
		sprintf(fullFilename, "%s%s", g_app->GetApplicationSupportPath(), _filename);
		if (FileExists(fullFilename)) {
			IO::FileReader *fr = new IO::FileReader();
			fr->Open(fullFilename);
			size_t          len = fr->Length();

			file = new MemMappedFile(fullFilename, len);
			fr->Read((char *)file->m_data, len, 0, len);
			fr->Close();
			delete fr;
		}
	}

	if (!file) {
		file = m_resourceFiles.find(_filename, NULL);
	}

	return file;
}
