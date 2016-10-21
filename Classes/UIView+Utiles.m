//
//  UIView+Utiles.m
//  Feriados
//
//  Created by mimartinez on 11/02/18.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "UIView+Utiles.h"
#import "Constantes.h"
#import "FeriadosAppDelegate.h"


@implementation UIView (Utiles)

- (void)showModal 
{
	UIWindow* mainWindow = (((FeriadosAppDelegate*) [UIApplication sharedApplication].delegate).window);
	
	CGPoint middleCenter = self.center;
	CGSize offSize = [[UIScreen mainScreen] applicationFrame].size;
	CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
	self.center = offScreenCenter;
	[mainWindow addSubview:self];
	
	// Show it with a transition effect
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:(IF_IPAD)? ANIMATION_KEYBOARD_IPAD :ANIMATION_KEYBOARD]; // animation duration in seconds
	self.center = middleCenter;
	[UIView commitAnimations];
}


@end
