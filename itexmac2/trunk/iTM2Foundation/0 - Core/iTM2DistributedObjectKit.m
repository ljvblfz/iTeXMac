/*
//  iTM2DistributedObjectKit.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Jun 12 19:38:42 GMT 2006.
//  Copyright ©  2001 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution (contributor) ")  
//  To Do List: (format "- proposition (percentage actually done) ") 
*/

#import "iTM2DistributedObjectKit.h"

@implementation NSConnection(iTM2DistributedObjectKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTeXMac2ConnectionIdentifier
+ (NSString *) iTeXMac2ConnectionIdentifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSString * identifier = nil;
	if(identifer)
	{
//iTM2_END;
		return identifier;
	}
	identifier = [[NSBundle uniqueApplicationIdentifier] copy];
//iTM2_END;
	return identifier;
}
@end

@implementation iTM2MainInstaller(iTM2DistributedObjectKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DistributedObjectKit_CompleteInstallation
+ (void) iTM2DistributedObjectKit_CompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSConnection *theConnection;
	id root = [NSMutableDictionary dictionary];
	[root setObject:[NSApplication sharedApplication] forKey:@"NSApp"];
	[root setObject:[NSApplication sharedApplication] forKey:@"NSClassServer"];
	theConnection = [NSConnection defaultConnection];
	[theConnection setRootObject:root];
	NSString * identifier = [NSConnection iTeXMac2ConnectionIdentifier];
	if([theConnection registerName:identifier])
	{
		iTM2_LOG(@"The DO connection is available with identifier: <%@>", [NSBundle uniqueApplicationIdentifier]);
	}
	else
	{
		iTM2_LOG(@"****  ERROR: The DO connection is NOT available... iTeXMac2 won't work as expected.");
	}
//iTM2_END;
}
@end
