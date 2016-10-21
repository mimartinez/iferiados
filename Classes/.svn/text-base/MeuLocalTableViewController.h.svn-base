//
//  MeuLocalTableViewController.h
//  Feriados
//
//  Created by mimartinez on 11/02/24.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "SelecionaAnoViewController.h"
#import "MBProgressHUD.h"
#import "ExtraHolidays.h"

@class SHOLArrayOfHoliday;

@interface MeuLocalTableViewController : UITableViewController <SelecionaAnoViewControllerDelegate, CLLocationManagerDelegate, 
																MKReverseGeocoderDelegate, MBProgressHUDDelegate, ExtraHolidaysDelegate> 
{
	SHOLArrayOfHoliday *arrayHolidayMunicipal;
	CLLocationManager *locationManager;
	NSString *stateString;
	NSDictionary *municipio;
	MBProgressHUD *HUD;
	UIView *viewMensagem;
}

@property (nonatomic, retain) UIView *viewMensagem;
@property (nonatomic, retain) NSDictionary *municipio;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *stateString;
@property (nonatomic, retain) SelecionaAnoViewController *selecionaAnoViewController;
@property (nonatomic, retain) ExtraHolidays *extraHolidays;

- (void)selecionaAnoViewController:(SelecionaAnoViewController *)controller didFinishSelecionaAnoWithInfo:(NSNumber *)anoInfo;
- (void)didFinishExtraHolidaysInfo:(ExtraHolidays *)extraHolidays;
- (void)stopUpdatingLocation:(NSString *)state;
- (void)mensagemView:(NSString *)texto;

@end
