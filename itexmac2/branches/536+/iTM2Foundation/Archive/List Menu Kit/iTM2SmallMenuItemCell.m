/*
//  iTM2SmallMenuItemCell.m
//  List Menu Server
//
//  Created by jlaurens@users.sourceforge.net on Wed Apr 04 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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
*/

#import <iTM2Foundation/iTM2SmallMenuItemCell.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2SmallMenuItemCell
/*"Description forthcoming."*/
@implementation iTM2SmallMenuItemCell
- (NSSize) cellSize;
/*"Description forthcoming."*/
{
    NSSize size = [super cellSize];
//    size.height-=([[self font] pointSize]-[NSFont systemFontSize])/([NSFont smallSystemFontSize]-[NSFont systemFontSize]);
    size.height-=1;
    return size;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2SmallMenuItemCell
