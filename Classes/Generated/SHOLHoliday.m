//
//  SHOLHoliday.m
//  Feriados
//
//  Created by mimartinez on 11/02/04.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "SHOLHoliday.h"
#import "SHOLMunicipality.h"

@implementation SHOLHoliday

@synthesize Name = _Name;
@synthesize Date = _Date;
@synthesize Description = _Description;
@synthesize Type = _Type;
@synthesize Municipality = _Municipality;

- (void) encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject: self.Name forKey:@"Name"];
    [encoder encodeObject: self.Municipality forKey:@"Municipality"];
    [encoder encodeObject: self.Date forKey:@"Date"];
    [encoder encodeObject: self.Description forKey:@"Description"];
    [encoder encodeObject: self.Type forKey:@"Type"];
}

- (id) initWithCoder:(NSCoder*)decoder
{
    if (self = [super init]) 
    {
      self.Name = [[decoder decodeObjectForKey:@"Name"] retain];
      self.Municipality = [[decoder decodeObjectForKey:@"Municipality"] retain];
      self.Date = [[decoder decodeObjectForKey:@"Date"] retain];
      self.Description = [[decoder decodeObjectForKey:@"Description"] retain];
      self.Type = [[decoder decodeObjectForKey:@"Type"] retain];
    }
    
    return self;
}

- (id) init
{
	if(self = [super init])
	{
		self.Municipality = nil;
		self.Name = nil;
		self.Date = nil;
		self.Description = nil;
		self.Type = nil;
	}
	
	return self;
}

+ (SHOLHoliday*) newWithNode: (CXMLNode*) node
{
	if(node == nil) { return nil; }
	return (SHOLHoliday*)[[[SHOLHoliday alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node {
	if(self = [super initWithNode: node])
	{
		self.Name = [Soap getNodeValue: node withName: @"Name"];
		self.Date = [Soap dateFromString:[Soap getNodeValue: node withName:@"Date"]];
		self.Type = [Soap getNodeValue: node withName:@"Type"];
		self.Description = [Soap getNodeValue: node withName: @"Description"];
		self.Municipality = [[SHOLMunicipality newWithNode: [Soap getNode: node withName: @"Municipality"]] object];
	}
	return self;
}

- (NSMutableString*) serialize
{
	return [self serialize: @"Holiday"];
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
	
	if (self.Name != nil) [s appendFormat: @"<Name>%@</Name>", [[self.Name stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
	if (self.Date != nil) [s appendFormat: @"<Date>%@</Date>", [Soap getDateString: self.Date]];
	if (self.Description != nil) [s appendFormat: @"<Description>%@</Description>", [[self.Description stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
	if (self.Type != nil) [s appendFormat: @"<Type>%@</Type>", [[self.Type stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
	if (self.Municipality != nil) [s appendString: [self.Municipality serialize: @"Municipality"]];
	
	return s;
}

- (NSMutableString*) serializeAttributes
{
	NSMutableString* s = [super serializeAttributes];
	
	return s;
}

-(BOOL)isEqual:(id)object{
	if(object != nil && [object isKindOfClass:[SHOLHoliday class]]) {
		return [[self serialize] isEqualToString:[object serialize]];
	}
	return NO;
}

-(NSUInteger)hash{
	return [Soap generateHash:self];
	
}

- (void) dealloc
{
	if(self.Municipality != nil) { [self.Municipality release]; }
	if(self.Type != nil) { [self.Type release]; }
	if(self.Date != nil) { [self.Date release]; }
	if(self.Name != nil) { [self.Name release]; }
	if(self.Description != nil) { [self.Description release]; }
	[super dealloc];
}

@end
