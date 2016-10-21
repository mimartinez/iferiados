//
//  CustomTableViewCell.m
//  Feriados
//
//  Created by mimartinez on 11/02/11.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "CustomTableViewCell.h"


@implementation CustomTableViewCell

@synthesize nomeFeriado;
@synthesize mesFeriado;
@synthesize diaFeriado;
@synthesize nomeDiaFeriado;

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
	[nomeFeriado release];
	[mesFeriado release];
	[diaFeriado release];
	[nomeDiaFeriado release];
    [super dealloc];
}


@end
