/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

#import "iTM2TeXDocumentKit.h"
#import "iTM2TeXStringKit.h"
#import "iTM2TeXProjectDocumentKit.h"
#import "iTM2TeXProjectFrontendKit.h"
#import "iTM2TeXProjectTaskKit.h"
#import <iTM3Foundation/iTM2InstallationKit.h>
#import <iTM3Foundation/iTM2Implementation.h>
#import <iTM3Foundation/iTM2ContextKit.h>
#import <iTM3Foundation/iTM2StringFormatKit.h>
#import <iTM3Foundation/iTM2WindowKit.h>
#import <iTM3Foundation/iTM2StringKit.h>
#import <iTM3Foundation/iTM2TextKit.h>
#import <iTM3Foundation/iTM2NotificationKit.h>
#import <iTM3Foundation/iTM2BundleKit.h>
#import <iTM3Foundation/iTM2KeyBindingsKit.h>

#define TABLE @"iTM2TextKit"
#define BUNDLE [iTM2TextDocument classBundle4iTM3]

NSString * const iTM2TeXDocumentType = @"TeX Document";// beware, this MUST appear in the target file...
NSString * const iTM2TeXInspectorMode = @"TeX Mode";

@implementation iTM2TeXDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super initialize];
	NSDictionary * D = [SUD dictionaryForKey:iTM2SUDInspectorVariants];
	NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:D];
	NSString * type = iTM2TeXDocumentType;
	if(![MD objectForKey:type])
	{
		NSString * mode = [iTM2TeXInspector inspectorMode];
		NSString * variant = [iTM2TeXInspector inspectorVariant];
		D = [NSDictionary dictionaryWithObjectsAndKeys:mode, @"mode", variant, @"variant", nil];
		[MD setObject:D forKey:type];
		[SUD setObject:MD forKey:iTM2SUDInspectorVariants];
	}
	D = [NSDictionary dictionaryWithObjectsAndKeys:@"TeX-Xtd", @"iTM2TextStyle", @"default", @"iTM2TextSyntaxParserVariant", nil];
	[SUD registerDefaults:D];
    return;
}
@end


@implementation iTM2TeXInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TeXInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroCategory
- (NSString *)defaultMacroCategory;
{
    return @"TeX";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroContext
- (NSString *)defaultMacroContext;
{
    return @"";
}
@end

@implementation iTM2TeXWindow
@end

#import <iTM2TeXFoundation/iTM2TeXStorageKit.h>

@implementation NSTextView(TeX)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  proposedRangeForTeXUserCompletion:
- (NSRange)proposedRangeForTeXUserCompletion:(NSRange)range;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(range.location)
	{
		NSString * S = self.string;
		unichar theChar = [S characterAtIndex:range.location-1];
		if(theChar == '\\')
		{
			--range.location;
			++range.length;
		}
	}
//END4iTM3;
	return range;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertUnderscore:
- (void)insertUnderscore:(id)sender;
/*"Tabs are inserted only at the beginning of the line.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
	[self insertText:@"_"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertHat:
- (void)insertHat:(id)sender;
/*"Inserting a smart hat. Problem with dead keys.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
	[self insertText:@"^"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertControl:
- (void)insertControl:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
	[self insertText:@"\\"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertDollar:
- (void)insertDollar:(id)sender;
/*"Tabs are inserted only at the beginning of the line.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
	[self insertText:@"$"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLeftCurlyBracket:
- (void)insertLeftCurlyBracket:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
	[self insertText:@"{"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLeftParenthesis:
- (void)insertLeftParenthesis:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
	[self insertText:@"("];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLeftBracket:
- (void)insertLeftBracket:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
	[self insertText:@"["];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertTabAnchor:
- (void)insertTabAnchor:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self insertText:[self.stringController4iTM3 tabAnchor]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  concreteReplacementStringForTeXMacro4iTM3:selection:line:
- (NSString *)concreteReplacementStringForTeXMacro4iTM3:(NSString *)macro selection:(NSString *)selectedString line:(NSString *)line;
/*"Description forthcoming. Will be completely overriden by subclassers.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// what is the policy of the replacement?
	// first split the whole string into tokens
	NSArray * components = [macro componentsSeparatedByString:@"{}"];
	NSString * s;
	BOOL escaped;
	if(components.count == 2)
	{
		s = [components objectAtIndex:ZER0];
		if(!s.length || ![s isControlAtIndex:s.length-1 escaped:&escaped] || escaped)
		{
			s = [NSString stringWithFormat:@"{__(%@)__}",selectedString];
			macro = [components componentsJoinedByString:s];
		}
	}
	else
	{
		components = [macro componentsSeparatedByString:@"[]"];
        s = [components objectAtIndex:ZER0];
		if((components.count == 2) && (!s.length || ![s isControlAtIndex:s.length-1 escaped:&escaped] || escaped))
		{
			s = [NSString stringWithFormat:@"[__(%@)__]",selectedString];
			macro = [components componentsJoinedByString:s];
		}
	}
	macro = (id)[self concreteReplacementStringForMacro4iTM3:macro selection:selectedString line:line];
//END4iTM3;
   return macro;
}
@end

NSString * const iTM2TeX7bitsAccentsKey = @"iTM2TeX7bitsAccents";

@interface iTM2KeyBindingsManager(TeX)
+ (id)the7bitsAccentsList;
+ (id)the7bitsAccentsMapping;
+ (id)the7bitsAccentsGnippam;
@end

@implementation iTM2TeXEditor
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollInputToVisible:
- (void)scrollInputToVisible:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self performSelector:@selector(delayedScrollInputToVisible:) withObject:sender afterDelay:0.1];
	#if 0
    [NSInvocation delayInvocationWithTarget: self
        action: @selector(_ScrollInputToVisible:)
            sender: sender
                untilNotificationWithName: @"iTM2TDPerformScrollIn[clude|put]ToVisible"
                    isPostedFromObject: self];
	#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delayedScrollInputToVisible:
- (void)delayedScrollInputToVisible:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List: include the tetex path...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * path = [sender.menu.title stringByAppendingPathComponent:
                                sender.representedObject].stringByResolvingSymlinksInPath.stringByStandardizingPath;
    if([DFM isReadableFileAtPath:path])
        [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES error:nil];
    else
    {
        NSString * P = [path stringByAppendingPathExtension:@"tex"];
        if([DFM isReadableFileAtPath:P])
            [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:P] display:YES error:nil];
        else
        {
            [sender setEnabled:NO];
            NSBeep();
            [self postNotificationWithStatus4iTM3:
                [NSString stringWithFormat:  NSLocalizedStringFromTableInBundle(@"No file at path: %@", @"TeX",
                            [NSBundle bundleForClass:self.class], "Could not complete the \\input action... 1 line only"), path]]; 
        }
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseDown:
- (void)mouseDown:(NSEvent * )event
/*"Description Forthcoming
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    if((event.clickCount>2) && ![iTM2EventObserver isAlternateKeyDown])
    {
//NSLog(@"event.clickCount: %i", event.clickCount);
        NSString * S = self.string;
        NSRange SR = self.selectedRange;
//        NSRange GR = [S groupRangeForRange:SR];
		// comparer SR, GR, PR
//NSLog(NSStringFromRange(GR));
        NSUInteger start, end;
        [S getLineStart: &start end: &end contentsEnd:nil forRange:SR];
        end -= start;
        NSRange PR = (end>SR.length)? iTM3MakeRange(start, end): iTM3MakeRange(ZER0, S.length);
        [self setSelectedRange:PR];
		return;
    }
    else
        [super mouseDown:event];
    return;
}
#if 0
- (void)moveWordForwardAndModifySelection:(id)sender;
- (void)moveWordBackwardAndModifySelection:(id)sender;
- (void)moveWordRightAndModifySelection:(id)sender;
- (void)moveWordLeftAndModifySelection:(id)sender;
- (void)moveUpAndModifySelection:(id)sender;
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  subscript:
- (void)subscript:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
	[self executeMacroWithID4iTM3:@"_{}"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  superscript:
- (void)superscript:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
	[self executeMacroWithID4iTM3:@"^{}"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertUnderscore:
- (void)insertUnderscore:(id)sender;
/*"Tabs are inserted only at the beginning of the line.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
    if(!_iTMTVFlags.smartInsert || _iTMTVFlags.isEscaped || _iTMTVFlags.isDeepEscaped)
    {
        [self insertText:@"_"];
    }
    else
    {
        BOOL escaped;
        NSRange R = self.selectedRange;
        if(!R.location || ![self.string isControlAtIndex:R.location-1 escaped: &escaped] || escaped)
            [self subscript:self];
        else
            [self insertText:@"_"];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertHat:
- (void)insertHat:(id)sender;
/*"Inserting a smart hat. Problem with dead keys.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
//NSLog(NSStringFromRange(self.selectedRange));
//NSLog(NSStringFromRange(self.markedRange));
    if(!_iTMTVFlags.smartInsert || _iTMTVFlags.isEscaped || _iTMTVFlags.isDeepEscaped)
    {
        [self insertText:@"^"];
    }
    else
    {
        BOOL escaped;
        NSInteger index = self.hasMarkedText? self.markedRange.location:self.selectedRange.location;
        if(!index || ![self.string isControlAtIndex:index-1 escaped: &escaped] || !escaped)
        {
            index = self.selectedRange.location;
            if(!index || ([self.string characterAtIndex:index-1] != '^'))
				[self superscript:self];
            else
			{
				[self executeMacroWithID4iTM3:@"{}"];
			}
        }
        else
        {
            [self insertText:@"^"];
        }
    }
#warning WARNING----------------------------------------
//    self.completeInsertion;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertControl:
- (void)insertControl:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
    BOOL escaped;
    NSString * S = self.string;
    NSRange R = self.selectedRange;
    if(!R.location || ![S isControlAtIndex:R.location-1 escaped: &escaped] || escaped)
    {
        [self insertText:[NSString backslashString]];
    }
    else
    {
        [self.undoManager beginUndoGrouping];
        [self insertText:[NSString backslashString]];
        [self insertNewline:self];
        [self.undoManager endUndoGrouping];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertDollar:
- (void)insertDollar:(id)sender;
/*"Tabs are inserted only at the beginning of the line.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
    BOOL escaped;
    NSRange R = self.selectedRange;
	NSString * myString = self.string;
    if(!R.location || ![myString isControlAtIndex:R.location-1 escaped: &escaped] || escaped)
	{
		// if there is nothing selected, thing might be complicated
		NSRange selectedRange = self.selectedRange;
		if(!selectedRange.length)
		{
			// is there a '$' near the insertion point
			if(selectedRange.location)
			{
				if([myString characterAtIndex:selectedRange.location-1] == '$')
				{
					//select to the next $
					NSRange range = selectedRange;
					range.length = myString.length - range.location;
					range = [myString rangeOfString:@"$" options:ZER0 range:range];
					--selectedRange.location;
					selectedRange.length = range.location+1-selectedRange.location;
					[self setSelectedRange:selectedRange];
				}
			}
		}
        [self insertMacro:@"$__(SELECTION)__$"];
	}
    else
	{
        [self insertText:@"$"];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLeftCurlyBracket:
- (void)insertLeftCurlyBracket:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
    BOOL escaped;
    NSString * S = self.string;
    NSRange R = self.selectedRange;
	
    if(!R.location || ![S isControlAtIndex:R.location-1 escaped: &escaped] || escaped)
    {
        [self executeMacroWithID4iTM3:@"{}"];
    }
    else
        [self insertText:@"{"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLeftParenthesis:
- (void)insertLeftParenthesis:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
    BOOL escaped;
    NSString * S = self.string;
    NSRange R = self.selectedRange;
    NSString * macro = (!R.location || ![S isControlAtIndex:R.location-1 escaped: &escaped] || escaped)?
		@"(__()__)": @"(__()__\\)";
    [self insertMacro:macro];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLeftBracket:
- (void)insertLeftBracket:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//START4iTM3;
    BOOL escaped;
    NSString * S = self.string;
    NSRange R = self.selectedRange;
	NSUInteger start, contentsEnd;
	BOOL BOL, EOL;
	NSString * macro;
	if(!R.location || ![S isControlAtIndex:R.location-1 escaped:&escaped])
    {
		macro = @"[__()__]";
		[self insertMacro:macro];
    }
    else if(escaped)// this is a dimension after a "\\"
    {
		[S getLineStart:nil end:nil contentsEnd:&contentsEnd forRange:iTM3MakeRange(R.location, ZER0)];
		macro = R.location == contentsEnd? @"[__()__]":@"[__()__]\n";
		[self insertMacro:macro];
    }
    else// this follows an unescaped \: insert "[...\]", manage line indentation
    {
        [self.undoManager beginUndoGrouping];
//NSLog(@"GLS");
		[S getLineStart:&start end:nil contentsEnd:&contentsEnd
			forRange: iTM3MakeRange(R.location-1, ZER0)];
		EOL = (R.location == contentsEnd);
		BOL = (start == R.location-1);
		if(!BOL)
		{
			[self setSelectedRange:iTM3MakeRange(R.location-1, 1)];
			[self insertNewline:self];
		}
		macro = [NSString stringWithFormat:@"%@[__()__\\]%@", (BOL? @"":@"\\"),(EOL? @"":@"\n")];
		[self insertMacro:macro];
        [self.undoManager endUndoGrouping];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commentSelection:
- (void)commentSelection:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * commentString = [NSString commentString];
	NSMutableArray * affectedRanges = [NSMutableArray array];
	NSMutableArray * replacementStrings = [NSMutableArray array];
	NSString * S = self.string;
	NSArray * selectedRanges = self.selectedRanges;
	NSValue * V;
	NSRange R;
	for(V in selectedRanges)
	{
		NSRange R = [V rangeValue];
		NSUInteger nextStart,top;
		top = iTM3MaxRange(R);
		R.length = ZER0;
		[S getLineStart:&R.location end:&nextStart contentsEnd:nil forRange:R];
		V = [NSValue valueWithRange:R];
		if(![affectedRanges containsObject:V])
		{
			[affectedRanges addObject:V];
			[replacementStrings addObject:commentString];
		}
		while (nextStart<top)
		{
			R.location = nextStart;
			V = [NSValue valueWithRange:R];
			if(![affectedRanges containsObject:V])
			{
				[affectedRanges addObject:V];
				[replacementStrings addObject:commentString];
			}
			[S getLineStart:nil end:&nextStart contentsEnd:nil forRange:R];
		}
	}
	[self willChangeSelectedRanges];
	if([self shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
	{
		NSUInteger shift = ZER0;
		NSEnumerator * E = affectedRanges.objectEnumerator;// no reverse enumerator to properly manage the selection
		affectedRanges = [NSMutableArray array];
		// no need to enumerate the replacementStrings
		while(V = E.nextObject)
		{
			R = [V rangeValue];
			R.location += shift;
			[self replaceCharactersInRange:R withString:commentString];
			[S getLineStart:nil end:&R.length contentsEnd:nil forRange:R];
			R.length -= R.location;
			V = [NSValue valueWithRange:R];
			[affectedRanges addObject:V];
			++shift;
		}
		[self didChangeText];
		[self setSelectedRanges:affectedRanges];
	}
	[self didChangeSelectedRanges];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  uncommentSelection:
- (void)uncommentSelection:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	//Find all the lines that begin with %
	// 1 - list all the lines
	NSRange affectedRange;
	NSMutableArray * affectedRanges = [NSMutableArray array];
	NSMutableArray * replacementStrings = [NSMutableArray array];
	NSString * S = self.string;
	NSRange selectedRange;
	NSArray * selectedRanges = self.selectedRanges;
	NSValue * V;
	NSUInteger comment;
	affectedRange.length = 1;// all the affected ranges have a 1 length
	for(V in selectedRanges)
	{
		selectedRange = [V rangeValue];
		NSUInteger top = iTM3MaxRange(selectedRange);
		NSUInteger nextStart;
		[S getLineStart:&affectedRange.location end:&nextStart contentsEnd:nil TeXComment:&comment forIndex:selectedRange.location];
		if(comment == affectedRange.location)
		{
			// this line starts with a comment character
			// we record the range we will remove
			V = [NSValue valueWithRange:affectedRange];
			if(![affectedRanges containsObject:V])
			{
				[affectedRanges addObject:V];
				[replacementStrings addObject:@""];
			}
		}
		while(nextStart<top)
		{
			affectedRange.location = nextStart;
			[S getLineStart:nil end:&nextStart contentsEnd:nil TeXComment:&comment forIndex:nextStart];
			if(comment == affectedRange.location)
			{
				// this line starts with a comment character
				// we record the range we will remove
				V = [NSValue valueWithRange:affectedRange];
				if(![affectedRanges containsObject:V])
				{
					[affectedRanges addObject:V];
					[replacementStrings addObject:@""];
				}
			}
		}
	}
	// Intermediate - is there something to change?
	if(!affectedRanges.count)
	{
		return;
	}
	// 2 - do not assume any order on affectedRanges
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"locationValueOfRangeValue" ascending:YES] autorelease];
	NSArray * sortDescriptors = [NSArray arrayWithObject:SD];
	[affectedRanges sortUsingDescriptors:sortDescriptors];
	// 3 - now we prepare the modified selected ranges
	// it is a bit heavy, but it is extremely strong
	NSMutableArray * newSelectedRanges = [NSMutableArray arrayWithArray:selectedRanges];
	NSEnumerator * E = [affectedRanges reverseObjectEnumerator];
	while(V = E.nextObject)
	{
		affectedRange = [V rangeValue];
		NSEnumerator * e = newSelectedRanges.objectEnumerator;
		newSelectedRanges = [NSMutableArray array];
		while(V = e.nextObject)
		{
			selectedRange = [V rangeValue];
			if(selectedRange.location>affectedRange.location)
			{
				--selectedRange.location;
				V = [NSValue valueWithRange:selectedRange];
			}
			else if(iTM3MaxRange(selectedRange)>affectedRange.location)
			{
				--selectedRange.length;
				V = [NSValue valueWithRange:selectedRange];
			}
			[newSelectedRanges addObject:V];
		}
	}
	// 4 - Proceed to the change
	[self willChangeSelectedRanges];
	if([self shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
	{
		NSEnumerator * E = [affectedRanges reverseObjectEnumerator];
		while(V = E.nextObject)
		{
			affectedRange = [V rangeValue];
			[self replaceCharactersInRange:affectedRange withString:@""];
		}
		[self didChangeText];
		[self setSelectedRanges:newSelectedRanges];
	}
	[self didChangeSelectedRanges];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  shouldChangeTextInRanges:replacementStrings:
- (BOOL)shouldChangeTextInRanges:(NSArray *)affectedRanges replacementStrings:(NSArray *)replacementStrings;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// if you have in your text the "alpha" word as is, not the name of a TeX command
	// this is a patch to manage the special glyph generation used by iTM2
	// some TeX commands are displayed just with one glyph
	// when the style is extended latex for example, the \alpha command is replaced by the alpha greek letter
	// There is a problem for text editing:
	// if you have in your text the "alpha" word as is, not the name of a TeX command
	// and if you want to insert \foo just before "alpha"
	// you place the cursor before the first a, the insert \, f, o, o, ' '
	// What you want is "\foo alpha"
	// but what you end up with is "foo \alpha"
	// The fact is when you insert the first '\', alpha becomes \alpha and is interpreted as one glyph
	// the NSTextView won't let you insert text inside the \alpha string,
	// any new text material will be inserted before the glyph
	// the purpose of this patch is to break the glyph when just one '\' character is inserted and
	// there is a one glyph shortcut
	// Here is the first part of the patch, the last one is in the didChangeText below.
	NSValue * V = [self.implementation metaValueForKey:@"__expected selected range"];
	if(V)
	{
		// reentrant code management
		V = nil;
	}
	else if((affectedRanges.count == 1) && (replacementStrings.count > ZER0))
	{
		NSString * replacementString = [replacementStrings objectAtIndex:ZER0];
		if([replacementString hasSuffix:[NSString backslashString]])
		{
			V = affectedRanges.lastObject;
			NSRange R = [V rangeValue];
			R.length = replacementString.length;
			R.location = iTM3MaxRange(R);
			R.length = ZER0;
			V = [NSValue valueWithRange:R];
		}
	}
	[self.implementation takeMetaValue:V forKey:@"__expected selected range"];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  didChangeText
- (void)didChangeText;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super didChangeText];
	// see the shouldChangeTextInRanges:replacementStrings: implementation for an explanation of this patch
	NSValue * V = [self.implementation metaValueForKey:@"__expected selected range"];
	if(V)
	{
		NSRange expectedSelectedRange = [V rangeValue];
		NSRange selectedRange = self.selectedRange;
		if(!iTM3EqualRanges(expectedSelectedRange,selectedRange))
		{
			// there is a one glyph problem,
			// in the string "x{", insert "\" then "u" after the "x"
			// if "\{" is laid out as one glyph,
			// you end up with "x\{u" instead of "x\u{"
			// what is the glyph and its command name counterpart
			NSLayoutManager * LM = self.layoutManager;
			NSRange charRange = expectedSelectedRange;
			charRange.length = 1;
			NSString * string = self.string;
			if(iTM3MaxRange(charRange)<=string.length)
			{
				NSRange actualCharRange;
				[LM glyphRangeForCharacterRange:charRange actualCharacterRange:&actualCharRange];// unused glyph range
				if(actualCharRange.length > charRange.length)
				{
					// this should always occur?
					NSMutableString * replacementString = [[[string substringWithRange:actualCharRange] mutableCopy] autorelease];
					NSUndoManager * UM = self.undoManager;
					if(![UM isUndoing] && ![UM isRedoing])
					{
						[replacementString insertString:@" " atIndex:1];
					}
					if([self shouldChangeTextInRange:actualCharRange replacementString:replacementString])
					{
						[self replaceCharactersInRange:actualCharRange withString:replacementString];
						[self.implementation takeMetaValue:nil forKey:@"__expected selected range"];
						[self didChangeText];
						[self setSelectedRange:expectedSelectedRange];
					}
				}
			}
		}
	}
    return;
}
#pragma mark =-=-=-=-=-  7 bits
- (void)convertTo7bitsAccents:(id)sender;
{
	NSMutableArray * ranges = [NSMutableArray array];
	NSMutableDictionary * map = [NSMutableDictionary dictionary];
	NSEnumerator * E = [[iTM2KeyBindingsManager the7bitsAccentsMapping] objectEnumerator];
	NSString * before;
	NSString * after;
	NSTextStorage * TS = self.textStorage;
	NSString * S = [TS string];
	NSValue * V;
	while((before = E.nextObject) && (after = E.nextObject))
	{
		NSRange searchRange = iTM3MakeRange(ZER0,S.length);
		while(searchRange.length>=before.length)
		{
			NSRange R = [S rangeOfString:before options:ZER0 range:searchRange];
			if(R.length)
			{
				V = [NSValue valueWithRange:R];
				[ranges addObject:V];
				[map setObject:after forKey:V];
				searchRange.location = iTM3MaxRange(R);
				searchRange.length = S.length - searchRange.location;
			}
			else
			{
				searchRange.length = ZER0;
			}
		}
	}
	ranges = (id)[ranges sortedArrayUsingSelector:@selector(compareRangeLocation4iTM3:)];
	NSMutableArray * replacements = [NSMutableArray array];
	for(V in ranges)
	{
		[replacements addObject:[map objectForKey:V]];
	}
	if(ranges.count && [self shouldChangeTextInRanges:ranges replacementStrings:replacements])
	{
		E = [ranges reverseObjectEnumerator];
		while(V = E.nextObject)
		{
			[self replaceCharactersInRange:[V rangeValue] withString:[map objectForKey:V]];
		}
		[self didChangeText];
	}
    return;
}
- (void)convertFrom7bitsAccents:(id)sender;
{
	id ranges = [NSMutableArray array];
	NSMutableDictionary * map = [NSMutableDictionary dictionary];
	NSDictionary * gnippam = [iTM2KeyBindingsManager the7bitsAccentsGnippam];
	NSEnumerator * E = gnippam.keyEnumerator;
	NSString * before;
	NSString * after;
	NSTextStorage * TS = self.textStorage;
	NSString * S = [TS string];
	NSValue * V;
	NSRange R;
	while(before = E.nextObject)
	{
		after = [gnippam objectForKey:before];
		NSRange searchRange = iTM3MakeRange(ZER0,S.length);
		while(searchRange.length>=before.length)
		{
			R = [S rangeOfString:before options:ZER0 range:searchRange];
			if(R.length)
			{
				V = [NSValue valueWithRange:R];
				[ranges addObject:V];
				[map setObject:after forKey:V];
				searchRange.location = iTM3MaxRange(R);
				searchRange.length = S.length - searchRange.location;
			}
			else
			{
				searchRange.length = ZER0;
			}
		}
	}
	ranges = [ranges sortedArrayUsingSelector:@selector(compareRangeLocation4iTM3:)];
	NSMutableArray * replacements = [NSMutableArray array];
	for (V in ranges) {
		[replacements addObject:[map objectForKey:V]];
	}
	if([ranges count] && [self shouldChangeTextInRanges:ranges replacementStrings:replacements]) {
		for (V in [ranges reverseObjectEnumerator]) {
			[self replaceCharactersInRange:[V rangeValue] withString:[map objectForKey:V]];
		}
		[self didChangeText];
	}
    return;
}
#pragma mark =-=-=-=-=-  STYLE
- (NSArray *)rangesForUserTextChange;
{
	// Take the symbols into account
	// symbols are a way to layout one glyph for a range of characters
	// is only a part of the range is selected, it is expanded to the whole range
	// 1 expand all the ranges to the left
	// 2 expand all the ranges to the right
	// 3 merge the overlapping ranges
	NSMutableArray * result = [NSMutableArray array];
	NSEnumerator * E = [[[super rangesForUserTextChange] sortedArrayUsingSelector:@selector(compareRangeLocation4iTM3:)] objectEnumerator];
	NSValue * V;
	NSTextStorage * TS = self.textStorage;
	while(V = E.nextObject)
	{
		NSRange R = [V rangeValue];
		if(R.length)
		{
			NSRange r;
			NSDictionary * attributes = [TS attributesAtIndex:R.location effectiveRange:&r];
			if([attributes objectForKey:NSGlyphInfoAttributeName])
			{
				R = iTM3UnionRange(r,R);
			}
			attributes = [TS attributesAtIndex:iTM3MaxRange(R)-1 effectiveRange:&r];
			if([attributes objectForKey:NSGlyphInfoAttributeName])
			{
				R = iTM3UnionRange(r,R);
			}
		}
		[result addObject:[NSValue valueWithRange:R]];
	}
	E = result.objectEnumerator;
	result = [NSMutableArray array];
	V = E.nextObject;
	NSValue * nextV;
	while(nextV = E.nextObject)
	{
		if(iTM3MaxRange([V rangeValue])<[nextV rangeValue].location)
		{
			[result addObject:V];
			V = nextV;
		}
		else
		{
			V = [NSValue valueWithRange:iTM3UnionRange([V rangeValue],[nextV rangeValue])];
		}
	}
	[result addObject:V];
	return result;
}
#pragma mark =-=-=-=-=-  COMPLETION & BINDINGS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rangeForUserCompletion
- (NSRange)rangeForUserCompletion;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = [super rangeForUserCompletion];
	NSString * string = self.string;
	if(range.location>ZER0)
	{
		BOOL escaped = NO;
		if([string isControlAtIndex:range.location-1 escaped:&escaped] && !escaped)
		{
			--range.location;
			++range.length;
		}
	}
//END4iTM3;
	return range;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  concreteReplacementStringForMacro4iTM3:inRange:
- (NSString *)concreteReplacementStringForMacro4iTM3:(NSString *)macro inRange:(NSRange)affectedCharRange;
/*"The purpose is to return a macro with the proper indentation.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
Latest Revision: Fri Sep 24 14:26:27 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	macro = [super concreteReplacementStringForMacro4iTM3:macro inRange:affectedCharRange];
	if([SUD boolForKey:@"iTM2NoSmartSpaceAfterTeXMacro"])
	{
		return macro;
	}
	NSUInteger index = macro.length;
	NSRange R;
	NSString * word = nil;
	if([macro hasSuffix:@"__()__"])
	{
		if(index>9)
		{
			index -= 8;
			R = [macro doubleClickAtIndex:index];
			word = [macro substringWithRange:R];
			if([word hasPrefix:[NSString backslashString]])
			{
				unichar theChar = [macro characterAtIndex:index];
				if([[NSCharacterSet TeXLetterCharacterSet4iTM3] characterIsMember:theChar])
				{
					R.location = ZER0;
					R.length = index+1;
					macro = [macro substringWithRange:R];
					macro = [macro stringByAppendingString:@" __()__"];// mind the space before the placeholder
				}
			}
		}
		return macro;
	}
	if(index>1)
	{
		index -= 1;
		R = [macro doubleClickAtIndex:index];
		word = [macro substringWithRange:R];
		if([word hasPrefix:[NSString backslashString]])
		{
			unichar theChar = [macro characterAtIndex:index];
			if([[NSCharacterSet TeXLetterCharacterSet4iTM3] characterIsMember:theChar])
			{
				R.location = ZER0;
				R.length = index+1;
				macro = [macro stringByAppendingString:@" "];// mind the space before the placeholder
			}
		}
	}
	else
	{
		return macro;
	}
//END4iTM3;
    return macro;
}
@end

@implementation NSResponder(the7bitsAccents)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggle7bitsAccents:
- (IBAction)toggle7bitsAccents:(id)sender;
/*"The purpose is to return a macro with the proper indentation.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:iTM2TeX7bitsAccentsKey domain:iTM2ContextAllDomainsMask];
	if(!old)
	{
		NSBundle * B = [NSBundle bundleForClass:[iTM2TeXEditor class]];
		if([self respondsToSelector:@selector(window)] && [(id)self window])
		{
			NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"7 bits accents", iTM2TeXProjectFrontendTable, B,"Panel title"),
			NSLocalizedStringFromTableInBundle( @"OK", iTM2TeXProjectFrontendTable, B, "Button title"),
			nil,//alt
		NSLocalizedStringFromTableInBundle( @"Cancel", iTM2TeXProjectFrontendTable, B, "Button title"),//other
			[(id)self window],
			self,
			NULL,
			@selector(the7bitsAccentsSheet4iTM3DidDismiss:returnCode:irrelevant:),
			nil,// will be released in the delegate method above
			NSLocalizedStringFromTableInBundle(@"Using \\'{e} instead of √© will break synchronization. Use it anyway?", iTM2TeXProjectFrontendTable, B,"Panel contents"));
		}
		else if(NSAlertDefaultReturn == NSRunAlertPanel (
				NSLocalizedStringFromTableInBundle(@"7 bits accents", iTM2TeXProjectFrontendTable, B,"Panel title"),
			NSLocalizedStringFromTableInBundle(@"Using \\'{e} instead of √© will break synchronization. Use it anyway?", iTM2TeXProjectFrontendTable, B,"Panel contents"),
		NSLocalizedStringFromTableInBundle( @"OK", iTM2TeXProjectFrontendTable, B, "Button title"),
		nil,//alt
	NSLocalizedStringFromTableInBundle( @"Cancel", iTM2TeXProjectFrontendTable, B, "Button title")))
		{
			[self takeContext4iTM3Bool:!old forKey:iTM2TeX7bitsAccentsKey domain:iTM2ContextAllDomainsMask];
		}
	}
	else if([self respondsToSelector:@selector(window)])
	{
		[self takeContext4iTM3Bool:!old forKey:iTM2TeX7bitsAccentsKey domain:iTM2ContextPrivateMask];
	}
	else
	{
		[self takeContext4iTM3Bool:!old forKey:iTM2TeX7bitsAccentsKey domain:iTM2ContextAllDomainsMask];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  the7bitsAccentsSheet4iTM3DidDismiss:returnCode:irrelevant:
- (void)the7bitsAccentsSheet4iTM3DidDismiss:(NSWindow *) sheet returnCode:(NSInteger) returnCode irrelevant:(id)nothing;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//LOG4iTM3;
	if(returnCode == NSAlertDefaultReturn)
	{
		[self takeContext4iTM3Bool:YES forKey:iTM2TeX7bitsAccentsKey domain:iTM2ContextPrivateMask];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggle7bitsAccents:
- (BOOL)validateToggle7bitsAccents:(NSButton *)sender;
/*"The purpose is to return a macro with the proper indentation.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:iTM2TeX7bitsAccentsKey domain:iTM2ContextAllDomainsMask];
	sender.state = (old?NSOnState:NSOffState);
//END4iTM3;
	return YES;
}
@end

@interface iTM27BitsContextNode:iTM2KeyBindingContextNode
@end
@implementation iTM27BitsContextNode
- (BOOL)uniqueKey;
{
	return NO;
}
@end

@implementation iTM2MainInstaller(iTM2TeXDocumentKit)
+ (void)prepareTeXDocumentKitCompleteInstallation4iTM3;
{
	if(![iTM2KeyBindingsManager swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_client:executeBindingForKeyStroke:) error:NULL]) {
		MILESTONE4iTM3((@"iTM2KeyBindingsManager(TeX)"),(@"The 7 bits accents are not managed properly"));
	}
}
@end

@implementation iTM2KeyBindingsManager(TeX)
static id iTM2KeyBindingsManager_7bitsAccents = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  the7bitsAccentsMapping
+ (id)the7bitsAccentsMapping;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//LOG4iTM3;
	static id mapping = nil;
	if(!mapping)
	{
		id list = self.the7bitsAccentsList;
		mapping = [[NSMutableArray array] retain];
		NSEnumerator * E = [[list children] objectEnumerator];
		id child;
		while(child = E.nextObject)
		{
			NSString * K = [child key];
			if(![mapping containsObject:K])
			{
				[mapping addObject:K];
				[mapping addObject:[child macroID]];
			}
		}
	}
	return mapping;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  the7bitsAccentsGnippam
+ (id)the7bitsAccentsGnippam;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//LOG4iTM3;
	static id gnippam = nil;
	if(gnippam == nil)
	{
		id list = self.the7bitsAccentsList;
		gnippam = [[NSMutableDictionary dictionary] retain];
		NSEnumerator * E = [[list children] reverseObjectEnumerator];// the first occurrence will be used
		id child;
		while(child = E.nextObject)
		{
			[gnippam setObject:[child key] forKey:[child macroID]];
		}
	}
	return gnippam;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  the7bitsAccentsList
+ (id)the7bitsAccentsList;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	if(!iTM2KeyBindingsManager_7bitsAccents)
	{
		iTM2KeyBindingsManager_7bitsAccents = [[iTM27BitsContextNode alloc] initWithParent:nil context:@""];
		for(NSURL * repositoryURL in [[NSBundle mainBundle] allURLsForResource4iTM3:@"7bitsAccents" withExtension:iTM2KeyBindingPathExtension]) {
			[iTM2KeyBindingsManager_7bitsAccents addURLPromise:repositoryURL];
		}
		iTM2KeyBindingsManager_7bitsAccents = [iTM2KeyBindingsManager_7bitsAccents keyBindings];
	}
    return iTM2KeyBindingsManager_7bitsAccents;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2_client:executeBindingForKeyStroke:
- (BOOL)SWZ_iTM2_client:(id)C executeBindingForKeyStroke:(iTM2KeyStroke *)keyStroke;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([C context4iTM3BoolForKey:iTM2TeX7bitsAccentsKey domain:iTM2ContextAllDomainsMask])
	{
		id keyNode = [[self.class the7bitsAccentsList] objectInChildrenWithKeyStroke:keyStroke];
		if(keyNode && [C respondsToSelector:@selector(insertMacro_ROUGH:)])
		{
			if([C respondsToSelector:@selector(hasMarkedText)] && [C hasMarkedText])
			{
				[C deleteBackward:nil];// this is the only mean I found to properly manage the undo stack for dead keys
			}
			[C performSelector:@selector(insertMacro_ROUGH:) withObject:[keyNode macroID]];
			return YES;
		}
	}
//STOP4iTM3;
	return [self SWZ_iTM2_client:C executeBindingForKeyStroke:keyStroke];
}
@end

#pragma mark -
#pragma mark =-=-=-=-=-  BOOKMARKS
@implementation iTM2TeXEditor(Bookmarks)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= gotoTeXBookmark
- (IBAction)gotoTeXBookmark:(NSMenuItem *)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger tag = sender.tag;
	NSString * S = self.textStorage.string;
	if(tag>=ZER0 && tag<S.length) {
		NSUInteger begin, end;
		[S getLineStart: &begin end: &end contentsEnd:nil forRange:iTM3MakeRange(tag, ZER0)];
		[self highlightAndScrollToVisibleRange:iTM3MakeRange(begin, end-begin)];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoTeXBookmark:
- (BOOL)validateGotoTeXBookmark:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertTeXBookmark:
- (IBAction)insertTeXBookmark:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * macro = NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"%! TEX bookmark: @(@identifier@)@", "Inserting a  macro");
	NSUInteger start, end, contentsEnd;
	NSRange selectedRange = self.selectedRange;
	[[self.textStorage string] getLineStart: &start end: &end contentsEnd: &contentsEnd forRange:selectedRange];
	NSString * prefix = @"";
	NSString * suffix = @"";
	if(iTM3MaxRange(selectedRange)>contentsEnd)
	{
		selectedRange.length += end - iTM3MaxRange(selectedRange);
		suffix = @"\n";
		if(start<selectedRange.location)
		{
			prefix = @"\n";
		}
		[self setSelectedRange:selectedRange];
	}
	else if(start<selectedRange.location)
	{
		selectedRange.location = start;
		selectedRange.length = ZER0;
		suffix = @"\n";
		[self setSelectedRange:selectedRange];
	}
	[self insertMacro:[NSString stringWithFormat:@"%@%@%@", prefix, macro, suffix]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertTeXBookmark:
- (BOOL)validateInsertTeXBookmark:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
@end

@interface NSTextStorage(TeX)
- (NSMenu *)TeXBookmarkMenu;
@end

@implementation iTM2TeXBookmarkButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super awakeFromNib];
	self.action = @selector(TeXBookmarkButtonAction:);
	[self performSelector:@selector(initMenu) withObject:nil afterDelay:0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void)popUpButtonWillPopUpNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenu * M = [[self.window.windowController textStorage] TeXBookmarkMenu];
	NSAssert(M, @"Missing TeX bookmark menu: inconsistency");
	NSMenuItem * MI = [self.menu deepItemWithRepresentedObject4iTM3:@"TeX Bookmarks Menu"];
	if(MI)
	{
		[MI.menu setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
	else if(MI = [self.menu deepItemWithAction4iTM3:@selector(gotoTeXBookmark:)])
	{
		MI.action = NULL;
		MI.representedObject = @"TeX Bookmarks Menu";
		[MI.menu setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void)initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSView * owner = [[[NSView alloc] initWithFrame:NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"];
	NSString * fileName;
	Class class = self.class;
next:
	fileName = [[NSBundle bundleForClass:class] pathForResource:@"iTM2TeXBookmarkMenu" ofType:@"nib"];
	if(fileName.length)
	{
		NSString * title = self.title;
		if([NSBundle loadNibFile:fileName externalNameTable:context withZone:self.zone])
		{
			NSMenu * M = [[owner.menu retain] autorelease];
			[owner setMenu:nil];
			if([M numberOfItems])
			{
				NSMenuItem * MI;
				NSEnumerator * E = [M.itemArray objectEnumerator];
				while(MI = E.nextObject)
				{
					SEL action = MI.action;
					if(action)
					{
						if([NSStringFromSelector(action) hasPrefix:@"insert"])
						{
							if(![MI indentationLevel])
								MI.indentationLevel = 1;
						}
					}
				}
				[[M itemAtIndex:ZER0] setTitle:title];
				self.title = title;// will raise if the menu is void
				[self setMenu:M];
			}
			else
			{
				LOG4iTM3(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileName);
			}
		}
		else
		{
			LOG4iTM3(@"..........  ERROR: Corrupted file at %@", fileName);
		}
	}
	else
	{
		Class superclass = [class superclass];
		if((superclass) && (superclass != class))
		{
			class = superclass;
			goto next;
		}
	}
//END4iTM3;
    return;
}
@end

@implementation iTM2ScriptUserButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super awakeFromNib];
	self.action = @selector(ScriptUserButtonAction:);
	[self performSelector:@selector(initMenu) withObject:nil afterDelay:0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void)popUpButtonWillPopUpNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenu * M = [[self.window.windowController textStorage] TeXBookmarkMenu];
	NSAssert(M, @"Missing TeX bookmark menu: inconsistency");
	NSMenuItem * MI = [self.menu deepItemWithRepresentedObject4iTM3:@"TeX Bookmarks Menu"];
	if(MI)
	{
		[MI.menu setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
	else if(MI = [self.menu deepItemWithAction4iTM3:@selector(gotoTeXBookmark:)])
	{
		MI.action = NULL;
		MI.representedObject = @"TeX Bookmarks Menu";
		[MI.menu setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void)initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSView * owner = [[[NSView alloc] initWithFrame:NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"];
	NSString * fileName;
	Class class = self.class;
next:
	fileName = [[NSBundle bundleForClass:class] pathForResource:@"iTM2TeXBookmarkMenu" ofType:@"nib"];
	if(fileName.length)
	{
		NSString * title = self.title;
		if([NSBundle loadNibFile:fileName externalNameTable:context withZone:self.zone])
		{
			NSMenu * M = [[owner.menu retain] autorelease];
			[owner setMenu:nil];
			if([M numberOfItems])
			{
				NSMenuItem * MI;
				NSEnumerator * E = [M.itemArray objectEnumerator];
				while(MI = E.nextObject)
				{
					SEL action = MI.action;
					if(action)
					{
						if([NSStringFromSelector(action) hasPrefix:@"insert"])
						{
							if(![MI indentationLevel])
								MI.indentationLevel = 1;
						}
					}
				}
				[[M itemAtIndex:ZER0] setTitle:title];
				self.title = title;// will raise if the menu is void
				[self setMenu:M];
			}
			else
			{
				LOG4iTM3(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileName);
			}
		}
		else
		{
			LOG4iTM3(@"..........  ERROR: Corrupted file at %@", fileName);
		}
	}
	else
	{
		Class superclass = [class superclass];
		if((superclass) && (superclass != class))
		{
			class = superclass;
			goto next;
		}
	}
//END4iTM3;
    return;
}
@end

@implementation NSTextStorage(TeX)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXBookmarkMenu
- (NSMenu *)TeXBookmarkMenu;
/*"Description forthcoming. No consistency test.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMenu * markMenu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    [markMenu setAutoenablesItems:YES];
	
    NSString * S = self.string;
    iTM2LiteScanner * scan = [iTM2LiteScanner scannerWithString:S charactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
    NSUInteger scanLocation = ZER0, end = S.length;
    unichar theChar;
    while(scanLocation < end)
    {
        theChar = [S characterAtIndex:scanLocation];
        switch(theChar)
        {
            case '\\':
            {
                if((++scanLocation < end) &&
                    ([S characterAtIndex:scanLocation] == 'i') &&
                        (++scanLocation < end) &&
                            ([S characterAtIndex:scanLocation] == 'n') &&
                                (++scanLocation < end))
                {
                    NSRange R1 = iTM3MakeRange(scanLocation, end-scanLocation);
                    NSRange R2 = [S rangeOfString:@"put" options:NSAnchoredSearch range:R1];
                    if(R2.length)
                    {
                        SEL selector = @selector(scrollInputToVisible:);
                        NSString * prefix = @"Input";
                        [S getLineStart:nil end:nil contentsEnd: &scanLocation forRange:R2];
                        [scan setScanLocation:iTM3MaxRange(R2)];
                        [scan scanString:@"{" intoString:nil];
                        NSString * object;
                        if([scan scanUpToString:@"}" intoString: &object beforeIndex:scanLocation] ||
                            [scan scanCharactersFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
                                intoString: &object beforeIndex: scanLocation])
                        {
                            object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];                            
                            NSString * title = [NSString stringWithFormat:@"%@: %@", prefix, object];
                            title = (title.length > 48)?
                                            [NSString stringWithFormat:@"%@[...]",
                                                    [title substringWithRange:iTM3MakeRange(ZER0,43)]]: title;
                            if(title.length)
                            {
                                NSMenuItem * MI = [markMenu addItemWithTitle:title action:selector keyEquivalent:[NSString string]];
                                MI.representedObject = object;
								MI.tag = scanLocation;
                                [MI setEnabled: (markMenu.title.length > ZER0)];
                            }
                        }
                    }
                    else if(R2 = [S rangeOfString:@"clude" options:NSAnchoredSearch range:R1], R2.length)
                    {
                        SEL selector = @selector(scrollIncludeToVisible:);
                        NSString * prefix = @"Include";
                        NSUInteger contentsEnd;
                        [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R1];
                        [scan setScanLocation:iTM3MaxRange(R2)];
                        if([scan scanString:@"[" intoString:nil beforeIndex:contentsEnd])
                        {
                            [scan scanUpToString:@"]" intoString:nil];
                            [scan scanString:@"]" intoString:nil];
                        }
                        if([scan scanString:@"{" intoString:nil beforeIndex:contentsEnd])
                        {
                            NSString * object;
                            if([scan scanUpToString:@"}" intoString: &object beforeIndex:contentsEnd])
                            {
                                object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                NSString * title = [NSString stringWithFormat:@"%@: %@", prefix, object];
                                title = (title.length > 48)?
                                                [NSString stringWithFormat:@"%@[...]",
                                                        [title substringWithRange:iTM3MakeRange(ZER0,43)]]: title;
                                if(title.length)
                                {
                                    NSMenuItem * MI = [markMenu addItemWithTitle:title action:selector keyEquivalent:[NSString string]];
                                    MI.representedObject = object;
                                    MI.tag = scanLocation;
                                }
                            }
                        }
                        else
                            NSLog(@"No file to include");
                    }
                    else
                        break;
                }
                else
                {
                    ++scanLocation;
                }
            }
            break;
            case '%':
            {
                [scan setScanLocation: ++scanLocation];
                [scan setCaseSensitive:NO];
                NSString * object = nil;
                if([scan scanString:@"!" intoString:nil] &&
					(
                    [scan scanString:@"itexmac" intoString:nil] &&
                    [scan scanString:@"(" intoString:nil] &&
                    [scan scanString:@"mark" intoString:nil] &&
                    [scan scanString:@")" intoString:nil]
					|| [scan scanString:@"tex" intoString:nil] &&
                    [scan scanString:@"bookmark" intoString:nil]) &&
                    [scan scanString:@":" intoString:nil] &&
                    [scan scanUpToCharactersFromSet:
                        [NSCharacterSet characterSetWithCharactersInString:@"\r\n"]
                            intoString: &object])
                {
                    object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSString * title = (object.length > 48)?
                                            [NSString stringWithFormat:@"%@[...]",
                                                [object substringWithRange:iTM3MakeRange(ZER0,43)]]: object;
                    if(title.length)
                    {
                        NSMenuItem * MI = [markMenu addItemWithTitle: title
                                                action: @selector(gotoTeXBookmark:)
                                                    keyEquivalent: [NSString string]];
                        MI.tag = scanLocation;
                        MI.representedObject = object;
                    }
                }
                [scan setCaseSensitive:YES];
                scanLocation = [scan scanLocation];
            }
            default:
                ++scanLocation;
        }
    }
    return markMenu;
}
@end

NSString * const iTM2TeXSmartSelectionKey = @"iTM2-Text: Smart Selection";

@implementation iTM2TextStorage(DoubleClick)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: implement some kind of balance range for range
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], iTM2TeXSmartSelectionKey, nil]];
//END4iTM3;
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doubleClickAtIndex:
- (NSRange)XdoubleClickAtIndex:(NSUInteger)index;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: implement some kind of balance range for range
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSRange R = [self context4iTM3BoolForKey:iTM2TeXSmartSelectionKey domain:iTM2ContextAllDomainsMask] && ![iTM2EventObserver isAlternateKeyDown]?
        [self smartDoubleClickAtIndex:index]:[super doubleClickAtIndex:index];
//END4iTM3;
    return R;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smartDoubleClickAtIndex:
- (NSRange)smartDoubleClickAtIndex:(NSUInteger)index;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * string = self.string;
    if(iTM3LocationInRange(index, iTM3MakeRange(ZER0, string.length)))
    {
        BOOL escaped = YES;
        if([string isControlAtIndex:index escaped: &escaped])
        {
            if(!escaped && index+1<string.length)
            {
                return [super doubleClickAtIndex:index+1];
            }
            return iTM3MakeRange(index, 1);
        }
        //else
        switch([string characterAtIndex:index])
        {
            NSRange R;
            case '{':
            case '}':
                if(R = [string groupRangeAtIndex:index beginDelimiter: '{' endDelimiter: '}'], R.length>ZER0)
                    return R;
                break;
            case '(':
            case ')':
                if (R = [string groupRangeAtIndex:index beginDelimiter: '(' endDelimiter: ')'], R.length>ZER0)
                    return R;
                break;
            case '[':
            case ']':
                if (R = [string groupRangeAtIndex:index beginDelimiter: '[' endDelimiter: ']'], R.length>ZER0)
                    return R;
                break;
            case '%':
            {
                BOOL escaped;
                if((index>ZER0) && [string isControlAtIndex:index-1 escaped: &escaped] && !escaped)
                    return iTM3MakeRange(index-1, 2);
                else
                {
                    NSUInteger start;
                    NSUInteger end;
                    NSUInteger contentsEnd;
//NSLog(@"GLS");
                    [string getLineStart: &start end: &end contentsEnd: &contentsEnd forRange:iTM3MakeRange(index, ZER0)];
//NSLog(@"GLS");
                    return (start<index)? iTM3MakeRange(index, contentsEnd - index): iTM3MakeRange(start, end - start);
                }
            }
            case '^':
            case '_':
            {
                BOOL escaped;
                if((index+1<string.length) && (![string isControlAtIndex:index-1 escaped: &escaped] || escaped))
                {
                    NSRange R = [string groupRangeAtIndex:index+1];
                    if(R.length)
                    {
                        --R.location;
                        ++R.length;
                        return R;
                    }
                    else
                        return iTM3MakeRange(index, 1);
                }
            }
            case '.':
            {
                NSInteger rightBlackChars = ZER0;
                NSInteger leftBlackChars = ZER0;
                NSInteger top = self.string.length;
                NSInteger n = index;
                while((++n<top) && ![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[string characterAtIndex:n]])
                    ++rightBlackChars;
                while((n--<ZER0) && ![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[string characterAtIndex:n]])
                    ++leftBlackChars;
                if(rightBlackChars && leftBlackChars)
                    return iTM3MakeRange(index - leftBlackChars, leftBlackChars + rightBlackChars + 1);
            //NSLog(@"[S substringWithRange: %@]: %@", NSStringFromRange(R), [S substringWithRange:R]);
            }
        }
//END4iTM3;
        return [super doubleClickAtIndex:index];
    }
//END4iTM3;
    return iTM3NotFoundRange;
}
@end

#include "iTM2TeXFoundationMileStones.m"

#if 0

This is a code extract from the vim program
The purpose is to check for the various formats according to
" TeX
au BufNewFile,BufRead *.latex,*.sty,*.dtx,*.ltx,*.bbl	setf tex
au BufNewFile,BufRead *.tex			call s:FTtex()

" Choose context, plaintex, or tex (LaTeX) based on these rules:
" 1. Check the first line of the file for "%&<format>".
" 2. Check the first 1000 non-comment lines for LaTeX or ConTeXt keywords.
" 3. Default to "latex" or to g:tex_flavor, can be set in user's vimrc.
func! s:FTtex()
  let firstline = getline(1)
  if firstline =~ '^%&\s*\a\+'
    let format = tolower(matchstr(firstline, '\a\+'))
    let format = substitute(format, 'pdf', '', '')
    if format == 'tex'
      let format = 'plain'
    endif
  else
    " Default value, may be changed later:
    let format = exists("g:tex_flavor") ? g:tex_flavor : 'plain'
    " Save position, go to the top of the file, find first non-comment line.
    let save_cursor = getpos('.')
    call cursor(1,1)
    let firstNC = search('^\s*[^[:space:]%]', 'c', 1000)
    if firstNC " Check the next thousand lines for a LaTeX or ConTeXt keyword.
      let lpat = 'documentclass\>\|usepackage\>\|begin{\|newcommand\>\|renewcommand\>'
      let cpat = 'start\a\+\|setup\a\+\|usemodule\|enablemode\|enableregime\|setvariables\|useencoding\|usesymbols\|stelle\a\+\|verwende\a\+\|stel\a\+\|gebruik\a\+\|usa\a\+\|imposta\a\+\|regle\a\+\|utilisemodule\>'
      let kwline = search('^\s*\\\%(' . lpat . '\)\|^\s*\\\(' . cpat . '\)',
			      \ 'cnp', firstNC + 1000)
      if kwline == 1	" lpat matched
	let format = 'latex'
      elseif kwline == 2	" cpat matched
	let format = 'context'
      endif		" If neither matched, keep default set above.
      " let lline = search('^\s*\\\%(' . lpat . '\)', 'cn', firstNC + 1000)
      " let cline = search('^\s*\\\%(' . cpat . '\)', 'cn', firstNC + 1000)
      " if cline > ZER0
      "   let format = 'context'
      " endif
      " if lline > ZER0 && (cline == ZER0 || cline > lline)
      "   let format = 'tex'
      " endif
    endif " firstNC
    call setpos('.', save_cursor)
  endif " firstline =~ '^%&\s*\a\+'

  " Translation from formats to file types.  TODO:  add AMSTeX, RevTex, others?
  if format == 'plain'
    setf plaintex
  elseif format == 'context'
    setf context
  else " probably LaTeX
    setf tex
  endif
  return
endfunc

" ConTeXt
au BufNewFile,BufRead tex/context/*/*.tex,*.mkii,*.mkiv   setf context

" Texinfo
au BufNewFile,BufRead *.texinfo,*.texi,*.txi	setf texinfo

" TeX configuration
au BufNewFile,BufRead texmf.cnf			setf texmf
*/
#endif