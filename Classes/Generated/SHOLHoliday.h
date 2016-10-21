//
//  SHOLHoliday.h
//  Feriados
//
//  Created by mimartinez on 11/02/04.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

@class SHOLMunicipality;

#import "Soap.h"

@interface SHOLHoliday : SoapObject <NSCoding>
{
	NSString *_Name;
	NSDate *_Date;
	NSString *_Description;
	NSString *_Type; //National or Municipal or Regional or Religious or Optional
	SHOLMunicipality *_Municipality;
}

@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSDate *Date;
@property (nonatomic, retain) NSString *Description;
@property (nonatomic, retain) NSString *Type;
@property (nonatomic, retain) SHOLMunicipality *Municipality;

+ (SHOLHoliday*) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
- (NSMutableString*) serialize;
- (NSMutableString*) serialize: (NSString*) nodeName;
- (NSMutableString*) serializeAttributes;
- (NSMutableString*) serializeElements;

@end
