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

#ifndef __app_h_included
#define __app_h_included

#include "App/resource.h"

//! The application class.
/*!
	The App class handles some of the basic things needed to run
	an application cross-platform, especially in relation to file
	and resource management.
 */
class App {

protected:
    char *m_appPath;
    char *m_appSupportPath;
    char *m_resourcePath;

public:
    Resource                      *m_resource;

public:
    App ();
    virtual ~App();

	//! Create a directory at the specified path.
	/*!
		Non-recursively creates a directory.
		\param _path The path of the directory to create.
	 */
    virtual void                   CreateDirectory ( const char *_path );

	//! Gets the application's resource directory.
	/*!
		\return The location where application resources are stored.
	 */
    virtual const char            *GetResourcePath ();

	//! Gets the application executable's directory.
	/*!
		\return The location where the application's executable is.
	 */
    virtual const char            *GetApplicationPath ();

	//! Gets the application support directory.
	/*!
		\return The location where any new application resources should be stored.
	 */
    virtual const char            *GetApplicationSupportPath ();

};

extern App *g_app;

#endif
