//
//  MiddleCell.m
//  Feriados
//
//  Created by mimartinez on 11/02/22.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "MiddleCell.h"


@implementation MiddleCell

@synthesize dataFeriado;
@synthesize tipoFeriado;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[self.tipoFeriado release];
	[self.dataFeriado release];
    [super dealloc];
}


@end
