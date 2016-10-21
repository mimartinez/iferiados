//
//  TopCell.h
//  Feriados
//
//  Created by mimartinez on 11/02/21.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TopCell : UITableViewCell {
	IBOutlet UILabel *nomeText;
	IBOutlet UILabel *nomeMes;
	IBOutlet UILabel *dia;
}

@property (nonatomic, retain) IBOutlet UILabel *nomeText;
@property (nonatomic, retain) IBOutlet UILabel *nomeMes;
@property (nonatomic, retain) IBOutlet UILabel *dia;

@end
