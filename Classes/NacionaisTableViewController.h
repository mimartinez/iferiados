//
//  NacionaisTableViewController.h
//  iFeriados
//
//  Created by mimartinez on 11/02/08.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "SelecionaAnoViewController.h"
#import "MBProgressHUD.h"

@class SHOLArrayOfHoliday;

@interface NacionaisTableViewController : UITableViewController <SelecionaAnoViewControllerDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>
{
	SHOLArrayOfHoliday *arrayHolidayNacionais;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) SelecionaAnoViewController *selecionaAnoViewController;

- (void)selecionaAnoViewController:(SelecionaAnoViewController *)controller didFinishSelecionaAnoWithInfo:(NSNumber *)anoInfo;

@end
