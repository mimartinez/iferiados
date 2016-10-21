//
//  FeriadosMunicipaisTableViewController.h
//  Feriados
//
//  Created by mimartinez on 11/02/24.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelecionaAnoViewController.h"
#import "MBProgressHUD.h"
#import "ExtraHolidays.h"

@class SHOLArrayOfHoliday;

@interface FeriadosMunicipaisTableViewController : UITableViewController <SelecionaAnoViewControllerDelegate, MBProgressHUDDelegate, ExtraHolidaysDelegate> 
{
	SHOLArrayOfHoliday *arrayHolidayMunicipal;
	NSDictionary *municipio;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSDictionary *municipio;
@property (nonatomic, retain) SelecionaAnoViewController *selecionaAnoViewController;
@property (nonatomic, retain) ExtraHolidays *extraHolidays;

- (void)selecionaAnoViewController:(SelecionaAnoViewController *)controller didFinishSelecionaAnoWithInfo:(NSNumber *)anoInfo;
- (void)didFinishExtraHolidaysInfo:(ExtraHolidays *)extraHolidays;

@end
