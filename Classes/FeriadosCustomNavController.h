//
//  FeriadosCustomNavController.h
//  iFeriados
//
//  Created by mimartinez on 11/02/16.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeriadosCustomNavController : UIViewController
{
	UINavigationController *navController;
}

@property (nonatomic, retain) UINavigationController *navController;

-(id)initWithNavControllerWithSubViewController:(UIViewController *)subviewcontroller;

@end
