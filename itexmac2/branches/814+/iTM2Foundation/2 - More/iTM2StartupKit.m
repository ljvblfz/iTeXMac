/*
//
//  @version Subversion: $Id$ 
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
//    -applicationWillFinishLaunching: modified
//    -applicationOpenUntitledFile: added
//  To Do List: (format "- proposition(percentage actually done)")
*/

//
#import "iTM2StartupKit.h"
#import "iTM2Implementation.h"

NSString * const iTM2DontShowTipsKey = @"iTM2DontShowTips";

@implementation NSApplication(iTM2StartupKit) 
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showReleaseNotes:
+ (IBAction)showReleaseNotes:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showWelcomeNotes:
+ (IBAction)showWelcomeNotes:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
@end

@implementation iTM2StartupController
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
                    [NSNumber numberWithBool:YES], iTM2DontShowTipsKey,
                                nil]];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showReleaseNotes:
- (IBAction)showReleaseNotes:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * name = @"Release Notes";
    NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"rtf"];
    NSAttributedString * AS = path.length>ZER0? [[[NSAttributedString alloc]
        initWithPath: path documentAttributes: nil]
            autorelease]: nil;
    if (!AS)
        NSLog(@"No news at %@", name);
    NSTextView * TV = [self infoTextView];
    NSString * S = [TV string];
    NSInteger L = S.length;
    NSRange R = iTM3MakeRange(ZER0, L);
    [TV setSelectedRange:R];
    [TV insertText:(AS.length>ZER0? (NSString *)AS:@"No news today, my heart has gone away...")];
    [TV scrollRangeToVisible:iTM3MakeRange(ZER0, ZER0)];
    [TV setEditable:NO];
    if ([TV respondsToSelector:@selector(isWindowContentValid4iTM3)])
        [TV performSelector:@selector(isWindowContentValid4iTM3)];
    [self.window orderFront:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showWelcomeNotes:
- (IBAction)showWelcomeNotes:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * name = @"Welcome";
    NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"rtf"];
    NSAttributedString * AS = path.length>ZER0? [[[NSAttributedString alloc]
        initWithPath: path documentAttributes: nil]
            autorelease]: nil;
    if (!AS)
        NSLog(@"No welcome at %@", name);
    NSTextView * TV = [self infoTextView];
    NSString * S = [TV string];
    NSInteger L = S.length;
    NSRange R = iTM3MakeRange(ZER0, L);
    [TV setSelectedRange:R];
    [TV insertText:(AS.length>ZER0? (NSString *)AS:@"You are not welcome today, this is unexpected result...")];
    [TV scrollRangeToVisible:iTM3MakeRange(ZER0, ZER0)];
    [TV setEditable:NO];
    if ([TV respondsToSelector:@selector(isWindowContentValid4iTM3)])
        [TV performSelector:@selector(isWindowContentValid4iTM3)];
    [self.window orderFront:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  firstPanelOK:
- (IBAction)firstPanelOK:(id)sender
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    #warning DEBUG Not HERE???
    [self.window close];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDontShowTips:
- (IBAction)toggleDontShowTips:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SUD setBool:([sender state] == NSOnState) forKey:iTM2DontShowTipsKey];
    if ([sender respondsToSelector:@selector(isWindowContentValid4iTM3)])
        [sender performSelector:@selector(isWindowContentValid4iTM3)];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDontShowTips:
- (BOOL)validateToggleDontShowTips:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = [SUD boolForKey:iTM2DontShowTipsKey]? NSOnState:NSOffState;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= infoTextView
- (id)infoTextView;
/*"Description forthcoming.
Proposed by jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- < 1.1: 03/10/2002
To Do List: Nothing at first glance
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!iVarInfoTextView4iTM3) {
        [self window];
		if (!iVarInfoTextView4iTM3) {
			LOG4iTM3(@"Problem with nib file: iTM2FirstPanel");
		}
    }
    return iVarInfoTextView4iTM3;
}
@synthesize infoTextView = iVarInfoTextView4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowWillLoad
- (void)windowWillLoad;
/*"Description forthcoming.
Proposed by jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 1.2: 03/10/2002
To Do List: Nothing at first glance
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super windowWillLoad];
    [self setShouldCascadeWindows:NO];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Proposed by jlaurens AT users DOT sourceforge DOT net (07/12/2001)
- 1.2: 03/10/2002
To Do List: Nothing at first glance
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.window setFrameAutosaveName:@"iTM2FirstPanel"];
//NSLog(@"aWC.window:%@", aWC.window);
	[super windowDidLoad];
    return;
}
@end
