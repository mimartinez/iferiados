//
//  FeriadosAppDelegate.h
//  iFeriados
//
//  Created by mimartinez on 11/02/07.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTabBar;

@interface FeriadosAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	GTabBar *tabView;
	UIImageView *splashView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end

