/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_resource_h
#define __included_resource_h

#include "unrar.h"

#include "App/binary_stream_readers.h"
#include "App/text_stream_readers.h"

class Resource
{
private:
    Data::RedBlackTree<const char *, MemMappedFile *>    m_resourceFiles;

public:
    Resource();
    ~Resource();

    void             ParseArchive             ( char const *_dataFile, char const *_password);
    BinaryReader    *GetBinaryReader          ( char const *_filename );
    SDL_Surface     *GetImage                 ( char const *_filename );
#ifdef USE_SDLMIXER
    Mix_Chunk       *GetSound                 ( char const *_filename );
#endif
    TextReader      *GetTextReader            ( char const *_filename );
    MemMappedFile   *GetUncompressedFile      ( char const *_filename );
};

#endif
