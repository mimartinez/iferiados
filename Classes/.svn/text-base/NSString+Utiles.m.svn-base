//
//  NSSting+Utiles.m
//  Feriados
//
//  Created by mimartinez on 11/01/21.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "NSString+Utiles.h"


@implementation NSString (Utiles)

- (BOOL) isEmptyString
{
    if([self length] == 0) { //string is empty or nil
        return YES;
    } else if([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
		//string is all whitespace
        return YES;
    }
    return NO;
}

// "psuedo-numeric" comparison
//   -- if both strings begin with digits, numeric comparison on the digits
//   -- if numbers equal (or non-numeric), caseInsensitiveCompare on the remainder

- (NSComparisonResult) psuedoNumericCompare:(NSString *)otherString {
	
    NSString *left  = self;
    NSString *right = otherString;
    NSInteger leftNumber, rightNumber;
	
	
    NSScanner *leftScanner = [NSScanner scannerWithString:left];
    NSScanner *rightScanner = [NSScanner scannerWithString:right];
	
    // if both begin with numbers, numeric comparison takes precedence
    if ([leftScanner scanInteger:&leftNumber] && [rightScanner scanInteger:&rightNumber]) {
        if (leftNumber < rightNumber)
            return NSOrderedAscending;
        if (leftNumber > rightNumber)
            return NSOrderedDescending;
		
        // if numeric values tied, compare the rest 
        left = [left substringFromIndex:[leftScanner scanLocation]];
        right = [right substringFromIndex:[rightScanner scanLocation]];
    }
	
    return [left caseInsensitiveCompare:right];
}

@end
