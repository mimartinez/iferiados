//
//  UINavigationBar+Custom.m
//  Feriados
//
//  Created by mimartinez on 11/02/09.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "UINavigationBar+Custom.h"
#import "Constantes.h"

#define LABEL_TITLE_TAG 1005

@implementation UINavigationBar (Custom)

- (void)drawRect:(CGRect)rect 
{	
    UIColor *color = COLOR_ITEMNAVBAR;
	
	if (self.tag != NAVBAR_EMAIL && self.tag != NAVBAR_EVENT) {
		UIImage *img  = [UIImage imageNamed: (IF_IPAD)? @"Fondo_NavBar-iPad.png" : @"Fondo_NavBar.png"];
		[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	}else {
		UIImage *img  = [UIImage imageNamed: (IF_IPAD)? @"Fondo_NavBarEmail-iPad.png" : @"Fondo_NavBarEmail.png"];
		[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	}

    self.tintColor = color;
}

- (void)customTitle
{
	NSString *title = [NSString stringWithString:self.topItem.title];
	self.topItem.title = nil;
	UILabel *label = [[UILabel alloc] initWithFrame:(IF_IPAD)? CGRectMake(230, 10, 300, 23) : CGRectMake(0, 23, 320, 15)];
	label.tag = LABEL_TITLE_TAG;
    [label setBackgroundColor:[UIColor clearColor]];
	label.font = [UIFont boldSystemFontOfSize: (IF_IPAD)? 20.0 :12.0];
	label.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.3];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
    label.text = title;
	[self addSubview:label];
    [label release];
}

- (void)customTitle:(id)target
{
	NSString *title = nil;
	if([target isKindOfClass:[UITableViewController class]]) 
	{
		UITableViewController *table = (UITableViewController*)target; 
		title = table.title;
		table.title = nil;
	}
	else if([target isKindOfClass:[UIViewController class]])
	{
		UIViewController *viewController = (UIViewController*)target;
		title = viewController.title;
		viewController.title = nil;
	}
	
	UILabel *label = nil;
	
	if (![self viewWithTag:LABEL_TITLE_TAG]) {
		label= [[UILabel alloc] initWithFrame: (IF_IPAD)? CGRectMake(350, 10, 300, 23) : CGRectMake(60, 23, 200, 15)];
		label.tag = LABEL_TITLE_TAG;
		[label setBackgroundColor:[UIColor clearColor]];
		label.font = [UIFont boldSystemFontOfSize: (IF_IPAD)? 20.0 : 12.0];
		label.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.3];
		label.textAlignment = (IF_IPAD)? UITextAlignmentLeft : UITextAlignmentCenter;
		label.textColor = [UIColor whiteColor];
		label.text = title;
		[self addSubview:label];
		[label release];
	}
	else
	{
		label = (UILabel*)[self viewWithTag:LABEL_TITLE_TAG];
		label.text = title;
	}
}

@end
