/*
//
//  @version Subversion: $Id: iTM2ApplicationDelegate.m 798 2009-10-12 19:32:06Z jlaurens $ 
//
//  Created by dirk on Tue Jan 23 2001.
//  Modified by jlaurens AT users DOT sourceforge DOT net on Tue Jun 26 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  original method by dirk Holmes
//  jlaurens AT users DOT sourceforge DOT net (07/12/2001):
//    -applicationCompleteWillFinishLaunching4iTM3: modified
//    -applicationOpenUntitledFile: added
//  To Do List: (format "- proposition(percentage actually done)")
*/

//
#import "iTM2NotificationKit.h"
#import "iTM2Invocation.h"
#include "iTM2BundleKit.h"
#include "iTM2Runtime.h"
#include "iTM2PathUtilities.h"
#import "iTM2DocumentControllerKit.h"
#import "iTM2ApplicationDelegate.h"

NSString * const iTM2MakeEmptyDocumentKey = @"iTM2MakeEmptyDocument";

/*" This class is registered as the delegate of the iTeXMac2 NSApplication object. We do various stuff here, e.g. registering factory defaults, etc.
"*/


@interface NSDocumentController(iTM2ApplicationDelegate)
- (id)prepareOpenDocumentWithContentsOfURL:(NSURL *)absoluteURL error:(NSError **)RORef;
@end
@implementation iTM2ApplicationDelegate
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initialize
+ (void)initialize;
/*"Registers some defaults: initialize iTM2DefaultsController.
Version History: jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	[super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithBool:NO], iTM2MakeEmptyDocumentKey,
                                nil]];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
#warning DEBUGGGGGGGGGG: NO APPLICATION DOCK MENU YET
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= applicationDockMenu:
- (NSMenu *)applicationDockMenu:(id)sender;
/*"Lazy initializer and message.
Proposed by jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- < 1.1: 03/10/2002
To Do List: Nothing at first glance
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return nil;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setApplicationDockMenu:
- (void)setApplicationDockMenu:(NSMenu *)argument;
/*"Description forthcoming.
Proposed by jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- < 1.1: 03/10/2002
To Do List: Nothing at first glance
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![_ADM isEqual:argument])
    {
        if (argument && ![argument isKindOfClass:[NSMenu class]])
            [NSException raise:NSInvalidArgumentException format:@"-[%@ %@] NSMenu argument expected:%@.",
                self.class, NSStringFromSelector(_cmd), argument];
        else
        {
            [_ADM release];
            _ADM = [argument retain];
        }
    }
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  DELEGATE METHODS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= applicationOpenUntitledFile:
- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication;
/*"Description forthcoming.
Proposed by jlaurens AT users DOT sourceforge DOT net (07/12/2001)
I really don't know why but this simple method could replace the previous one. Nevertheless, I prefer what I can understand...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return ![SUD boolForKey:iTM2MakeEmptyDocumentKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= application:openFile:
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename;
/*"Updates the templates and macros menus.
Proposed by jlaurens AT users DOT sourceforge DOT net (07/12/2001)
To Do: problem when there is no UI.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([SDC respondsToSelector:@selector(prepareOpenDocumentWithContentsOfURL:error:)]) {
        NSError * ROR = nil;
		[SDC prepareOpenDocumentWithContentsOfURL:[NSURL fileURLWithPath4iTM3:filename] error:self.RORef4iTM3];
        if (ROR) {
            [NSApp presentError:ROR];
        }
	}
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  applicationShouldTerminate:
- (NSApplicationTerminateReply)applicationShouldTerminate:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSApplicationTerminateReply reply;
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] applicationShouldTerminate:sender];
	NSPointerArray * PA = [iTM2Runtime realInstanceSelectorsOfClass:self.class withSuffix:@"ApplicationShouldTerminate:" signature:I.methodSignature inherited:YES];
	NSUInteger i = PA.count;
	while(i--)
	{
		[I setSelector:(SEL)[PA pointerAtIndex:i]];
        [I invoke];
		[I getReturnValue:&reply];
		if ((reply == NSTerminateCancel)
			||(reply == NSTerminateLater))
		{
			return reply;
		}
    }
//END4iTM3;
    return NSTerminateNow;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  applicationWillTerminate:
- (void)applicationWillTerminate:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] applicationWillTerminate:notification];
    [I invokeWithSelectors4iTM3:[iTM2Runtime realInstanceSelectorsOfClass:self.class withSuffix:@"ApplicationWillTerminate:" signature:I.methodSignature inherited:YES]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tempApplicationWillTerminate:
- (void)cleanTemporaryApplicationWillTerminate:(NSNotification *)theNotification;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Thu Jul 21 22:54:06 GMT 2005
 Latest Revision: Sat Jan 30 00:28:55 UTC 2010
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSURL * url = NSBundle.mainBundle.temporaryDirectoryURL4iTM3;
	LOG4iTM3(@"Clean the temporary directory at %@", url);
	if ([DFM removeItemAtPath:url.path error:NULL]) {
		LOG4iTM3(@"Done.");
	} else {
		LOG4iTM3(@"**** ERROR: FAILED");
	}
	//END4iTM3;
    return;
}
@synthesize _ADM;
@end

