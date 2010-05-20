/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
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
    Data::LList<char *> m_resourcePaths;

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
     *      \return The location where application resources are stored.
     */
    virtual const Data::LList<char*> *GetResourcePaths ();

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
