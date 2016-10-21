//
//  SHOLMunicipality.h
//  Feriados
//
//  Created by mimartinez on 11/02/04.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "Soap.h"

@interface SHOLMunicipality : SoapObject <NSCoding>
{
	NSString *_ID;
	NSString *_Name;
}

@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSString* Name;


+ (SHOLMunicipality*) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
- (NSMutableString*) serialize;
- (NSMutableString*) serialize: (NSString*) nodeName;
- (NSMutableString*) serializeAttributes;
- (NSMutableString*) serializeElements;

@end
