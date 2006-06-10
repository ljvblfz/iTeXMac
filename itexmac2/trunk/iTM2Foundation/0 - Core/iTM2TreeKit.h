/*
//  iTM2TreeKit.h
//  iTeXMac2
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat May 24 2003.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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
//  Version history:(format "- date:contribution(contributor)") 
//  To Do List:(format "- proposition(percentage actually done)")
*/

#import <Foundation/Foundation.h>

/*! 
	@class		iTM2TreeNode 
	@abstract	Leafs of a tree wrapping an ordered hierarchical dada structure. 
	@discussion	The purpose of iTM2TreeNode is first to model the simplest tree hierarchy.
				It is the direct data model for a NSTreeController.
				Each tree item may have a parent which it belongs to, and an array of child items.
				A Tree Item with no parent is the root of the tree,
				Of course, a Tree Item is meant to be a child item of its parent if any.
				The Parent retains its children but the child just points to its parent to avoid infinite retain loops.
				The hierarchy of Tree Items is meant to reflect some hierarchical data model.
				Each Tree Item points to some leaf data in this hierarchy through its value instance variable
				and the child items reflect the structure of this data, namely an array or a dictionary
				(I don't think of anything else but things should not be limited to those two cases).
				The main problem is to keep the data model and the Tree Item in synchronization,
				this will be achieved by the Data Controller through various means.
				Different Tree Items will have different Data Controllers.
				Data Controllers are a mean to expand an object somehow like delegation.
				Another problem linked to Tree Models must be avoided consists in circular reference.
				More precisely, if an item retains its parent ant the parent retains its children,
				a careless design can lead to never deallocated objects.
*/

@interface iTM2TreeNode: NSObject
{
@private
	id _Parent;
	id _Value;
	id _NonRetainedValue;
	id _Children;
}

/*!
	@method		initWithParent:value:
	@abstract	Initializer.
	@discussion	Discussion forthcoming.
	@result		An object.
*/
- (id)initWithParent:(id)aParent value:(id)anObject;

/*!
	@method		initWithParent:retainedValue:
	@abstract	Initializer.
	@discussion	Discussion forthcoming.
	@result		An object.
*/
- (id) initWithParent:(id)aParent nonRetainedValue:(id)anObject;

/*!
	@method		parent
	@abstract	The parent.
	@discussion	Not retained by the receiver.
	@result		A node.
*/
- (id) parent;

/*!
	@method		setParent:
	@abstract	set the value.
	@discussion	Not retained by the receiver.
	@result		None.
*/
- (void) setParent:(id)aNode;

/*!
	@method		value
	@abstract	The retained represented object.
	@discussion	Retained by the receiver.
	@result		An object.
*/
- (id)value;

/*!
	@method		setValue:
	@abstract	set the value.
	@discussion	Put here whatever leaf value you want.
	@result		None.
*/
- (void)setValue:(id)argument;

/*!
	@method		nonRetainedValue
	@abstract	The non retained represented object.
	@discussion	Retained by the receiver.
	@result		An object.
*/
- (id)nonRetainedValue;

/*!
	@method		setNonRetainedValue:
	@abstract	set the non retained value.
	@discussion	Put here whatever leaf value you want. This value must be held by someone else during the lifetime of the receiver.
	@result		None.
*/
- (void)setNonRetainedValue:(id)argument;

/*!
	@method		countOfChildren
	@abstract	The number of children of the node.
	@discussion	No access to the whole set of children. The -addObjectInChildren: and -removeChild: of the receiver must be used instead, they preserve the overall consistency.
	@result		A count.
*/
- (unsigned int)countOfChildren;

/*!
	@method setCountOfChildren:
	@abstract Set the number of children of the node.
	@discussion If there is a shrink, previously declared childen are lost. If there is an enlargement, [NSNull null] objects are added.
				If you access an object that has never been set before, [NSNull null] is returned.
	@result None.
*/
- (void) setCountOfChildren:(unsigned int) argument;

/*!
	@method addObjectInChildren:
	@abstract Designated method to add an object to the child items array.
	@discussion This methods preserves the front end hierarchy of objects and underlying data model,
	once an object (iTMNode's instance in general) is added, its parent is set to the receiver if possible,
	and the data model is inserted in the data underlying data hierarchy if not already there. The controller of the receiver is asked to preserve the underlying data model hierarchy.
	@result The object added. If a copy is really added to the array, this copy is returned.
	nil is returned when nothing has been added, either there was nothing to add or there was an error or the child item was already listed in the child items array.
*/
- (void) addObjectInChildren:(id)anObject;

/*!
	@method insertObject:inChildrenAtIndex:
	@abstract Designated method to add an object to the child items array.
	@discussion This methods preserves the front end hierarchy of objects and underlying data model,
	once an object (iTMNode's instance in general) is added, its parent is set to the receiver if possible,
	and the data model is inserted in the data underlying data hierarchy if not already there. The controller of the receiver is asked to preserve the underlying data model hierarchy.
	@result The object added. If a copy is really added to the array, this copy is returned.
	nil is returned when nothing has been added, either there was nothing to add or there was an error or the child item was already listed in the child items array.
*/
- (void)insertObject:(id)anObject inChildrenAtIndex:(unsigned int)index;

/*!
	@method		replaceObjectInChildrenAtIndex:withObject:
	@abstract	Designated method to replace an object in the child items array.
	@discussion	Discussion forthcoming.
	@result		None.
*/
- (void) replaceObjectInChildrenAtIndex:(unsigned) index withObject:(id) anObject;

/*!
	@method		removeObjectFromChildren:
	@abstract	Designated method to remove an object to the child items array.
	@discussion	This methods preserves the front end hierarchy of objects and the underlying data model.
				Once an object (iTMNode's instance in general) is removed, its parent is set to the nil if possible,
				and its data is removed from the data hierarchy.
				The overall consistency is preserved by asking the leaf of the receiver to do the real job through the message -removeOwnerChild:.
	@result		A flag indicating wheether the object has really been removed.
*/
- (void)removeObjectFromChildren:(id)anObject;

/*!
	@method		indexOfObjectInChildren:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		None.
*/
- (unsigned) indexOfObjectInChildren:(id)anObject;

/*!
	@method		objectInChildrenAtIndex:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		None.
*/
- (id) objectInChildrenAtIndex:(unsigned)index;

/*!
	@method		objectInChildrenWithValue:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		None.
*/
- (id) objectInChildrenWithValue:(id)anObject;

@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TreeNode
