    //
//  FeriadosCustomNavController.m
//  iFeriados
//
//  Created by mimartinez on 11/02/16.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "FeriadosCustomNavController.h"
#import "Constantes.h"

@implementation FeriadosCustomNavController

@synthesize navController;

-(id)initWithNavControllerWithSubViewController:(UIViewController *)subviewcontroller {
	if (self = [super init]) {
		self.navController = [[UINavigationController alloc] initWithRootViewController:subviewcontroller];
	}
	return self;
}

-(void)loadView {
	self.view = [[UIView alloc] initWithFrame:(IF_IPAD)? CGRectMake(0, 0, 768, 1024) : CGRectMake(0, 0, 320, 480)];
	if (self.navController != nil) {
		CGRect rectApp = [[UIScreen mainScreen] applicationFrame];
		self.navController.view.frame = CGRectMake(rectApp.origin.x, rectApp.origin.y, rectApp.size.width, rectApp.size.height - HEIGHT_TABBAR);
		[self.view addSubview:self.navController.view];
	}
}


-(void)viewWillAppear:(BOOL)animated {
	[self.navController viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated {
	[self.navController viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated {
	[self.navController viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated {
	[self.navController viewDidDisappear:animated];
}

- (void)dealloc {
	[navController release];
    [super dealloc];
}

@end
