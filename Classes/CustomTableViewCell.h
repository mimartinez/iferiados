//
//  CustomTableViewCell.h
//  Feriados
//
//  Created by mimartinez on 11/02/11.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTableViewCell : UITableViewCell {
	UILabel *nomeFeriado;
	UILabel *mesFeriado;
	UILabel *diaFeriado;
	UILabel *nomeDiaFeriado;
}

@property (nonatomic, retain) UILabel *nomeFeriado;
@property (nonatomic, retain) UILabel *mesFeriado;
@property (nonatomic, retain) UILabel *diaFeriado;
@property (nonatomic, retain) UILabel *nomeDiaFeriado;

@end
