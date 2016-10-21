//
//  Utiles.m
//  Feriados
//
//  Created by mimartinez on 11/02/21.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "Utiles.h"


@implementation Utiles

+ (void)saveAnoApp:(NSInteger)ano
{
	NSNumber *anoNumber = [NSNumber numberWithInt:ano];
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setObject:anoNumber forKey:@"anoApp"];
	[userDefault synchronize];
}

+ (NSInteger)getAnoApp
{
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	if ([userDefault objectForKey:@"anoApp"]) {
		return [[userDefault objectForKey:@"anoApp"] intValue];
	}
	else {
		return 0;
	}
}

+ (void)saveRemoveCache2013:(BOOL)remove
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setBool:remove forKey:@"removeCache2013"];
	[userDefault synchronize];
}

+ (BOOL)getRemoveCache2013;
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	
	if ([userDefault objectForKey:@"removeCache2013"]) {
		return [userDefault boolForKey:@"removeCache2013"];
	}
	else {
		return NO;
	}
}

@end
