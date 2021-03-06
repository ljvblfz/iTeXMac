/*
//  iTeXMac
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Jan 06 2002.
//  Copyright © 2001 Laurens'Tribune. All rights reserved.
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
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/


#import <Cocoa/Cocoa.h>

extern NSString * const iTM2ToolbarMagnificationFieldItemIdentifier;
extern NSString * const iTM2ToolbarMagnificationSetItemIdentifier;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2RepToolbarDelegate

@interface iTM2RepToolbarDelegate: NSObject
{
@private
    NSString * __LastMagnificationITII;
    NSStepper * _MagStepper;
    NSTextField * _MagnificationField;
}
/*"Class methods"*/
/*"Setters and Getters"*/
- (NSTextField *)magnificationField;
- (void)setMagnificationField:(NSTextField *)aTextField;
- (NSStepper *)magStepper;
- (void)setMagStepper:(NSStepper *)aStepper;
- (void)setMagnification:(NSDecimalNumber *)aMagnification;
/*"Main methods"*/
- (NSView *)magnificationFieldForPalette;
- (NSView *)magnificationFieldForToolbar;
- (NSView *)magnificationSetForPalette;
- (NSView *)magnificationSetForToolbar;
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)aToolbar;
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)aToolbar;
- (NSToolbarItem *)toolbar:(NSToolbar *)aToolbar itemForItemIdentifier:(NSString *)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)aFlag;
/*"Overriden methods"*/
- (id)init;
@property (retain) NSString * __LastMagnificationITII;
@property (retain) NSStepper * _MagStepper;
@property (retain) NSTextField * _MagnificationField;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2RepToolbarDelegate
