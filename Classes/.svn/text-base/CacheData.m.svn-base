//
//  CacheData.m
//  Feriados
//
//  Created by mimartinez on 11/03/29.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "CacheData.h"
#import "CacheAlert.h"
#import "SHOLArrayOfHoliday.h"
#import "SHOLHoliday.h"

@implementation CacheData

#pragma mark-
#pragma mark Utils para pesquisa ficheiros

+(NSString *)getNomeFileMunicipal:(NSInteger)anAno codeMunicipal:(NSString *)code
{
    NSString *nameFile = nameFile = [NSString stringWithFormat:@"%@%@%d.out", FILENAME_MUNICIPAL, code, anAno];
    return nameFile;     
}

+(NSString *)getNomeFileMovil:(NSInteger)anAno tipoFeriado:(TipoFeriado)tipo
{
    NSString *nameFile = nameFile = [NSString stringWithFormat:@"%@%@%d.out", FILENAME_MOVIL, (tipo == Carnaval)? @"Carnaval" : (tipo == CorpoDeDeus)? @"CorpoDeDeus" : (tipo == Pascoa) ? @"Pascoa" : @"SextaSanta", anAno];
    return nameFile;     
}

+(NSString *)getNomeFile:(ModoFeriado)modoFeriado ano:(NSInteger)anAno
{
    NSString *nameFile = nil;
    
    switch (modoFeriado) {
        case Nacional:
            nameFile = [NSString stringWithFormat:@"%@%d.out", FILENAME_NACIONAL, anAno];
            break;
        case Regional:
            nameFile = [NSString stringWithFormat:@"%@%d.out", FILENAME_REGIONAL, anAno];
            break;
        default:
            nameFile = @"";
            break;
    }

    return nameFile;     
}

+(BOOL)existFile:(ModoFeriado)modoFeriado ano:(NSInteger)anAno
{
    // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:DIRECTORY_CACHE];

    return [[NSFileManager defaultManager] fileExistsAtPath:[directory
                                                             stringByAppendingPathComponent:[self getNomeFile:modoFeriado ano:anAno]]];
}

+(BOOL)existFileMunicipal:(NSInteger)anAno codeMunicipal:(NSString *)code
{
    // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:DIRECTORY_CACHE];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[directory
                                                             stringByAppendingPathComponent:[self getNomeFileMunicipal:anAno codeMunicipal:code]]];
}

+(BOOL)existFileMovil:(NSInteger)anAno tipoFeriado:(TipoFeriado)tipo
{
    // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:DIRECTORY_CACHE];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[directory
                                                             stringByAppendingPathComponent:[self getNomeFileMovil:anAno tipoFeriado:tipo]]];
}

#pragma mark-
#pragma mark Save and Read ficheiros arrays

+(void)saveSHOLArrayOfHolidayInFile:(ModoFeriado)modoFeriado ano:(NSInteger)anAno data:(SHOLArrayOfHoliday *)anData codeMunicipal:(NSString *)code
{
    // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:DIRECTORY_CACHE];
    
    NSError *error;
    // check for existence of cache directory
	if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
		// create a new cache directory
        if (![[NSFileManager defaultManager] createDirectoryAtPath:directory
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error]) {
            CacheAlertWithError(error);
            return;
        }
	}
    
    // Path to save array data
    NSString  *arrayPath = [directory
                            stringByAppendingPathComponent:(modoFeriado == Municipal)?[self getNomeFileMunicipal:anAno codeMunicipal:code] : [self getNomeFile:modoFeriado ano:anAno]];

    // Write array
    NSMutableArray *arrayHolidays = [NSMutableArray array];
    for (SHOLHoliday *feriado in anData) 
    {
        [arrayHolidays addObject:feriado];
    }
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrayHolidays];
    [encodedObject writeToFile:arrayPath atomically:YES];
}

+(SHOLArrayOfHoliday *)readSHOLArrayOfHolidayOfFile:(ModoFeriado)modoFeriado ano:(NSInteger)anAno codeMunicipal:(NSString *)code
{
    // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    // Path to save array data
    NSString  *arrayPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:DIRECTORY_CACHE]
                            stringByAppendingPathComponent:(modoFeriado == Municipal)? [self getNomeFileMunicipal:anAno codeMunicipal:code] : [self getNomeFile:modoFeriado ano:anAno]];
    
    // Read file
    NSData *encodedObject = [NSData dataWithContentsOfFile:arrayPath];
    if (encodedObject == nil) return nil;

    SHOLArrayOfHoliday *object = (SHOLArrayOfHoliday *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

#pragma mark-
#pragma mark Remove All Context of the Cache
+(BOOL)removeAllCache
{
    // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:DIRECTORY_CACHE];
    
    NSError *errorDirectory = nil;
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&errorDirectory];
    
    if (errorDirectory == nil) 
    {
        for (NSString *fileName in directoryContents) 
        {
            NSString *fullPath = [directory stringByAppendingPathComponent:fileName];
            NSLog(@"PATH %@", fullPath);
            BOOL removeSuccess = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&errorDirectory];
            
            if (!removeSuccess) 
            {
                return removeSuccess;
            }
        }
        
        return YES;
    } 
    else 
    {
        return NO;
    }
}

#pragma mark-
#pragma mark Save and Read object Holiday

+(void)saveSHOLHolidayInFile:(NSInteger)anAno data:(SHOLHoliday *)anData tipoFeriado:(TipoFeriado)tipo
{
    // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:DIRECTORY_CACHE];
    
    NSError *error;
    // check for existence of cache directory
	if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
		// create a new cache directory
        if (![[NSFileManager defaultManager] createDirectoryAtPath:directory
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error]) {
            CacheAlertWithError(error);
            return;
        }
	}
    
    // Path to save array data
    NSString  *arrayPath = [directory
                            stringByAppendingPathComponent:[self getNomeFileMovil:anAno tipoFeriado:tipo]];
    
    // Write array
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:anData];
    [encodedObject writeToFile:arrayPath atomically:YES];
}

+(SHOLHoliday *)readSHOLHolidayOfFile:(NSInteger)anAno tipoFeriado:(TipoFeriado)tipo
{
    // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    // Path to save array data
    NSString  *arrayPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:DIRECTORY_CACHE]
                            stringByAppendingPathComponent:[self getNomeFileMovil:anAno tipoFeriado:tipo]];
    
    // Read file
    NSData *encodedObject = [NSData dataWithContentsOfFile:arrayPath];
    if (encodedObject == nil) return nil;
    
    SHOLHoliday *object = (SHOLHoliday *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end
