/*
//  iTM2AppleScriptSupport.h
//  iTeXMac2
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A pARTICULAR pURPOSE.
//  See the GNU General public License for more details. You should have received a copy
//  of the GNU General public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

// all headers are private

@interface NSApplication(iTM2AppleScriptSupport)

- (NSArray *) projects;// get the project documents of application "iTeXMac2"
- (void) insertInProjects: (id) argument;// make new project document

@end

@interface iTM2TeXProjectDocument(iTM2AppleScriptSupport)

- (NSArray *) projectDocumentsArray;// make new project document
- (void) insertInSubdocumentsArray: (id) argument;// make new document
- (NSArray *) TeXDocumentsArray;// make new project document
- (NSArray *) PDFDocumentsArray;// make new project document

@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2AppleScriptSupport
