/*
 *   CrissCross
 *   A multi-purpose cross-platform library.
 *
 *   A product of Uplink Laboratories.
 *
 *   (c) 2006-2009 Steven Noonan.
 *   Licensed under the New BSD License.
 *
 */

#include "universal_include.h"

#include "build_number.h"
#include "App/version.h"

namespace ARC
{
	namespace Version
	{
		const char *ShortVersion()
		{
			return ARC_VERSION_TAG;
		}

		const char *LongVersion()
		{
			return ARC_VERSION_LONG;
		}

		int Major()
		{
			return ARC_VERSION_MAJOR;
		}

		int Minor()
		{
			return ARC_VERSION_MINOR;
		}

		int Revision()
		{
			return ARC_VERSION_REVISION;
		}

		int Build()
		{
			return ARC_VERSION_BUILD;
		}
	}
}
