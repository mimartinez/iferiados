//
//  ExtraHolidays.h
//  Feriados
//
//  Created by Michel Martínez on 11/07/09.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SoapFault;
@class ExtraHolidays;
@class SHOLArrayOfHoliday;

@protocol ExtraHolidaysDelegate <NSObject>

@optional
- (void)didFinishExtraHolidaysInfo:(ExtraHolidays *)extraHolidays;
@end

@interface ExtraHolidays : NSObject 
{
    SHOLArrayOfHoliday *arrayFeriados;
    NSDictionary *municipio;
    NSDictionary *feriadoExtra;
    id <ExtraHolidaysDelegate> delegate;
    NSError *erro;
    SoapFault *soap;
}

@property (nonatomic,retain) SHOLArrayOfHoliday *arrayFeriados;
@property (nonatomic, retain) NSDictionary *municipio;
@property (nonatomic, retain) NSDictionary *feriadoExtra;
@property (nonatomic, retain) NSError *erro;
@property (nonatomic, retain) SoapFault *soap;
@property (nonatomic, retain) id <ExtraHolidaysDelegate> delegate;
-(id)initWithMunicipality:(NSDictionary *)municipality;
- (void)getExtraHoliday;

@end
