//
//  RegionaisTableViewController.h
//  iFeriados
//
//  Created by mimartinez on 11/02/08.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelecionaAnoViewController.h"
#import "MBProgressHUD.h"
#import "ExtraHolidays.h"

@class SHOLArrayOfHoliday;

@interface RegionaisTableViewController : UITableViewController <SelecionaAnoViewControllerDelegate, MBProgressHUDDelegate, ExtraHolidaysDelegate>
{
    NSMutableDictionary *feriados;
	NSArray *sections;
	SHOLArrayOfHoliday *arrayHolidayRegionais;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) SelecionaAnoViewController *selecionaAnoViewController;
@property (nonatomic, retain) ExtraHolidays *extraHolidays;

- (void)selecionaAnoViewController:(SelecionaAnoViewController *)controller didFinishSelecionaAnoWithInfo:(NSNumber *)anoInfo;

@end
