//
//  Utiles.h
//  Feriados
//
//  Created by mimartinez on 11/02/21.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utiles : NSObject {

}

+ (void)saveAnoApp:(NSInteger)ano;
+ (NSInteger)getAnoApp;
+ (void)saveRemoveCache2013:(BOOL)remove;
+ (BOOL)getRemoveCache2013;
@end
