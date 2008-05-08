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

#ifndef __included_surface_h
#define __included_surface_h

class Surface
{
protected:
	Uint32 m_sizeXY;
	Uint32 m_nWays;
	Uint32 m_sqrtN;
	Uint32 m_pixelWH;
	Data::DArray<Uint32> m_sectionIDs;

	SDL_Rect *m_srcRects;
	SDL_Rect *m_destRects;

	virtual void FindLocalSurfaceRect ( SDL_Rect *_destRect, Uint32 &_surfaceID );
	virtual void CalculateDestinationRectangles ( SDL_Rect *destRects, const SDL_Rect *_destRect );
	virtual void CalculateRectangles ( SDL_Rect *sourceRects, SDL_Rect *destRects,
		                               const SDL_Rect *_sourceRect, const SDL_Rect *_destRect );

public:
	Surface                                      ( Uint16 _sizeX, Uint16 _sizeY, Uint16 _splitSections = 16 );
	virtual ~Surface                             ();
    virtual Uint32             GetPixel          ( int x, int y );
    virtual void               SetPixel          ( int x, int y, Uint32 _colour );
    virtual SDL_PixelFormat   *GetPixelFormat    ();
    virtual void               ReplaceColour     ( SDL_Rect *_destRect, Uint32 _findColour, Uint32 _replaceColour );
    virtual void               FillRect          ( SDL_Rect *_destRect, Uint32 _colour );
    virtual void               Blit              ( Uint32 _sourceSurfaceID, const SDL_Rect *_sourceRect, const SDL_Rect *_destRect );
	virtual void               Render            ( SDL_Rect *_sourceRect, Uint32 _destSurfaceID, SDL_Rect *_destRect ) const;
    virtual void               PrintStatistics   () const;
};

#endif
