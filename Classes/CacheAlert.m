//
//  CacheAlert.m
//  Feriados
//
//  Created by mimartinez on 11/03/29.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "CacheAlert.h"


void CacheAlertWithError(NSError *error)
{
    NSString *message = [NSString stringWithFormat:@"Error! %@ %@",
						 [error localizedDescription],
						 [error localizedFailureReason]];
	
	CacheAlertWithMessage (message);
}


void CacheAlertWithMessage(NSString *message)
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iFeriados Cache" 
													message:message
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
}
