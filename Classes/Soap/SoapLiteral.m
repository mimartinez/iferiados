//
//  SoapLiteral.m
//  SudzCExamples
//
//  Created by Jason Kichline on 8/7/10.
//  Copyright 2010 andCulture. All rights reserved.
//

#import "SoapLiteral.h"


@implementation SoapLiteral

@synthesize valueSoapLiteral;

-(id)initWithString:(NSString *)string {
	if(self = [self init]) {
		self.valueSoapLiteral = string;
	}
	return self;
}

+(SoapLiteral*)literalWithString:(NSString *)string {
	return [[[SoapLiteral alloc] initWithString:string] autorelease];
}

@end
