/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

/*
    SDL_collide:  A 2D collision detection library for use with SDL
    Copyright (C) 2005 Amir Taaki

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Library General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Library General Public License for more details.

    You should have received a copy of the GNU Library General Public
    License along with this library; if not, write to the Free
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Amir Taaki
    genjix@gmail.com

    Rob Loach
    http://robloach.net
*/

/* A simple library for collision detection using SDL */

#ifndef _SDL_COLLIDE_h
#define _SDL_COLLIDE_h

/*
    SDL surface test if offset (u,v) is a transparent pixel
*/
int SDL_CollideTransparentPixelTest(SDL_Surface *surface , int u , int v);

/*
    SDL pixel perfect collision test
*/
int SDL_CollidePixel(SDL_Surface *as , int ax , int ay ,
                     SDL_Surface *bs , int bx , int by);

/*
    SDL bounding box collision test
*/
int SDL_CollideBoundingBox(SDL_Surface *sa , int ax , int ay ,
                           SDL_Surface *sb , int bx , int by);

/*
    SDL bounding box collision tests (works on SDL_Rect's)
*/
int SDL_CollideBoundingBox(SDL_Rect &a , SDL_Rect &b);

/*
    tests whether 2 circles intersect

    circle1 : centre (x1,y1) with radius r1
    circle2 : centre (x2,y2) with radius r2

    (allow distance between circles of offset)
*/
int SDL_CollideBoundingCircle(int x1 , int y1 , int r1 ,
                              int x2 , int y2 , int r2 , int offset);

/*
    a circle intersection detection algorithm that will use
    the position of the centre of the surface as the centre of
    the circle and approximate the radius using the width and height
    of the surface (for example a rect of 4x6 would have r = 2.5).
*/
int SDL_CollideBoundingCircle(SDL_Surface *a , int x1 , int y1 ,
                              SDL_Surface *b , int x2 , int y2 ,
                              int offset);

#endif /* _SDL_COLLIDE_h */
