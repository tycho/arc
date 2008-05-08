/*
 *                           ARC++
 *
 *    Copyright (c) 2007-2008 Steven Noonan. All rights reserved.
 *
 *    NO PART OF THIS PROGRAM OR PUBLICATION MAY BE REPRODUCED,
 *    TRANSMITTED, TRANSCRIBED, STORED IN A RETRIEVAL SYSTEM, OR
 *    TRANSLATED INTO ANY LANGUAGE OR COMPUTER LANGUAGE IN ANY
 *    FORM OR BY ANY MEANS, ELECTRONIC, MECHANICAL, MAGNETIC,
 *    OPTICAL, CHEMICAL, MANUAL, OR OTHERWISE, WITHOUT THE PRIOR
 *    WRITTEN PERMISSION OF:
 *
 *                       STEVEN NOONAN
 *                       4727 BLUFF DR.
 *                 MOSES LAKE, WA 98837-9075
 *
 *    THIS SOURCE CODE IS NOT FOR PUBLIC INSPECTION.
 *    The above copyright notice does not indicate any
 *    actual or intended publication of this source code.
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
    Mix_Chunk       *GetSound                 ( char const *_filename );
    TextReader      *GetTextReader            ( char const *_filename );
    MemMappedFile   *GetUncompressedFile      ( char const *_filename );
};

#endif
