//
//  CacheData.h
//  Feriados
//
//  Created by mimartinez on 11/03/29.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constantes.h"

@class SHOLArrayOfHoliday;
@class SHOLHoliday;

@interface CacheData : NSObject <UIAlertViewDelegate>{
    
}

+(BOOL)existFile:(ModoFeriado)modoFeriado ano:(NSInteger)anAno;
+(BOOL)existFileMunicipal:(NSInteger)anAno codeMunicipal:(NSString *)code;
+(BOOL)existFileMovil:(NSInteger)anAno tipoFeriado:(TipoFeriado)tipo;
+(void)saveSHOLArrayOfHolidayInFile:(ModoFeriado)modoFeriado ano:(NSInteger)anAno data:(SHOLArrayOfHoliday *)anData codeMunicipal:(NSString *)code;
+(SHOLArrayOfHoliday *)readSHOLArrayOfHolidayOfFile:(ModoFeriado)modoFeriado ano:(NSInteger)anAno codeMunicipal:(NSString *)code;
+(void)saveSHOLHolidayInFile:(NSInteger)anAno data:(SHOLHoliday *)anData tipoFeriado:(TipoFeriado)tipo;
+(SHOLHoliday *)readSHOLHolidayOfFile:(NSInteger)anAno tipoFeriado:(TipoFeriado)tipo;
+(BOOL)removeAllCache;
@end
