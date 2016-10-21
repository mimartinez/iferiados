//
//  Constantes.h
//  Feriados
//
//  Created by mimartinez on 11/02/17.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#define IF_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define HEIGHT_TABBAR 49
#define TABBARHOLDER_TAG 5400
#define NAVBAR_EMAIL 5401
#define NAVBAR_EVENT 5402
#define ANO_INICIAL 1582
#define ANO_FINAL 2299
#define KEYBOARD_HEIGHT 216
#define KEYBOARD_IPAD_HEIGHT 264
#define APP_HEIGHT 460
#define APP_IPAD_HEIGHT 1004
#define STATUS_BAR_HEIGHT 20
#define ANIMATION_KEYBOARD 0.3
#define ANIMATION_KEYBOARD_IPAD 0.3
#define COLOR_ITEMNAVBAR [UIColor colorWithRed:100.0/255.0 green:109.0/255.0 blue:118.0/255.0 alpha:1.0]
#define COLOR_SEARCHBAR [UIColor colorWithRed:177.0/255.0 green:177.0/255.0 blue:177.0/255.0 alpha:1.0]
#define COLOR_FONDO_SOBRE [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0]
#define COLOR_TEXTCELLMONTH [UIColor colorWithRed:12.0/255.0 green:121.0/255.0 blue:33.0/255.0 alpha:1.0]
#define kCustomButtonHeight		30.0

/******** Nomes ficheiros da cache *********/
#define DIRECTORY_CACHE @"FeriadosCache" 
#define FILENAME_NACIONAL @"nacional"
#define FILENAME_MUNICIPAL @"municipal"
#define FILENAME_REGIONAL @"regional"
#define FILENAME_MOVIL @"movil"

typedef enum  {
	Carnaval, 
	CorpoDeDeus, 
	Pascoa,
	SextaSanta
} TipoFeriado;

typedef enum  {
	Nacional, 
	Regional, 
	Municipal,
	Movil
} ModoFeriado;

#pragma mark Dias da semana

#define DOMINGO 1
#define SEGUNDA 2
#define TERCA 3
#define QUARTA 4
#define QUINTA 5
#define SEXTA 6
#define SABADO 7