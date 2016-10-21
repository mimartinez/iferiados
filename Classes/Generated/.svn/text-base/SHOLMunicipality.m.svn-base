//
//  SHOLMunicipality.m
//  Feriados
//
//  Created by mimartinez on 11/02/04.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "SHOLMunicipality.h"


@implementation SHOLMunicipality

@synthesize ID = _ID;
@synthesize Name = _Name;

- (void) encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject: self.ID forKey:@"ID"];
    [encoder encodeObject: self.Name forKey:@"Name"];
}

- (id) initWithCoder:(NSCoder*)decoder
{
    if (self = [super init]) 
    {
        self.ID = [[decoder decodeObjectForKey:@"ID"] retain];
        self.Name = [[decoder decodeObjectForKey:@"Name"] retain];
    }
    
    return self;
}

- (id) init
{
	if(self = [super init])
	{
		self.ID = nil;
		self.Name = nil;
	}
	return self;
}

+ (SHOLMunicipality*) newWithNode: (CXMLNode*) node
{
	if(node == nil) { return nil; }
	return (SHOLMunicipality*)[[[SHOLMunicipality alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node {
	if(self = [super initWithNode: node])
	{
		self.ID = [Soap getNodeValue: node withName: @"Id"];
		self.Name = [Soap getNodeValue: node withName: @"Name"];
	}
	return self;
}

- (NSMutableString*) serialize
{
	return [self serialize: @"Municipality"];
}

- (NSMutableString*) serialize: (NSString*) nodeName
{
	NSMutableString* s = [[NSMutableString alloc] init];
	[s appendFormat: @"<%@", nodeName];
	[s appendString: [self serializeAttributes]];
	[s appendString: @">"];
	[s appendString: [self serializeElements]];
	[s appendFormat: @"</%@>", nodeName];
	return [s autorelease];
}

- (NSMutableString*) serializeElements
{
	NSMutableString* s = [super serializeElements];
	
	if (self.ID != nil) [s appendFormat: @"<Id>%@</Id>", [[self.ID stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
	if (self.Name != nil) [s appendFormat: @"<Name>%@</Name>", [[self.Name stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
	
	return s;
}

- (NSMutableString*) serializeAttributes
{
	NSMutableString* s = [super serializeAttributes];
	
	return s;
}

-(BOOL)isEqual:(id)object{
	if(object != nil && [object isKindOfClass:[SHOLMunicipality class]]) {
		return [[self serialize] isEqualToString:[object serialize]];
	}
	return NO;
}

-(NSUInteger)hash{
	return [Soap generateHash:self];
	
}

- (void) dealloc
{
	if(self.ID != nil) { [self.ID release]; }
	if(self.Name != nil) { [self.Name release]; }
	[super dealloc];
}

@end
