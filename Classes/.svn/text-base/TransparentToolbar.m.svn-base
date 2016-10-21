//
//  TransparentToolbar.m
//  Feriados
//
//  Created by Michel Martínez on 24/09/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "TransparentToolbar.h"

@implementation TransparentToolbar

- (void)drawRect:(CGRect)rect {
    // do nothing in here
}

// Set properties to make background
// translucent.
- (void) applyTranslucentBackground
{
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
	self.translucent = YES;
}

// Override init.
- (id) init
{
	self = [super init];
	[self applyTranslucentBackground];
	return self;
}

// Override initWithFrame.
- (id) initWithFrame:(CGRect) frame
{
	self = [super initWithFrame:frame];
	[self applyTranslucentBackground];
	return self;
}

@end
