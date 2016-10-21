//
//  ExtraHolidays.m
//  Feriados
//
//  Created by Michel Martínez on 11/07/09.
//  Copyright 2011 Home. All rights reserved.
//

#import "ExtraHolidays.h"
#import "Utiles.h"
#import "SHOLHolidays.h"
#import "SHOLHoliday.h"
#import "SHOLArrayOfHoliday.h"
#import "SHOLMunicipality.h"
#import "CacheData.h"
#import "NSString+Utiles.h"
#import "NSDate+Utiles.h"

@implementation ExtraHolidays

@synthesize arrayFeriados;
@synthesize municipio;
@synthesize feriadoExtra;
@synthesize erro;
@synthesize soap;
@synthesize delegate;

-(id)initWithMunicipality:(NSDictionary *)municipality
{
    if (self = [super init]) 
    {
        self.municipio = municipality;
    }
    
    return self;
}

- (id) init
{
	if(self = [super init])
	{
		self.municipio = nil;
        self.arrayFeriados = nil;
	}
	return self;
}

- (void)getHolidayByCodigoExtraService:(NSString *)codMunicipality
{
    SHOLHolidays *service = [SHOLHolidays service];
    [service GetHolidaysByMunicipalityId:self action:@selector(GetHolidaysByMunicipalityIdHandler:) year:[Utiles getAnoApp] municipalityId:codMunicipality];
}

// Handle the response from GetHolidaysByMunicipalityId.
-(void)GetHolidaysByMunicipalityIdHandler: (id) value {
	
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		self.erro = (NSError*)value;
	}
	
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		self.soap = (SoapFault*)value;
	}				
	
	// Do something with the SHOLArrayOfHoliday* result
	SHOLArrayOfHoliday* result = (SHOLArrayOfHoliday*)value;
	
	if([result isKindOfClass: [SHOLArrayOfHoliday class]]) 
    {
        
        for (SHOLHoliday *feriado in result) 
        {
            feriado.Municipality.Name = [self.municipio objectForKey:@"Nome"];
            feriado.Municipality.ID = [self.municipio objectForKey:@"Id"];
            
            if (self.feriadoExtra != nil) 
            {
                if(![[self.feriadoExtra objectForKey:@"Nome"] isEmptyString]) 
                    feriado.Name = [self.feriadoExtra objectForKey:@"Nome"];
                if(![[self.feriadoExtra objectForKey:@"Descricao"] isEmptyString])
                    feriado.Description = [self.feriadoExtra objectForKey:@"Descricao"];
            }
        }
            
        [self.arrayFeriados addObjectsFromArray:(NSArray*)result];
	}
    
    if ([delegate respondsToSelector:@selector(didFinishExtraHolidaysInfo:)]) 
    {
        [delegate didFinishExtraHolidaysInfo:self];
    }
}

- (void)loadFeriadoExtraPorCodigo:(NSString *)tipo
{
    SHOLHolidays *service = [SHOLHolidays service];
        
    if ([tipo isEqualToString:@"PASCOA"]) 
    {
        [service GetEaster:self action:@selector(GetSHOLHolidaysHandler:) year:[Utiles getAnoApp]];
    }
    else if([tipo isEqualToString:@"CORPODEUS"])
    {
        [service GetCorpusChristi:self action:@selector(GetSHOLHolidaysHandler:) year:[Utiles getAnoApp]];
    }
}

// Handle the response.
-(void) GetSHOLHolidaysHandler: (id) value {
	
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		self.erro = (NSError*)value; 
	}
	
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		self.soap = (SoapFault*)value;
	}				
	
	// Do something with the SHOLHoliday* result
	SHOLHoliday* result = (SHOLHoliday*)value;
	
	if([result isKindOfClass: [SHOLHoliday class]]) {
        
        result.Name = [self.feriadoExtra objectForKey:@"Nome"];
        result.Description = [self.feriadoExtra objectForKey:@"Descricao"];
        
        if (![[self.municipio objectForKey:@"Id"] isEqualToString:@"9999"]) 
        {
            result.Type = @"Municipal";
        
            if (result.Municipality != nil) {
                result.Municipality.Name = [self.municipio objectForKey:@"Nome"];
                result.Municipality.ID = [self.municipio objectForKey:@"Id"];
            }
            else
            {
                SHOLMunicipality *municipality = [[SHOLMunicipality alloc] init];
                municipality.Name = [self.municipio objectForKey:@"Nome"];
                municipality.ID = [self.municipio objectForKey:@"Id"];
                result.Municipality = municipality;
                [municipality autorelease];
            }
        }
        else
        {
            result.Type = @"Regional";
        }
        
        result.Date = [result.Date dateByAddingDays:[[self.feriadoExtra objectForKey:@"Dia"] intValue]];
        
        [self.arrayFeriados addObject:result];
	}
    
    if ([delegate respondsToSelector:@selector(didFinishExtraHolidaysInfo:)]) 
    {
        [delegate didFinishExtraHolidaysInfo:self];
    }
}

- (void)getExtraHoliday
{
    self.arrayFeriados = [SHOLArrayOfHoliday array];
    BOOL disparaDelegate = YES;
    
    // Load the data.
	NSString *pathFeriadosExtras = [[NSBundle mainBundle] pathForResource:@"Holidays" ofType:@"plist"];
	NSArray *arrayFeriadosExtras = [NSArray arrayWithContentsOfFile:pathFeriadosExtras];
    
    for (int i = 0; i < arrayFeriadosExtras.count ; i++) 
	{							
		NSDictionary *itemMunicipio = [[NSDictionary alloc] initWithDictionary:[arrayFeriadosExtras objectAtIndex:i]];
        
    if ([[itemMunicipio objectForKey:@"Id"] isEqualToString:[self.municipio objectForKey:@"Id"]]) 
    {
            
        if (![[itemMunicipio objectForKey:@"IdRelacionado"] isEmptyString]) 
        {
            disparaDelegate = NO;
            [self getHolidayByCodigoExtraService:[itemMunicipio objectForKey:@"IdRelacionado"]];
            self.feriadoExtra = [[NSDictionary alloc] initWithDictionary:[arrayFeriadosExtras objectAtIndex:i]];
        }
        else if(![[itemMunicipio objectForKey:@"CodSuma"] isEmptyString])
        {
            self.feriadoExtra = [[NSDictionary alloc] initWithDictionary:[arrayFeriadosExtras objectAtIndex:i]];
            
            if ([[itemMunicipio objectForKey:@"CodSuma"] isEqualToString:@"PASCOA"]
                || [[itemMunicipio objectForKey:@"CodSuma"] isEqualToString:@"CORPODEUS"]) 
            {
                disparaDelegate = NO;
                [self loadFeriadoExtraPorCodigo:[itemMunicipio objectForKey:@"CodSuma"]];
            }
            else
            {
                SHOLHoliday *itemValue = [[SHOLHoliday alloc] init];
                itemValue.Name = [itemMunicipio objectForKey:@"Nome"];
                itemValue.Description = [itemMunicipio objectForKey:@"Descricao"];
                itemValue.Type = @"Municipal";
                
                // Crear Fecha do Feriado
                NSDateComponents *components = [[NSDateComponents alloc] init];
                [components setDay:1];
                [components setMonth:[[itemMunicipio objectForKey:@"Mes"] intValue]];
                [components setYear:[Utiles getAnoApp]];
                NSCalendar *gregorian = [[NSCalendar alloc]
                                         initWithCalendarIdentifier:NSGregorianCalendar];
                
                SHOLMunicipality *municipality = [[SHOLMunicipality alloc] init];
                municipality.Name = [self.municipio objectForKey:@"Nome"];
                municipality.ID = [self.municipio objectForKey:@"Id"];
                itemValue.Municipality = municipality;
                [municipality autorelease];
                
                if ([[itemMunicipio objectForKey:@"CodSuma"] isEqualToString:@"SEGUNDA_APOS_2DOMINGO"])
                {
                    itemValue.Date = [[[gregorian dateFromComponents:components] dateCombinationDayMonthYear:DOMINGO numberInMonth:2] dateByAddingDays:1];
                }
                else if([[itemMunicipio objectForKey:@"CodSuma"] isEqualToString:@"SEGUNDA_APOS_3DOMINGO"])
                {
                    itemValue.Date = [[[gregorian dateFromComponents:components] dateCombinationDayMonthYear:DOMINGO numberInMonth:3] dateByAddingDays:1];
                }
                else if([[itemMunicipio objectForKey:@"CodSuma"] isEqualToString:@"SEGUNDA_ULTIMA"])
                {
                    NSDate *dataUltimaSegunda = [[gregorian dateFromComponents:components] dateCombinationDayMonthYear:SEGUNDA numberInMonth:4];
                    
                    // Se não é a ultima semana do mês, então adiciona mais uma semana
                    if (![dataUltimaSegunda isLastWeek])
                        itemValue.Date = [dataUltimaSegunda dateByAddingDays:7];
                    else
                        itemValue.Date = dataUltimaSegunda;
                }
                else if([[itemMunicipio objectForKey:@"CodSuma"] isEqualToString:@"3SEGUNDA"])
                {
                    itemValue.Date = [[gregorian dateFromComponents:components] dateCombinationDayMonthYear:SEGUNDA numberInMonth:3];
                }
                else if([[itemMunicipio objectForKey:@"CodSuma"] isEqualToString:@"SEGUNDA_APOS_4DOMINGO"])
                {
                    itemValue.Date = [[[gregorian dateFromComponents:components] dateCombinationDayMonthYear:DOMINGO numberInMonth:4] dateByAddingDays:1];
                }
                
                [itemValue autorelease];
                
                [self.arrayFeriados addObject:itemValue];
                [components release];
                [gregorian release];
            }
        }
        else
        {
            SHOLHoliday *itemValue = [[SHOLHoliday alloc] init];
            itemValue.Name = [itemMunicipio objectForKey:@"Nome"];
            itemValue.Description = [itemMunicipio objectForKey:@"Descricao"];
            
            // Crear Fecha do Feriado
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay:[[itemMunicipio objectForKey:@"Dia"] intValue]];
            [components setMonth:[[itemMunicipio objectForKey:@"Mes"] intValue]];
            [components setYear:[Utiles getAnoApp]];
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            
            itemValue.Date = [gregorian dateFromComponents:components];
            
            if (![[self.municipio objectForKey:@"Id"] isEqualToString:@"9999"]) 
            {
                SHOLMunicipality *municipality = [[SHOLMunicipality alloc] init];
                municipality.Name = [self.municipio objectForKey:@"Nome"];
                municipality.ID = [self.municipio objectForKey:@"Id"];
                itemValue.Municipality = municipality;
                [municipality autorelease];
                itemValue.Type = @"Municipal";
            }
            else
            {
                itemValue.Type = @"Regional";
            }
            
            [itemValue autorelease];
            
            [self.arrayFeriados addObject:itemValue];
            [components release];
            [gregorian release];
        }
    }
        
        [itemMunicipio release];
    }
    
    if (disparaDelegate) {
        if ([delegate respondsToSelector:@selector(didFinishExtraHolidaysInfo:)]) 
        {
            [delegate didFinishExtraHolidaysInfo:self];
        }
    }
}

- (void)dealloc 
{
	[self.arrayFeriados release];
    [self.municipio release];
    [self.feriadoExtra release];
    [self.erro release];
    [self.soap release];
    [super dealloc];
}

@end
