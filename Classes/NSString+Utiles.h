//
//  NSSting+Utiles.h
//  Feriados
//
//  Created by mimartinez on 11/01/21.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Utiles)

- (BOOL) isEmptyString;
- (NSComparisonResult) psuedoNumericCompare:(NSString *)otherString;

@end
