/*
//
//  @version Subversion: $Id:$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
//  Copyright © 2006 Laurens'Tribune. All rights reserved.
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

#import "iTM2MacroPrefPane.h"
#import "iTM2TreeKit.h"
#import "iTM2FileManagerKit.h"
#import "iTM2BundleKit.h"
#import "iTM2MenuKit.h"

NSString * const iTM2MacrosDirectoryName = @"Macros";
NSString * const iTM2MacrosPathExtension = @"iTM2-macros";

/*!
    @class       iTM2MacroTreeRoot
    @superclass  iTM2TreeNode
    @abstract    Main tree
    @discussion  This is the main tree containing the macros.
				 The macros are gathered in one tree, with the various domains at the second level,
				 the various categories at the third level, and the various contexts at the 4th level.
				 The contexts are the ones which store the repository path.
				 This is consistent because we are not expected to move contexts from repositories to repositories.
				 We jus can copy from repositories to repositories.
				
*/


@interface iTM2MacroController(PRIVATE)
- (id)macroActionForName:(NSString *)actionName;
- (NSString *)prettyNameForKeyCode:(NSNumber *) keyCode;
- (NSArray *)macroKeyCodePrettyNames;
- (void)setMacroKeyCodePrettyNames:(NSArray *)macroKeyNames;
- (NSArray *)macroKeyCodes;
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outError;
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outError;
@end


@interface iTM2MacroAction: NSObject
{
@private
	NSString * description;
}
- (SEL)action;
- (NSComparisonResult)compareUsingDescription:(id)rhs;
@end

@implementation iTM2MacroAction
- (SEL)action;
{
	id name = NSStringFromClass([self class]);
	NSArray * components = [name componentsSeparatedByString:@"iTM2MacroAction_"];
	if([components count] >1)
	{
		name = [components lastObject];
		name = [name mutableCopy];
		name = [name autorelease];
		[name replaceOccurrencesOfString:@"_" withString:@":" options:0 range:NSMakeRange(0,[name length])];
		return NSSelectorFromString(name);		
	}
	return NULL;
}
- (NSString *)description;
{
	return description;
}
- (id)init;
{
	if(self = [super init])
	{
		SEL action = [self action];
		if(action)
		{
			NSString * actionName = NSStringFromSelector([self action]);
			description = NSLocalizedStringFromTableInBundle(actionName, @"iTM2MacroAction", myBUNDLE, "");
			description = [description copy];
			return self;
		}
	}
	[self release];
	return nil;
}
- (NSComparisonResult)compareUsingDescription:(id)rhs;
{
	return [[self description] compare:[rhs description]];
}
@end

@interface iTM2MacroAction_insertMacro_: iTM2MacroAction
@end

@implementation iTM2MacroAction_insertMacro_
@end

@interface iTM2MacroEditNode: iTM2TreeNode
- (NSString *)ID;
- (NSString *)name;
- (BOOL)canEditName;
- (NSAttributedString *)insertMacroArgument;
@end

@implementation iTM2MacroEditNode
- (id)init;
{
	if(self = [super init])
	{
		[self setValue:[NSMutableDictionary dictionary]];
	}
	return self;
}
- (id)macroAction;
{
	return nil;
}
- (NSAttributedString *)insertMacroArgument;
{
	return nil;
}
- (BOOL)canEditInsertMacroArgument;
{
	return NO;
}
- (NSAttributedString *)macroDescription;
{
	return nil;
}
- (BOOL)canEditMacroDescription;
{
	return NO;
}
- (NSAttributedString *)macroTooltip;
{
	return nil;
}
- (BOOL)canEditMacroTooltip;
{
	return NO;
}
- (NSString *)name;
{
	return [[self valueForKeyPath:@"value.pathComponent"] stringByDeletingPathExtension];
}
- (BOOL)canEditName;
{
	return NO;
}
- (NSString *)ID;
{
	return nil;
}
- (BOOL)canEditID;
{
	return NO;
}
- (NSString *)key;
{
	return nil;
}
- (NSString *)prettyKey;
{
	return nil;
}
- (BOOL)canEditKey;
{
	return NO;
}
- (BOOL)isEdited;
{
	return NO;
}
- (BOOL)isLastNodeLevel;
{
	NSArray * children = [self children];
	return ([children count]>0) && ([[[children lastObject] children] count]==0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromChildren:
- (void)removeObjectFromChildren:(id)anObject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	if([anObject valueForKeyPath:@"value.editableXMLElement"])
	{
		[anObject willChangeValueForKey:@"children"];
		[anObject setValue:nil forKeyPath:@"value.editableXMLElement"];
		if(![[self name] length])
		{
			[super removeObjectFromChildren:anObject];
		}
		[anObject didChangeValueForKey:@"children"];
	}
	else
	{
		[super removeObjectFromChildren:anObject];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromChildrenAtIndex:
- (void)removeObjectFromChildrenAtIndex:(unsigned int)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
    // implementation specific code
	id anObject = [self objectInChildrenAtIndex:index];
	if([anObject valueForKeyPath:@"value.editableXMLElement"])
	{
		[anObject willChangeValueForKey:@"children"];
		[anObject setValue:nil forKeyPath:@"value.editableXMLElement"];
		if(![[self name] length])
		{
			[super removeObjectFromChildren:anObject];
		}
		[anObject didChangeValueForKey:@"children"];
	}
	else
	{
		[super removeObjectFromChildren:anObject];
	}
    return;
}
- (int)commandModifierState;
{
	return NSOffState;
}
- (int)shiftModifierState;
{
	return NSOffState;
}
- (int)alternateModifierState;
{
	return NSOffState;
}
- (int)controlModifierState;
{
	return NSOffState;
}
- (int)functionModifierState;
{
	return NSOffState;
}
- (NSString *)macroKey;
{
	return @"";
}
- (NSNumber *)macroKeyCode;
{
	return nil;
}
- (void)save;
{
	[[self children] makeObjectsPerformSelector:_cmd];
}
@end


@interface iTM2MacroKeyStroke: NSObject
{
@public
	NSNumber * macroKeyCode;
	NSString * _prettyString;
	NSString * _string;
	BOOL isCommand;
	BOOL isShift;
	BOOL isAlternate;
	BOOL isControl;
	BOOL isFunction;
}
- (NSString *)string;
- (NSString *)prettyString;
- (void)update;
@end

@implementation iTM2MacroKeyStroke
- (void)dealloc;
{
	[macroKeyCode release];
	[_prettyString release];
	[_string release];
	[super dealloc];
	return;
}
- (void)update;
{
	[_prettyString release];
	_prettyString = nil;
	[_string release];
	_string = nil;
	return;
}
- (NSString *)string;
{
	if(_string)
	{
		return _string;
	}
	if(macroKeyCode)
	{
		unichar code = [macroKeyCode intValue];
		NSString * macroKey = [NSString stringWithCharacters:&code length:1];
		if(![macroKey length])
		{
			macroKey = [NSString stringWithFormat:@"%#x",[macroKeyCode intValue]];
		}
		NSString * isCommandString = isCommand?@"@":@"";
		NSString * isShiftString = isShift?@"$":@"";
		NSString * isAlternateString = isAlternate?@"~":@"";
		NSString * isControlString = isControl?@"^":@"";
		NSString * isFunctionString = isFunction?@"&":@"";
		NSString * modifier = [NSString stringWithFormat:@"%@%@%@%@%@",isCommandString, isShiftString, isAlternateString, isControlString, isFunctionString];
		if([modifier length])
		{
			_string = [[NSString stringWithFormat:@"%@->%@",modifier, macroKey] retain];
		}
		else
		{
			_string = [macroKey copy];
		}
	}
	else
	{
		_string = @"";
	}
	return _string;
}
- (NSString *)prettyString;
{
	if(_prettyString)
	{
		return _prettyString;
	}
	if(macroKeyCode)
	{
		NSMutableString * result = [NSMutableString string];
		if(isCommand)
		{
			[result appendString:[NSString stringWithUTF8String:"⌘"]];
		}
		if(isShift)
		{
			[result appendString:[NSString stringWithUTF8String:"⇧"]];
		}
		if(isAlternate)
		{
			[result appendString:[NSString stringWithUTF8String:"⌥"]];
		}
		if([result length])
		{
			[result appendString:@" "];
		}
		if(isFunction)
		{
			[result appendString:[NSString stringWithUTF8String:"fn "]];
		}
		if(isControl)
		{
			[result appendString:[NSString stringWithUTF8String:"ctrl"]];
		}
		unichar code = [macroKeyCode intValue];
		NSString * macroKey = [NSString stringWithCharacters:&code length:1];
		if(![macroKey length])
		{
			macroKey = [[iTM2MacroController sharedMacroController] prettyNameForKeyCode:macroKeyCode];
		}
		[result appendString:macroKey];
		_prettyString = [result copy];
	}
	else
	{
		_prettyString = @"";
	}	
	return _prettyString;
}
@end

@interface NSString(iTM2MacroKeyStroke)
- (iTM2MacroKeyStroke *)macroKeyStroke;
@end

@implementation NSString(iTM2MacroKeyStroke)
- (iTM2MacroKeyStroke *)macroKeyStroke;
{
	if(![self length])
	{
		return nil;
	}
	iTM2MacroKeyStroke * result = [[[iTM2MacroKeyStroke alloc] init] autorelease];
	NSMutableArray * components = [[[self componentsSeparatedByString:@"->"] mutableCopy] autorelease];
	NSString * component = [components lastObject];
	unsigned int keyCode = 0;
	if([[NSScanner scannerWithString:component] scanHexInt:&keyCode])
	{
		result -> macroKeyCode = [[NSNumber numberWithInt:keyCode] retain];
	}
	else
	{
		result -> macroKeyCode = [[NSNumber numberWithInt:([component length]?[component characterAtIndex:0]:0)] retain];
	}
	[components removeLastObject];
	component = [components lastObject];
	unsigned int index = [component length];
	while(index--)
	{
		switch([self characterAtIndex:index])
		{
			case '@':
				result->isCommand = YES;
				break;
			case '$':
				result->isShift = YES;
				break;
			case '~':
				result->isAlternate = YES;
				break;
			case '^':
				result->isControl = YES;
				break;
			case '&':
				result->isFunction = YES;
				break;
		}
	}
	return result;
}
@end

@interface iTM2MacroSourceLeafNode: iTM2MacroEditNode
{
@public
	iTM2MacroKeyStroke * macroKeyStroke;
}
- (id)editableXMLElement;
- (void)updateMacroKeyStroke;
- (void)updateKey;
- (void)setMacroKeyCode:(NSNumber *)newCode;

@end

@implementation iTM2MacroSourceLeafNode
- (id)init;
{
	if(self = [super init])
	{
		[macroKeyStroke release];
		macroKeyStroke = [[iTM2MacroKeyStroke alloc] init];
	}
	return self;
}
- (id)editableXMLElement;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(element)
	{
		return element;
	}
	[self updateMacroKeyStroke];
	if(element = [self valueForKeyPath:@"value.XMLElement"])
	{
		element = [[element copy] autorelease];
	}
	else
	{
		element = [NSXMLElement elementWithName:@"ACTION"];
	}
	// finding the parent with a list of XML macro documents
	id parent = self;
	while(parent = [parent parent])
	{
		NSString * subpath = [parent valueForKeyPath:@"value.macrosDocumentsPath"];
		if(subpath)
		{
			id editableMacrosDocument = [parent valueForKeyPath:@"value.editableMacrosDocument"];
			if(!editableMacrosDocument)
			{
				NSArray * otherMacrosDocuments = [parent valueForKeyPath:@"value.otherMacrosDocuments"];
				editableMacrosDocument = [otherMacrosDocuments lastObject];
				editableMacrosDocument = [[editableMacrosDocument copy] autorelease];
				NSString * repositoryPath = [[NSBundle mainBundle] pathForSupportDirectory:@"Macros.localized" inDomain:NSUserDomainMask create:YES];
				NSURL * repositoryURL = [NSURL fileURLWithPath:repositoryPath];
				NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
				[editableMacrosDocument setURI:[url absoluteString]];
				[[parent value] setValue:editableMacrosDocument forKeyPath:@"editableMacrosDocument"];
				id root = [editableMacrosDocument rootElement];
				while([root childCount])
				{
					[root removeChildAtIndex:0];
				}
			}
			[[editableMacrosDocument rootElement] addChild:element];
			break;
		}
	}
	[self setValue:element forKeyPath:@"value.editableXMLElement"];
	return element;
}
- (BOOL)canEditInsertMacroArgument;
{
	return [self canEditName];
}
- (NSAttributedString *)insertMacroArgument;
{
	NSMutableAttributedString * AS = [self valueForKeyPath:@"value.insertMacroArgument"];
	if(AS)
	{
		return AS;
	}
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	NSArray * ARGS = [element elementsForName:@"ARG"];
	element = [ARGS lastObject];
	AS = [[[NSMutableAttributedString alloc] initWithString:(element?[element stringValue]:@"")] autorelease];
	[self setValue:AS forKeyPath:@"value.insertMacroArgument"];
	return AS;
}
- (void)setInsertMacroArgument:(NSAttributedString *)newInsertMacroArgument;
{
	NSAttributedString * oldInsertMacroArgument = [self valueForKeyPath:@"value.insertMacroArgument"];
	if([oldInsertMacroArgument isEqual:newInsertMacroArgument])
	{
		return;
	}
	NSString * S = [newInsertMacroArgument string];
	[self willChangeValueForKey:@"insertMacroArgument"];
	NSXMLElement * element = [self editableXMLElement];
	NSArray * ARGS = [element elementsForName:@"ARG"];
	NSXMLElement * argument = [ARGS lastObject];
	if(argument)
	{
		[argument setStringValue:(S?:@"")];
	}
	else
	{
		argument = [NSXMLElement elementWithName:@"ARG" stringValue:S];
		[element insertChild:argument atIndex:0];
	}
	newInsertMacroArgument = [[newInsertMacroArgument mutableCopy] autorelease];
	[self setValue:newInsertMacroArgument forKeyPath:@"value.insertMacroArgument"];
	[self didChangeValueForKey:@"insertMacroArgument"];
	[self willChangeValueForKey:@"isEdited"];
	[self didChangeValueForKey:@"isEdited"];
	return;
}
- (NSAttributedString *)macroDescription;
{
	NSMutableAttributedString * AS = [self valueForKeyPath:@"value.macroDescription"];
	if(AS)
	{
		return AS;
	}
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	NSArray * DESCs = [element elementsForName:@"DESC"];
	element = [DESCs lastObject];
	AS = [[[NSMutableAttributedString alloc] initWithString:(element?[element stringValue]:@"")] autorelease];
	[self setValue:AS forKeyPath:@"value.macroDescription"];
	return AS;
}
- (void)setMacroDescription:(NSAttributedString *)newMacroDescription;
{
	NSAttributedString * oldMacroDescription = [self valueForKeyPath:@"value.insertMacroArgument"];
	if([oldMacroDescription isEqual:newMacroDescription])
	{
		return;
	}
	NSString * S = [newMacroDescription string];
	[self willChangeValueForKey:@"macroDescription"];
	NSXMLElement * element = [self editableXMLElement];
	NSArray * DESCs = [element elementsForName:@"DESC"];
	NSXMLElement * DESC = [DESCs lastObject];
	if(DESC)
	{
		[DESC setStringValue:(S?:@"")];
	}
	else
	{
		DESC = [NSXMLElement elementWithName:@"DESC" stringValue:S];
		[element insertChild:DESC atIndex:0];
	}
	newMacroDescription = [[newMacroDescription mutableCopy] autorelease];
	[self setValue:newMacroDescription forKeyPath:@"value.macroDescription"];
	[self didChangeValueForKey:@"macroDescription"];
	[self willChangeValueForKey:@"isEdited"];
	[self didChangeValueForKey:@"isEdited"];
	return;
}
- (BOOL)canEditMacroDescription;
{
	return YES;
}
- (NSAttributedString *)macroTooltip;
{
	NSMutableAttributedString * AS = [self valueForKeyPath:@"value.macroTooltip"];
	if(AS)
	{
		return AS;
	}
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	NSArray * TIPs = [element elementsForName:@"TIP"];
	element = [TIPs lastObject];
	AS = [[[NSMutableAttributedString alloc] initWithString:(element?[element stringValue]:@"")] autorelease];
	[self setValue:AS forKeyPath:@"value.macroTooltip"];
	return AS;
}
- (void)setMacroTooltip:(NSAttributedString *)newMacroTooltip;
{
	NSAttributedString * oldMacroTooltip = [self valueForKeyPath:@"value.insertMacroArgument"];
	if([oldMacroTooltip isEqual:newMacroTooltip])
	{
		return;
	}
	NSString * S = [newMacroTooltip string];
	[self willChangeValueForKey:@"macroTooltip"];
	NSXMLElement * element = [self editableXMLElement];
	NSArray * TIPs = [element elementsForName:@""];
	NSXMLElement * TIP = [TIPs lastObject];
	if(TIP)
	{
		[TIP setStringValue:(S?:@"")];
	}
	else
	{
		TIP = [NSXMLElement elementWithName:@"TIP" stringValue:S];
		[element insertChild:TIP atIndex:0];
	}
	newMacroTooltip = [[newMacroTooltip mutableCopy] autorelease];
	[self setValue:newMacroTooltip forKeyPath:@"value.macroTooltip"];
	[self didChangeValueForKey:@"macroTooltip"];
	[self willChangeValueForKey:@"isEdited"];
	[self didChangeValueForKey:@"isEdited"];
	return;
}
- (BOOL)canEditMacroTooltip;
{
	return YES;
}
- (NSString *)ID;
{
	return [self valueForKeyPath:@"value.ID"];
}
- (NSString *)key;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	element = (NSXMLElement *)[element attributeForName:@"KEY"];
	return [element stringValue];
}
- (void) setKey:(NSString *)newKey;
{
	NSXMLElement * element = [self editableXMLElement];
	NSXMLElement * attribute = (NSXMLElement *)[element attributeForName:@"KEY"];
	if(attribute)
	{
		NSString * oldKey = [attribute stringValue];
		if([oldKey isEqual:newKey])
		{
			return;
		}
		if([newKey length])
		{
			[self willChangeValueForKey:@"key"];
			[attribute setStringValue:newKey];
			[self didChangeValueForKey:@"key"];
		}
	}
	else
	{
		attribute = [NSXMLNode attributeWithName:@"KEY" stringValue:newKey];
		[element addAttribute:attribute];
	}
	[self willChangeValueForKey:@"isEdited"];
	[self didChangeValueForKey:@"isEdited"];
	return;
}
- (NSString *)prettyKey;
{
	return [macroKeyStroke prettyString];
}
- (BOOL)canEditKey;
{
	return YES;
}
- (NSString *)name;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	NSArray * NAMES = [element elementsForName:@"NAME"];
	element = [NAMES lastObject];
	return [element stringValue];
}
- (void)setName:(NSString *) newName;
{
	NSXMLElement * element = [self editableXMLElement];
	NSArray * NAMES = [element elementsForName:@"NAME"];
	NSXMLElement * nameElt = nil;
	if(nameElt = [NAMES lastObject])
	{
		NSString * oldName = [element stringValue];
		if([oldName isEqual:newName])
		{
			return;
		}
		[self willChangeValueForKey:@"name"];
		[nameElt setStringValue:newName];
		[self didChangeValueForKey:@"name"];
	}
	else
	{
		[self willChangeValueForKey:@"name"];
		nameElt = [NSXMLElement elementWithName:@"NAME" stringValue:newName];
		[element insertChild:nameElt atIndex:0];
		[self didChangeValueForKey:@"name"];
	}
	// update the ID automatically, for a default value
	NSString * oldID = [self ID];
	if(![oldID length])
	{
		[self willChangeValueForKey:@"ID"];
		// finding the common ID prefix of all the receivers siblings
		NSMutableArray * children = [[[[self parent] children] mutableCopy] autorelease];
		[children removeObject:self];
		NSEnumerator * E = [children objectEnumerator];
		id child = [E nextObject];
		NSString * common = [child ID];
		if(common)
		{
			while(child = [E nextObject])
			{
				common = [common commonPrefixWithString:[child ID] options:0];
			}
		}
		else
		{
			common = @"";
			NSXMLDocument * macroDocument = [element rootDocument];
			NSString * uri = [macroDocument URI];
			NSURL * url = [NSURL URLWithString:uri];
			if([url isFileURL])
			{
				NSString * path = [url path];
				NSArray * components = [path componentsSeparatedByString:@"Macros.localized"];
				if([components count]>1)
				{
					path = [components lastObject];
					components = [path pathComponents];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = [e nextObject];// @"/"
					component = [e nextObject];// domain: text, pdf, project
					component = [e nextObject];// category: latex, plain, context...
					components = [e allObjects];// everything else
					common = [components componentsJoinedByString:@"-"];
				}
			}
		}
		NSString * newID = [common stringByAppendingString:newName];
		newID = [newID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSXMLNode * IDAttribute = [element attributeForName:@"ID"];
		if(IDAttribute)
		{
			[IDAttribute setStringValue:newID];
		}
		else
		{
			IDAttribute = [NSXMLNode attributeWithName:@"ID" stringValue:newID];
			[element addAttribute:IDAttribute];
		}
		[self takeValue:newID forKeyPath:@"value.ID"];
		[self didChangeValueForKey:@"ID"];
	}
	NSAssert(([[self name] isEqual:newName]),@"ARGH!!!");
	[self willChangeValueForKey:@"isEdited"];
	[self didChangeValueForKey:@"isEdited"];
	return;
}
- (BOOL)canEditName;
{
	return YES;
}
- (BOOL)isEdited;
{
	return [self valueForKeyPath:@"value.editableXMLElement"] != nil;
}
- (id)macroAction;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.editableXMLElement"];
	if(!element)
	{
		element = [self valueForKeyPath:@"value.XMLElement"];
	}
	element = (NSXMLElement *)[element attributeForName:@"SEL"];
	NSString * actionName = element?[element stringValue]:@"insertMacro:";
	return [[iTM2MacroController sharedMacroController] macroActionForName:actionName];
}
- (int)commandModifierState;
{
	return macroKeyStroke->isCommand? NSOnState:NSOffState;
}
- (void)setCommandModifierState:(int)state;
{
	macroKeyStroke->isCommand = (state == NSOnState);
	[self updateKey];
	return;
}
- (int)shiftModifierState;
{
	return macroKeyStroke->isShift? NSOnState:NSOffState;
}
- (void)setShiftModifierState:(int)state;
{
	macroKeyStroke->isShift = (state == NSOnState);
	[self updateKey];
	return;
}
- (int)alternateModifierState;
{
	return macroKeyStroke->isAlternate? NSOnState:NSOffState;
}
- (void)setAlternateModifierState:(int)state;
{
	macroKeyStroke->isAlternate = (state == NSOnState);
	[self updateKey];
	return;
}
- (int)controlModifierState;
{
	return macroKeyStroke->isControl? NSOnState:NSOffState;
}
- (void)setControlModifierState:(int)state;
{
	macroKeyStroke->isControl = (state == NSOnState);
	[self updateKey];
	return;
}
- (int)functionModifierState;
{
	return macroKeyStroke->isFunction? NSOnState:NSOffState;
}
- (void)setFunctionModifierState:(int)state;
{
	macroKeyStroke->isFunction = (state == NSOnState);
	[self updateKey];
	return;
}
- (NSString *)macroKey;
{
	NSString * result = [[NSValueTransformer valueTransformerForName:@"iTM2PrettyNameOfKeyCode"]
							transformedValue:macroKeyStroke->macroKeyCode];
	if([result length])
	{
		return result;
	}
	else
	{
		unichar uniCode = [macroKeyStroke->macroKeyCode unsignedIntValue];
		return [NSString stringWithCharacters:&uniCode length:1];
	}
	return @"";
}
- (void)setMacroKey:(NSString *)macroKey;
{
	NSNumber * reverseTransformedValue = [[NSValueTransformer valueTransformerForName:@"iTM2PrettyNameOfKeyCode"]
							reverseTransformedValue:macroKey];
	if(reverseTransformedValue)
	{
		[self setMacroKeyCode:reverseTransformedValue];
		return;
	}
	if([macroKey length])
	{
		reverseTransformedValue = [NSNumber numberWithUnsignedInt:[macroKey characterAtIndex:0]];
		[self setMacroKeyCode:reverseTransformedValue];
		return;
	}
	[self setMacroKeyCode:nil];
	return;
}
- (NSNumber *)macroKeyCode;
{
	return macroKeyStroke->macroKeyCode;
}
- (void)setMacroKeyCode:(NSNumber *)newCode;
{
	[macroKeyStroke->macroKeyCode release];
	macroKeyStroke->macroKeyCode = [newCode copy];
	[self updateKey];
	return;
}
- (void)updateMacroKeyStroke;
{
	[macroKeyStroke release];
	macroKeyStroke = [[[self key] macroKeyStroke] retain];
	if(!macroKeyStroke)
	{
		macroKeyStroke = [[iTM2MacroKeyStroke alloc] init];
	}
	return;
}
- (void)updateKey;
{
	[macroKeyStroke update];
	[self setKey:[macroKeyStroke string]];
	return;
}
@end

@interface iTM2MacroEditDocumentNode: iTM2MacroEditNode
@end

@implementation iTM2MacroEditDocumentNode
- (void)save;
{
	NSXMLDocument * document = [[self value] objectForKey:@"editableMacrosDocument"];
	NSString * URI = [document URI];
	if([URI length])
	{
		NSURL * url = [NSURL URLWithString:URI];
		if([url isFileURL])
		{
			NSString * directory = [url path];
			directory = [directory stringByDeletingLastPathComponent];
			NSError * localError = nil;
			if([DFM createDeepDirectoryAtPath:directory attributes:nil error:&localError])
			{
				NSData * D = [document XMLDataWithOptions:NSXMLNodePrettyPrint];
				if(![D writeToURL:url options:NSAtomicWrite error:&localError])
				{
					[SDC presentError:localError];
				}
			}
			else
			{
				[SDC presentError:localError];
			}
		}
	}
}
@end

@interface iTM2MacroRunningNode: iTM2MacroEditNode

@end

@implementation iTM2MacroRunningNode

@end

@interface iTM2MacroActionNode: iTM2MacroEditNode

@end

@implementation iTM2MacroActionNode

@end

#import <iTM2Foundation/iTM2RuntimeBrowser.h>

@interface iTM2MacroRootNode: iTM2TreeNode
- (id)objectInChildrenWithDomain:(NSString *)domain;
@end

@implementation iTM2MacroRootNode
- (id)objectInChildrenWithDomain:(NSString *)domain;
{
	return [self objectInChildrenWithValue:domain forKeyPath:@"value.domain"];
}
@end

@interface iTM2MacroDomainNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent domain:(NSString *)domain;
- (id)objectInChildrenWithCategory:(NSString *)category;
@end

@implementation iTM2MacroDomainNode
- (id)initWithParent:(iTM2TreeNode *)parent domain:(NSString *)domain;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:domain forKeyPath:@"value.domain"];
	}
	return self;
}
- (id)objectInChildrenWithCategory:(NSString *)category;
{
	return [self objectInChildrenWithValue:category forKeyPath:@"value.category"];
}
@end

@interface iTM2MacroCategoryNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent category:(NSString *)category;
- (id)objectInChildrenWithContext:(NSString *)context;
@end

@implementation iTM2MacroCategoryNode
- (id)initWithParent:(iTM2TreeNode *)parent category:(NSString *)category;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:category forKeyPath:@"value.category"];
	}
	return self;
}
- (id)objectInChildrenWithContext:(NSString *)context;
{
	return [self objectInChildrenWithValue:context forKeyPath:@"value.context"];
}
@end

@interface iTM2MacroContextNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent context:(NSString *)context;
- (id)objectInChildrenWithID:(NSString *)ID;
@end

@implementation iTM2MacroContextNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent context:(NSString *)context;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:context forKeyPath:@"value.context"];
	}
	return self;
}
- (id)objectInChildrenWithID:(NSString *)ID;
{
	return [self objectInChildrenWithValue:ID forKeyPath:@"value.ID"];
}
@end

@interface iTM2MacroLeafNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent ID:(NSString *)ID element:(NSXMLElement *)element;
- (NSString *)name;
- (SEL)action;
- (NSString *)argument;
- (NSString *)description;
- (NSString *)tooltip;
@end

@implementation iTM2MacroLeafNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent ID:(NSString *)ID element:(NSXMLElement *)element;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:ID forKeyPath:@"value.ID"];
		[self setValue:element forKeyPath:@"value.element"];
	}
	return self;
}
- (NSString *)description;
{
	return [NSString stringWithFormat:@"%@(%@)",[super description],[self valueForKeyPath:@"value.ID"]];
}
- (NSString *)name;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"NAME" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no name.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"No name available";
	}
}
- (NSString *)macroDescription;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"DESC" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no description.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"No description available";
	}
}
- (NSString *)tooltip;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"TIP" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no tooltip.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"No name tooltip";
	}
}
- (SEL)action;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
	NSXMLNode * node = [element attributeForName:@"SEL"];
	if(node)
	{
		return NSSelectorFromString([node stringValue]);
	}
	else
	{
		return NULL;
	}
}
- (NSString *)argument;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"ARG" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no arguments.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return nil;
	}
}
@end

@interface iTM2MacroMenuNode: iTM2MacroContextNode
@end

@implementation iTM2MacroMenuNode
@end

@implementation iTM2MacroController

static id _iTM2MacroController = nil;

+ (id)sharedMacroController;
{
	return _iTM2MacroController?:( _iTM2MacroController = [[self alloc] init]);
}

- (id)init;
{
	if(_iTM2MacroController)
	{
		return [_iTM2MacroController retain];
	}
	else if(self = [super init])
	{
		[self setRunningTree:nil];
		[self setValue:nil forKey:@"sourceTree"];// dirty trick to avoid header declaration
	}
	return _iTM2MacroController = self;
}

- (id)runningTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	// Create a Macros.localized in the Application\ Support folder as side effect
	[[NSBundle mainBundle] pathForSupportDirectory:@"Macros.localized" inDomain:NSUserDomainMask create:NO];
	iTM2MacroRootNode * rootNode = [[[iTM2MacroRootNode alloc] init] autorelease];// this will be retained
	// list all the *.iTM2-macros files
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:@"Macros" ofType:@"localized"];
	NSEnumerator * E = [RA objectEnumerator];
	NSString * repository = nil;
	NSURL * repositoryURL = nil;
	NSDirectoryEnumerator * DE = nil;
	NSString * subpath = nil;
	while(repository = [E nextObject])
	{
		if([DFM pushDirectory:repository])
		{
			repositoryURL = [NSURL fileURLWithPath:repository];
			DE = [DFM enumeratorAtPath:repository];
			while(subpath = [DE nextObject])
			{
				NSString * extension = [subpath pathExtension];
				if([extension isEqual:@"iTM2-macros"])
				{
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroDomainNode * domainNode = nil;
					iTM2MacroCategoryNode * categoryNode = nil;
					iTM2MacroContextNode * contextNode = nil;
					if(component = [e nextObject])
					{
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						if(component = [e nextObject])
						{
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							if(component = [e nextObject])
							{
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
							}
							else
							{
								component = @"";
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
							}
						}
						else
						{
							component = @"";
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							contextNode = [categoryNode objectInChildrenWithContext:component]?:
									[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
						}
					}
					else
					{
						component = @"";
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						categoryNode = [domainNode objectInChildrenWithCategory:component]?:
								[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
						contextNode = [categoryNode objectInChildrenWithContext:component]?:
								[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
					}
					NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
					NSError * localError =  nil;
					NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
					if(localError)
					{
						iTM2_LOG(@"The macro file might be corrupted at\n%@", url);
					}
					else
					{
						// now create the children
						e = [[document nodesForXPath:@"//ACTION" error:&localError] objectEnumerator];
						NSXMLElement * element = nil;
						while(element = [e nextObject])
						{
							[element detach];// no longer belongs to the document
							NSString * ID = [[element attributeForName:@"ID"] stringValue];
							iTM2MacroLeafNode * child = (iTM2MacroLeafNode *)[contextNode objectInChildrenWithID:ID];
							if(!child)
							{
								//iTM2MacroLeafNode * node = 
								[[[iTM2MacroLeafNode alloc] initWithParent:contextNode ID:ID element:element] autorelease];
							}
						}
					}
				}
			}
			[DFM popDirectory];
		}
	}
	metaSETTER(rootNode);
	return rootNode;
}

- (void)setRunningTree:(id)aTree;
{
	id old = metaGETTER;
	if([old isEqual:aTree] || (old == aTree))
	{
		return;
	}
	metaSETTER(aTree);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroRunningNodeForID:context:ofCategory:inDomain:
- (id)macroRunningNodeForID:(NSString *)ID context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroRootNode * rootNode = [self runningTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	iTM2MacroCategoryNode * categoryNode = [domainNode objectInChildrenWithCategory:category];
	iTM2MacroContextNode * contextNode = [categoryNode objectInChildrenWithContext:context];
	iTM2MacroLeafNode * leafNode = [contextNode objectInChildrenWithID:ID];
	if(!leafNode)
	{
		iTM2_LOG(@"No macro with ID: %@ forContext:%@ ofCategory:%@ inDomain:%@",ID,context,category,domain);
	}
//iTM2_END;
	return leafNode;
}
- (id)menuTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	// Create a Macros.localized in the Application\ Support folder as side effect
	[[NSBundle mainBundle] pathForSupportDirectory:@"Macros.localized" inDomain:NSUserDomainMask create:NO];
	iTM2MacroRootNode * rootNode = [[[iTM2MacroRootNode alloc] init] autorelease];// this will be retained
	// list all the *.iTM2-macros files
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:@"Macros" ofType:@"localized"];
	NSEnumerator * E = [RA objectEnumerator];
	NSString * repository = nil;
	NSURL * repositoryURL = nil;
	NSDirectoryEnumerator * DE = nil;
	NSString * subpath = nil;
	while(repository = [E nextObject])
	{
		if([DFM pushDirectory:repository])
		{
			repositoryURL = [NSURL fileURLWithPath:repository];
			DE = [DFM enumeratorAtPath:repository];
			while(subpath = [DE nextObject])
			{
				NSString * extension = [subpath pathExtension];
				if([extension isEqual:@"iTM2-menu"])
				{
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroDomainNode * domainNode = nil;
					iTM2MacroCategoryNode * categoryNode = nil;
					// for menus there are only two levels
					// no level for the context depth
					if(component = [e nextObject])
					{
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						if(component = [e nextObject])
						{
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
						}
						else
						{
							component = @"";
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							if(component = [E nextObject])
							{
								component = [subpath lastPathComponent];
								component = [component stringByDeletingPathExtension];
							}
						}
					}
					else
					{
						component = @"";
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						categoryNode = [domainNode objectInChildrenWithCategory:component]?:
								[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
					}
					component = [subpath lastPathComponent];
					component = [component stringByDeletingPathExtension];
					iTM2MacroMenuNode * menuNode = [categoryNode objectInChildrenWithContext:component];
					if(!menuNode)
					{
						iTM2MacroMenuNode * menuNode = [[[iTM2MacroMenuNode alloc] initWithParent:categoryNode context:component] autorelease];
						NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
						[menuNode setValue:url forKeyPath:@"value.URL"];
					}
				}
			}
			[DFM popDirectory];
		}
	}
	metaSETTER(rootNode);
	return rootNode;
}

- (void)setMenuTree:(id)aTree;
{
	id old = metaGETTER;
	if([old isEqual:aTree] || (old == aTree))
	{
		return;
	}
	metaSETTER(aTree);
	return;
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuForContext:ofCategory:inDomain:error:
- (NSMenu *)macroMenuForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroRootNode * rootNode = [self menuTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	iTM2MacroCategoryNode * categoryNode = [domainNode objectInChildrenWithCategory:category];
	iTM2MacroMenuNode * menuNode = [categoryNode objectInChildrenWithContext:context];
	NSMenu * M = [menuNode valueForKeyPath:@"value.menu"];
	if(!M)
	{
		NSURL * url = [menuNode valueForKeyPath:@"value.URL"];
		if(url)
		{
			NSError * localError = nil;
			NSXMLDocument * xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
			if(localError)
			{
				[SDC presentError:localError];
			}
			M = [self macroMenuWithXMLElement:[xmlDoc rootElement] forContext:context ofCategory:category inDomain:domain error:&localError];
			[menuNode setValue:M forKeyPath:@"value.menu"];
		}
	}
//iTM2_END;
	return M;
}

#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuWithXMLElement:forContext:ofCategory:inDomain:error:
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = [element name];
	if([name isEqualToString:@"MENU"])
	{
		NSString * prefix = [[element attributeForName:@"ID"] stringValue];
		if(!prefix)
			prefix = @"";
		if([element childCount])
		{
			NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
			id child = [element childAtIndex:0];
			do
			{
				NSMenuItem * MI = [self macroMenuItemWithXMLElement:child forContext:context ofCategory:category inDomain:domain error:outError];
				if(MI)
					[M addItem:MI];
			}
			while(child = [child nextSibling]);
			return M;
		}
	}
	else if(element)
	{
		iTM2_LOG(@"ERROR: unknown name %@.", name);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuItemWithXMLElement:forContext:ofCategory:inDomain:error:
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = [element name];
	if([name isEqualToString:@"SEP"])
	{
		return [NSMenuItem separatorItem];
	}
	else if([name isEqualToString:@"ITEM"])
	{
		NSString * ID = [[element attributeForName:@"ID"] stringValue];
		iTM2MacroLeafNode * leafNode = [[iTM2MacroController sharedMacroController] macroRunningNodeForID:ID context:context ofCategory:category inDomain:domain];
		name = [leafNode name];
		if(!leafNode)
		{
			name = ID;
		}
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
			initWithTitle:name action:NULL keyEquivalent: @""] autorelease];
		if([ID length])
		{
			[MI setRepresentedObject:[NSArray arrayWithObjects:ID, context, category, domain, nil]];
			SEL action = [leafNode action];
			[MI setAction:(!leafNode || action == @selector(noop:) || !action && ![leafNode argument]?@selector(___catch:):@selector(___insertMacro:))];
			[MI setTarget:self];
		}
		[MI setToolTip:[leafNode tooltip]];
		id submenuList = [[element elementsForName:@"MENU"] lastObject];
		NSMenu * M = [self macroMenuWithXMLElement:submenuList forContext:context ofCategory:category inDomain:domain error:outError];
		[MI setSubmenu:M];
		return MI;
	}
	else
	{
		iTM2_LOG(@"ERROR: unknown name %@.", name);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
- (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:20], @"iTM2NumberOfRecentMacros", nil]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___catch:
- (void)___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___catch:
- (BOOL)validate___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___insertMacro:
- (void)___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && [RA count])
	{
		NSString * ID = [RA objectAtIndex:0];
		NSString * context;
		NSString * category;
		NSString * domain;
		if([RA count] > 3)
		{
			context = [RA objectAtIndex:1];
			category = [RA objectAtIndex:2];
			domain = [RA objectAtIndex:3];
		}
		else
		{
			context = @"";
			if([RA count] > 2)
			{
				category = [RA objectAtIndex:1];
				domain = [RA objectAtIndex:2];
			}
			else
			{
				category = @"";
				if([RA count] > 1)
				{
					context = @"";
					domain = [RA objectAtIndex:1];
				}
				else
				{
					domain = @"";
				}
			}
		}
		if([ID length])
		{
			[[iTM2MacroController sharedMacroController] executeMacroWithID:ID forContext:context ofCategory:category inDomain:domain];
			NSMenu * recentMenu = [self macroMenuForContext:context ofCategory:@"Recent" inDomain:domain error:nil];
			int index = [recentMenu indexOfItemWithTitle:[sender title]];
			if(index!=-1)
			{
				[recentMenu removeItemAtIndex:index];
			}
			NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle:[sender title] action:[sender action] keyEquivalent:@""] autorelease];
			[MI setTarget:self];
			[MI setRepresentedObject:RA];
			[recentMenu insertItem:MI atIndex:1];
			NSMutableDictionary * MD = [NSMutableDictionary dictionary];
			index = 0;
			int max = [SUD integerForKey:@"iTM2NumberOfRecentMacros"];
			while([recentMenu numberOfItems] > max)
			{
				[recentMenu removeItemAtIndex:[recentMenu numberOfItems]-1];
			}
			while(++index < [recentMenu numberOfItems])
			{ 
				MI = [recentMenu itemAtIndex:index];
				RA = [MI  representedObject];
				if(RA)
				{
					[MD setObject:RA forKey:[MI title]];
				}
			}
			[SUD setObject:MD forKey:[NSString pathWithComponents:[NSArray arrayWithObjects:@"", @"Recent", domain, nil]]];
		}
	}
	else if(RA)
	{
		iTM2_LOG(@"Unknown design [sender representedObject]:%@", RA);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___insertMacro:
- (BOOL)validate___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && ([RA count] > 2))
	{
		NSString * ID = [RA objectAtIndex:0];
		if([ID length])
			return YES;
	}
//iTM2_END;
    return [sender hasSubmenu];
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithID:forContext:ofCategory:inDomain:
- (BOOL)executeMacroWithID:(NSString *)ID forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroLeafNode * leafNode = [self macroRunningNodeForID:ID context:context ofCategory:category inDomain:domain];
	SEL action = [leafNode action];
	if(!action)
	{
		action = NSSelectorFromString(@"insertMacro:");
	}
	id argument = [leafNode argument];
	if(argument)
	{
		if([[[NSApp keyWindow] firstResponder] tryToPerform:action with:argument]
			|| [[[NSApp mainWindow] firstResponder] tryToPerform:action with:argument])
		{
			return YES;
		}
		else
		{
			iTM2_LOG(@"No target for %@ with argument %@", NSStringFromSelector(action), argument);
		}
	}
	if([[[NSApp keyWindow] firstResponder] tryToPerform:action with:nil]
		|| [[[NSApp mainWindow] firstResponder] tryToPerform:action with:nil])
	{
		return YES;
	}
	else
	{
		iTM2_LOG(@"No target for %@ with no argument", NSStringFromSelector(action));
	}
//iTM2_END;
    return NO;
}

@end

@implementation iTM2GenericScriptButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= domain
+ (NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"Text";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= category
+ (NSString *)category;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"LaTeX";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= menu
+ (NSMenu *)menu;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = NSStringFromClass(self);
	NSRange R1 = [name rangeOfString:@"Script"];
	if(R1.length)
	{
		NSRange R2 = [name rangeOfString:@"Button"];
		if(R2.length && (R1.location += R1.length, (R2.location > R1.location)))
		{
			R1.length = R2.location - R1.location;
			NSString * context = [name substringWithRange:R1];
			NSString * category = [self category];
			NSString * domain = [self domain];
			NSMenu * M = [[iTM2MacroController sharedMacroController] macroMenuForContext:context ofCategory:category inDomain:domain error:nil];
			M = [[M deepCopy] autorelease];
			// insert a void item for the title
			[M insertItem:[[[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""] autorelease] atIndex:0];// for the title
			return M;
		}
	}
//iTM2_END;
    return [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[iTM2GenericScriptButton superclass] instancesRespondToSelector:_cmd])
		[super awakeFromNib];
	[[self retain] autorelease];
	NSView * superview = [self superview];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self];
	[self setMenu:[[self class] menu]];
	[[self cell] setAutoenablesItems:YES];
//iTM2_END;
    return;
}
@end

#pragma mark -

@interface iTM2PrettyNameOfKeyCodeTransformer: NSValueTransformer
@end

@interface iTM2PrettyNamesOfKeyCodesTransformer: NSValueTransformer
@end

@interface iTM2MacroController(EDIT)
/*!
    @method     sourceTree
    @abstract   The macro source tree
    @discussion Lazy initializer.
    @result     The macro source tree
*/
- (id)sourceTree;

/*!
    @method     setSourceTree:
    @abstract   Set the macro source tree
    @discussion Designated setter.
    @param      aTree
    @result     None
*/
- (void)setSourceTree:(id)aTree;

@end

@implementation iTM2MacroController(EDIT)

- (id)sourceTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	// Create a Macros.localized in the Application\ Support folder as side effect
	[[NSBundle mainBundle] pathForSupportDirectory:@"Macros.localized" inDomain:NSUserDomainMask create:YES];
	iTM2MacroEditNode * root = [[[iTM2MacroEditNode alloc] init] autorelease];// this will be retained
	// list all the *.iTM2-macros files
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:@"Macros" ofType:@"localized"];
	NSEnumerator * E = [RA objectEnumerator];
	NSString * repository = nil;
	NSURL * repositoryURL = nil;
	NSDirectoryEnumerator * DE = nil;
	NSString * subpath = nil;
	// the first repository corresponds to the Application\ Support
	// it is treated specifically because it is editable
	if(repository = [E nextObject])
	{
		if([DFM pushDirectory:repository])
		{
			repositoryURL = [NSURL fileURLWithPath:repository];
			DE = [DFM enumeratorAtPath:repository];
			while(subpath = [DE nextObject])
			{
				NSString * extension = [subpath pathExtension];
				if([extension isEqual:@"iTM2-macros"])
				{
					NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
					iTM2MacroEditNode * currentNode = root;
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroEditNode * node = nil;
					while(component = [e nextObject])
					{
						if(node = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.pathComponent"])
						{
							currentNode = node;
						}
						else
						{
							currentNode = [[[iTM2MacroEditNode alloc] initWithParent:currentNode] autorelease];
							[currentNode setValue:component forKeyPath:@"value.pathComponent"];
						}
					}
					component = [subpath lastPathComponent];
					if(node = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.pathComponent"])
					{
						currentNode = node;
					}
					else
					{
						currentNode = [[[iTM2MacroEditDocumentNode alloc] initWithParent:currentNode] autorelease];
						[currentNode setValue:component forKeyPath:@"value.pathComponent"];
					}
					// currentNode is now the last node of this tree path
					// it represents a document
					NSError * localError =  nil;
					NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
					if(localError)
					{
						iTM2_LOG(@"The macro file might be corrupted at\n%@", url);
					}
					else
					{
						[[currentNode value] setObject:document forKey:@"editableMacrosDocument"];
						// now create the children
						e = [[document nodesForXPath:@"//ACTION" error:&localError] objectEnumerator];
						NSXMLElement * element = nil;
						while(element = [e nextObject])
						{
							NSString * attribute = [[element attributeForName:@"ID"] stringValue];
							attribute = [attribute stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
							iTM2MacroSourceLeafNode * node = [[[iTM2MacroSourceLeafNode alloc] initWithParent:currentNode] autorelease];
							[node setValue:attribute forKeyPath:@"value.ID"];
							[node setValue:element forKeyPath:@"value.editableXMLElement"];
							[node updateMacroKeyStroke];
						}
					}
				}
			}
			[DFM popDirectory];
		}
	}
	// the other repositories are treated differently
	while(repository = [E nextObject])
	{
		if([DFM pushDirectory:repository])
		{
			repositoryURL = [NSURL fileURLWithPath:repository];
			DE = [DFM enumeratorAtPath:repository];
			while(subpath = [DE nextObject])
			{
				NSString * extension = [subpath pathExtension];
				if([extension isEqual:@"iTM2-macros"])
				{
					iTM2MacroEditNode * currentNode = root;
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroEditNode * node = nil;
					while(component = [e nextObject])
					{
						if(node = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.pathComponent"])
						{
							currentNode = node;
						}
						else
						{
							currentNode = [[[iTM2MacroEditNode alloc] initWithParent:currentNode] autorelease];
							[currentNode setValue:component forKeyPath:@"value.pathComponent"];
						}
					}
					component = [subpath lastPathComponent];
					if(node = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.pathComponent"])
					{
						currentNode = node;
					}
					else
					{
						currentNode = [[[iTM2MacroEditDocumentNode alloc] initWithParent:currentNode] autorelease];
						[currentNode setValue:component forKeyPath:@"value.pathComponent"];
					}
					// currentNode is now the last node of this tree path
					NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
					NSError * localError =  nil;
					NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
					if(localError)
					{
						iTM2_LOG(@"The macro file might be corrupted at\n%@", url);
					}
					else
					{
						NSMutableArray * MRA = [currentNode objectInChildrenWithValue:component forKeyPath:@"value.otherMacrosDocuments"];
						if(!MRA)
						{
							MRA = [NSMutableArray array];
							[currentNode setValue:MRA forKeyPath:@"value.otherMacrosDocuments"];
							[currentNode setValue:subpath forKeyPath:@"value.macrosDocumentsPath"];
						}
						[MRA addObject:document];
						// now create the children
						e = [[document nodesForXPath:@"//ACTION" error:&localError] objectEnumerator];
						NSXMLElement * element = nil;
						while(element = [e nextObject])
						{
							NSString * attribute = [[element attributeForName:@"ID"] stringValue];
							iTM2MacroSourceLeafNode * child = (iTM2MacroSourceLeafNode *)[currentNode objectInChildrenWithValue:attribute forKeyPath:@"value.ID"];
							if(!child)
							{
								iTM2MacroSourceLeafNode * node = [[[iTM2MacroSourceLeafNode alloc] initWithParent:currentNode] autorelease];
								[node setValue:attribute forKeyPath:@"value.ID"];
								[node setValue:element forKeyPath:@"value.XMLElement"];
								[node updateMacroKeyStroke];
							}
						}
					}
				}
			}
			[DFM popDirectory];
		}
	}
	metaSETTER(root);
	return root;
}

- (void)setSourceTree:(id)aTree;
{
	id old = metaGETTER;
	if([old isEqual:aTree] || (old == aTree))
	{
		return;
	}
	[self willChangeValueForKey:@"sourceTree"];
	metaSETTER(aTree);
	[self didChangeValueForKey:@"sourceTree"];
	[self setRunningTree:nil];
	return;
}

#if 0
static id SORT_DESCRIPTORS = nil;
#undef metaGETTER
#undef metaSETTER
#define metaGETTER SORT_DESCRIPTORS
#define metaSETTER(NEW)\
[SORT_DESCRIPTORS release];SORT_DESCRIPTORS = [NEW retain]
#endif
- (NSArray *)sortDescriptors;
{
	id result = metaGETTER;
	return result;
}

- (void)setSortDescriptors:(NSArray *)sortDescriptors;
{
	[self willChangeValueForKey:@"sortDescriptors"];
	metaSETTER(sortDescriptors);
	[self didChangeValueForKey:@"sortDescriptors"];
	return;
}

#if 0
static id MACRO_ACTIONS = nil;
#undef metaGETTER
#undef metaSETTER
#define metaGETTER SORT_DESCRIPTORS
#define metaSETTER(NEW)\
[SORT_DESCRIPTORS release];SORT_DESCRIPTORS = [NEW retain]
#endif
- (NSArray *)macroActions;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	result = [NSMutableArray array];
	NSArray * RA = [iTM2RuntimeBrowser subclassReferencesOfClass:[iTM2MacroAction class]];
	NSEnumerator * E = [RA objectEnumerator];
	Class subclass = Nil;
	while(subclass = [[E nextObject] nonretainedObjectValue])
	{
		id macroAction = [[[subclass allocWithZone:[self zone]] init] autorelease];
		if([[macroAction description] length])
		{
			[result addObject:macroAction];
		}
	}
	[result sortUsingSelector:@selector(compareUsingDescription:)];
	metaSETTER(result);
	return metaGETTER;
}

- (id)macroActionForName:(NSString *)actionName
{
	SEL expectedAction = NSSelectorFromString(actionName);
	NSEnumerator * E = [[self macroActions] objectEnumerator];
	iTM2MacroAction * macroAction = nil;
	while(macroAction = [E nextObject])
	{
		if(expectedAction == [macroAction action])
		{
			break;
		}
	}
	return macroAction;
}
- (NSArray *)macroKeyCodes;
{
	id MFKs = metaGETTER;
	if(MFKs)
	{
		return MFKs;
	}
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:@"iTM2MacroKeyCodes" ofType:@"xml"];
	if([RA count])
	{
		NSString * path = [RA objectAtIndex:0];
		NSURL * url = [NSURL fileURLWithPath:path];
		NSError * localError = nil;
		NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
		if(localError)
		{
			[SDC presentError:localError];
		}
		else
		{
			NSArray * nodes = [doc nodesForXPath:@"/*/KEY" error:&localError];
			if(localError)
			{
				[SDC presentError:localError];
			}
			else
			{
				NSEnumerator * E = [nodes objectEnumerator];
				MFKs = [NSMutableArray array];
				metaSETTER(MFKs);
				id node = nil;
				while(node = [E nextObject])
				{
					NSString * CODE = [node stringValue];
					if([CODE length])
					{
						NSScanner * scanner = [NSScanner scannerWithString:CODE];
						unsigned int code = 0;
						[scanner scanHexInt:&code] || [scanner scanInt:(int *)&code];
						NSNumber * N = [NSNumber numberWithUnsignedInt:code];
						if(![MFKs containsObject:N])
						{
							[MFKs addObject:N];
						}
					}
				}
			}
		}
	}
	return MFKs;
}
- (NSString *)prettyNameForKeyCode:(NSNumber *) keyCode;
{
	int intCode = [keyCode intValue];
	NSString * key = [NSString stringWithFormat:(intCode>0xFF?@"%#x":@"%0#4x"),intCode];
	key = [key lowercaseString];
	NSString * result = NSLocalizedStringWithDefaultValue(key, @"iTM2MacroKeyCodes", [NSBundle bundleForClass:[self class]], @"NO LOCALIZATION", "");
	if(![result isEqual:@"NO LOCALIZATION"])
	{
		return result;
	}
	unichar uniCode = intCode;
	result = [NSString stringWithCharacters:&uniCode length:1];
	if([result length])
	{
		return result;
	}
	return key;
}
- (void)save:(id)sender;
{
	[[self sourceTree] save];
}
@end

@interface iTM2MacroTreeController: NSTreeController
+ (id)sharedMacroTreeController;
@end

@interface iTM2MacroKeyEquivalentWindow: NSWindow
@end

@implementation iTM2MacroKeyEquivalentWindow
- (BOOL)canBecomeKeyWindow;
{
	return YES;
}
- (void)keyDown:(NSEvent *)theEvent
{
	unsigned int modifierFlags = [theEvent modifierFlags];
	NSControl * C = nil;
	if(modifierFlags & NSCommandKeyMask)
	{
		C = [[self contentView] viewWithTag:1];
		[C performClick:theEvent];
	}
	if(modifierFlags & NSShiftKeyMask)
	{
		C = [[self contentView] viewWithTag:2];
		[C performClick:theEvent];
	}
	if(modifierFlags & NSAlternateKeyMask)
	{
		C = [[self contentView] viewWithTag:3];
		[C performClick:theEvent];
	}
	if(modifierFlags & NSControlKeyMask)
	{
		C = [[self contentView] viewWithTag:4];
		[C performClick:theEvent];
	}
	if(modifierFlags & NSFunctionKeyMask)
	{
		C = [[self contentView] viewWithTag:5];
		[C performClick:theEvent];
	}
	return;
}
@end

@interface iTM2MacroOutlineView: NSOutlineView
{
@private
	NSView * _KeyEquivalentView;
}
@end

@implementation iTM2MacroOutlineView
- (void)awakeFromNib;
{
	if([[self superclass] instancesRespondToSelector:_cmd])
	{
		[(id)super awakeFromNib];
	}
	[_KeyEquivalentView retain];
	// resize the columns to have the key column visible;
	// get the size of the view
	[self setAutosaveExpandedItems:YES];
	NSScrollView * ESV = [self enclosingScrollView];
	float W = [ESV documentVisibleRect].size.width;
	NSTableColumn * TC1 = [self tableColumnWithIdentifier:@"Name"];
	NSTableColumn * TC2 = [self tableColumnWithIdentifier:@"Key"];
//	NSTableColumn * TC3 = [self tableColumnWithIdentifier:@"ID"];
	if(W<=[TC1 width])
	{
		// the Key column is not visible
		if(W>[TC2 width])
		{
			W -= [TC2 width];
			[TC1 setWidth:W];
			[self sizeToFit];
		}
	}
	return;
}
- (void)dealloc;
{
	[_KeyEquivalentView release];
	[super dealloc];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseDown:
- (void)mouseDown:(NSEvent * )event
/*"Description Forthcoming
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    if([event clickCount]>1)
    {
//NSLog(@"[event clickCount]: %i", [event clickCount]);
        [super mouseDown:event];
		if([self isEqual:[[self window] firstResponder]])
		{
			NSPoint P = [event locationInWindow];
			P = [self convertPoint:P fromView:nil];
			int clickedColumn = [self columnAtPoint:P];
			NSTableColumn * clickedTableColumn = [[self tableColumns] objectAtIndex:clickedColumn];
			NSTableColumn * OTC = [self outlineTableColumn];
			if([OTC isEqual:clickedTableColumn])
			{
				int clickedRow = [self rowAtPoint:P];
				id clickedItem = [self itemAtRow:clickedRow];
				if(![self isExpandable:clickedItem])
				{
					[self editColumn:clickedColumn row:clickedRow withEvent:event select:NO];
				}
			}
		}
    }
    else
        [super mouseDown:event];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editColumn:row:withEvent:select:
- (void)editColumn:(int)column row:(int)row withEvent:(NSEvent *)theEvent select:(BOOL)select;
/*"Description Forthcoming
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
	int keyColumn = [self columnWithIdentifier:@"Key"];
	if(keyColumn == column)
	{
		NSRect contentRect = [_KeyEquivalentView frame];
		NSRect cellFrame = [self frameOfCellAtColumn:column row:row];
		cellFrame = [self convertRect:cellFrame toView:nil];
		cellFrame.origin = [[self window] convertBaseToScreen:cellFrame.origin];
		cellFrame.size = contentRect.size;
		// create the window
		NSWindow * W = [[iTM2MacroKeyEquivalentWindow alloc] initWithContentRect:cellFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
		NSView * oldContentView = [W contentView];
		[W setContentView:_KeyEquivalentView];
		[W setLevel:NSModalPanelWindowLevel];
		[W setHasShadow:YES];
		[[self window] addChildWindow:W ordered:NSWindowAbove];
//		[W setFrameOrigin:cellFrame.origin];
//		[W setFrameTopLeftPoint:aPoint];
		[W makeKeyAndOrderFront:self];
		[NSApp runModalForWindow:W];
		[[self window] removeChildWindow:W];
		[W setContentView:oldContentView];
		[W release];
	}
	else
	{
		[super editColumn:(int)column row:(int)row withEvent:(NSEvent *)theEvent select:(BOOL)select];
	}
    return;
}
- (void)stopKeyEditing:(id)sender;
{
	[NSApp stopModalWithCode:0];
	return;
}
@end

#import "iTM2PreferencesKit.h"
#import "iTeXMac2.h"

@interface iTM2MacroPrefPane: iTM2PreferencePane
@end

@implementation iTM2MacroPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"3.Macro";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willUnselect
- (void)willUnselect;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super willUnselect];
    return;
}
@end

@implementation iTM2MacroTreeController

+ (void)initialize
{
	[super initialize];
    iTM2PrettyNameOfKeyCodeTransformer *transformer = [[[iTM2PrettyNameOfKeyCodeTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer:transformer forName:@"iTM2PrettyNameOfKeyCode"];
    iTM2PrettyNamesOfKeyCodesTransformer *transformers = [[[iTM2PrettyNamesOfKeyCodesTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer:transformers forName:@"iTM2PrettyNamesOfKeyCodes"];
	return;
}

static id _iTM2MacroTreeController = nil;

+ (id)sharedMacroTreeController;
{
	return _iTM2MacroTreeController?:( _iTM2MacroTreeController = [[self alloc] init]);
}

- (id)init;
{
	if(_iTM2MacroTreeController)
	{
		return [_iTM2MacroTreeController retain];
	}
	else if(self = [super init])
	{
	}
	return _iTM2MacroTreeController = self;
}
- (void)awakeFromNib;
{// the + button is not up to date, force the UI widget bound to canIinsert to be updated
	[self willChangeValueForKey:@"canInsert"];
	[self didChangeValueForKey:@"canInsert"];
	return;
}
#if 0
- (void)add:(id)sender;
{
	id selection = [self selection];
	return;
}
- (void)remove:(id)sender;
{
	id selection = [self selection];
	return;
}
- (void)insert:(id)sender;
{
	id selection = [self selection];
	return;
}
- (BOOL)canInsert;
- (BOOL)canInsertChild;
- (BOOL)canAddChild;
#endif
@end

@implementation iTM2PrettyNamesOfKeyCodesTransformer
+ (Class)transformedValueClass { return [NSArray class]; }
+ (BOOL)allowsReverseTransformation { return YES; }
- (id)transformedValue:(id)value;
{
	if([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * transformedValue = [NSMutableArray array];
		NSEnumerator * E = [value objectEnumerator];
		id N = nil;
		while(N = [E nextObject])
		{
			[transformedValue addObject:((N = [SMC prettyNameForKeyCode:N])?N:[NSNull null])];
		}
		return transformedValue;
	}
    return nil;
}
- (id)reverseTransformedValue:(id)value;
{
	if([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * reverseTransformedValue = [NSMutableArray array];
		NSEnumerator * e = [value objectEnumerator];
		NSString * name = nil;
		while(name = [e nextObject])
		{
			NSEnumerator * E = [[SMC macroKeyCodes] objectEnumerator];
			NSNumber * N = nil;
			while(N = [E nextObject])
			{
				if([name isEqual:[SMC prettyNameForKeyCode:N]])
				{
					[reverseTransformedValue addObject:N];
					break;
				}
			}
		}
	}
    return nil;
}
@end

@implementation iTM2PrettyNameOfKeyCodeTransformer
+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return YES; }
- (id)transformedValue:(id)value;
{
	if([value isKindOfClass:[NSNumber class]])
	{
		return [SMC prettyNameForKeyCode:value];
	}
    return nil;
}
- (id)reverseTransformedValue:(id)value;
{
	if([value isKindOfClass:[NSString class]])
	{
		NSEnumerator * E = [[SMC macroKeyCodes] objectEnumerator];
		NSNumber * N = nil;
		while(N = [E nextObject])
		{
			if([value isEqual:[SMC prettyNameForKeyCode:N]])
			{
				return N;
			}
		}
	}
    return nil;
}
@end
