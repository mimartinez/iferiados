//
//  SHOLArrayOfHoliday.m
//  Feriados
//
//  Created by mimartinez on 11/02/04.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "SHOLArrayOfHoliday.h"
#import "SHOLHoliday.h"

@implementation SHOLArrayOfHoliday

+ (id) newWithNode: (CXMLNode*) node
{
	return [[[SHOLArrayOfHoliday alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node
{
	if(self = [self init]) {
		for(CXMLElement* child in [node children])
		{
			SHOLHoliday *value = [[SHOLHoliday newWithNode: child] object];
			if(value != nil) {
				[self addObject: value];
			}
		}
	}
	return self;
}

+ (NSMutableString*) serialize: (NSArray*) array
{
	NSMutableString* s = [NSMutableString string];
	for(id item in array) {
		[s appendString: [item serialize: @"Holiday"]];
	}
	return s;
}
@end
