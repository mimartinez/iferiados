//
//  FeriadosAppDelegate.m
//  iFeriados
//
//  Created by mimartinez on 11/02/07.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "FeriadosAppDelegate.h"
#import "GTabBar.h"
#import "NacionaisTableViewController.h"
#import "RegionaisTableViewController.h"
#import "MunicipaisTableViewController.h"
#import "PesquisaViewController.h"
#import "MeuLocalTableViewController.h"
#import "FeriadosCustomNavController.h"
#import "NSDate+Utiles.h"
#import "Utiles.h"
#import "Appirater.h"
#import "CacheData.h"
#import "SHOLHoliday.h"
#import "Constantes.h"
#import "SHOLHolidays.h"
#import "SHOLArrayOfHoliday.h"

#define PESQUISA_NIBNAME @"PesquisaViewController"
#define PESQUISA_NIBNAME_IPAD @"PesquisaViewController-iPad"
#define MUNICIPAIS_NIBNAME @"MunicipaisTableViewController"
#define MUNICIPAIS_NIBNAME_IPAD @"MunicipaisTableViewController-iPad"

@implementation FeriadosAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[splashView removeFromSuperview];
	[splashView release];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{	
    // Apagar toda a cache dos feriados por causa da alteração do governo
    if (![Utiles getRemoveCache2013])
        [Utiles saveRemoveCache2013:[CacheData removeAllCache]];
     
    
    
	//Guardar ano atual desde o inicio
	[Utiles saveAnoApp:[[NSDate date] year]];
	
	// Carrego todas as vistas para o TabBar
	
	GTabTabItem *tabItemNacionais = [[[GTabTabItem alloc] initWithFrame:(IF_IPAD)? CGRectMake(0, 0, 153.6, 49) : CGRectMake(0, 0, 64, 49) normalState:(IF_IPAD)? @"tabbar_nacionais-iPad.png" : @"tabbar_nacionais.png" toggledState:(IF_IPAD)? @"tabbar_nacionais_s-iPad.png" : @"tabbar_nacionais_s.png"] autorelease];
	GTabTabItem *tabItemRegionais = [[[GTabTabItem alloc] initWithFrame:(IF_IPAD)? CGRectMake(153.6, 0, 153.6, 49) : CGRectMake(64, 0, 64, 49) normalState:(IF_IPAD)? @"tabbar_regionais-iPad.png" : @"tabbar_regionais.png" toggledState:(IF_IPAD)? @"tabbar_regionais_s-iPad.png" : @"tabbar_regionais_s.png"] autorelease];
	GTabTabItem *tabItemMunicipais = [[[GTabTabItem alloc] initWithFrame:(IF_IPAD)? CGRectMake(307.2, 0, 153.6, 49) : CGRectMake(128, 0, 64, 49) normalState:(IF_IPAD)? @"tabbar_municipais-iPad.png" : @"tabbar_municipais.png" toggledState:(IF_IPAD)? @"tabbar_municipais_s-iPad.png" : @"tabbar_municipais_s.png"] autorelease];
	GTabTabItem *tabItemMeuLocal = [[[GTabTabItem alloc] initWithFrame:(IF_IPAD)? CGRectMake(460.8, 0, 153.6, 49) : CGRectMake(192, 0, 64, 49) normalState:(IF_IPAD)? @"tabbar_meulocal-iPad.png" : @"tabbar_meulocal.png" toggledState:(IF_IPAD)? @"tabbar_meulocal_s-iPad.png" : @"tabbar_meulocal_s.png"] autorelease];
	GTabTabItem *tabItemPesquisa = [[[GTabTabItem alloc] initWithFrame:(IF_IPAD)? CGRectMake(614.4, 0, 153.6, 49) : CGRectMake(256, 0, 64, 49) normalState:(IF_IPAD)? @"tabbar_pesquisa-iPad.png" : @"tabbar_pesquisa.png" toggledState:(IF_IPAD)? @"tabbar_pesquisa_s-iPad.png" : @"tabbar_pesquisa_s.png"] autorelease];
	
	// NACIONAIS
	NacionaisTableViewController *tabViewControllerNacionais = [[NacionaisTableViewController alloc] init];
	FeriadosCustomNavController *navNacionais = [[[FeriadosCustomNavController alloc] initWithNavControllerWithSubViewController:tabViewControllerNacionais] autorelease];
	[tabViewControllerNacionais release];
	
	// REGIONAIS
	RegionaisTableViewController *tabViewControllerRegionais = [[RegionaisTableViewController alloc] init];
	FeriadosCustomNavController *navRegionais = [[[FeriadosCustomNavController alloc] initWithNavControllerWithSubViewController:tabViewControllerRegionais] autorelease];
	[tabViewControllerRegionais release];
	
	// MUNICIPAIS
	MunicipaisTableViewController *tabViewControllerMunicipais = [[MunicipaisTableViewController alloc] initWithNibName:(IF_IPAD)? MUNICIPAIS_NIBNAME_IPAD : MUNICIPAIS_NIBNAME bundle:nil];
	FeriadosCustomNavController *navMunicipais = [[[FeriadosCustomNavController alloc] initWithNavControllerWithSubViewController:tabViewControllerMunicipais] autorelease];
	[tabViewControllerMunicipais release];
	
	// MEU LOCAL
	MeuLocalTableViewController *tabViewControllerMeuLocal = [[MeuLocalTableViewController alloc] init];
	FeriadosCustomNavController *navMeuLocal = [[[FeriadosCustomNavController alloc] initWithNavControllerWithSubViewController:tabViewControllerMeuLocal] autorelease];
	[tabViewControllerMeuLocal release];
	
	// PESQUISA
	PesquisaViewController *tabViewControllerPesquisa = [[PesquisaViewController alloc] initWithNibName:(IF_IPAD)? PESQUISA_NIBNAME_IPAD : PESQUISA_NIBNAME bundle:nil];
	FeriadosCustomNavController *navPesquisa = [[[FeriadosCustomNavController alloc] initWithNavControllerWithSubViewController:tabViewControllerPesquisa] autorelease];
	[tabViewControllerPesquisa release];
	
	NSMutableArray *viewControllersArray = [[NSMutableArray alloc] init];
	[viewControllersArray addObject:navNacionais];
	[viewControllersArray addObject:navRegionais];
	[viewControllersArray addObject:navMunicipais];
	[viewControllersArray addObject:navMeuLocal];
	[viewControllersArray addObject:navPesquisa];
		
	NSMutableArray *tabItemsArray = [[NSMutableArray alloc] init];
	[tabItemsArray addObject:tabItemNacionais];
	[tabItemsArray addObject:tabItemRegionais];
	[tabItemsArray addObject:tabItemMunicipais];
	[tabItemsArray addObject:tabItemMeuLocal];
	[tabItemsArray addObject:tabItemPesquisa];
	
	tabView = [[GTabBar alloc] initWithTabViewControllers:viewControllersArray tabItems:tabItemsArray initialTab:0];
	[self.window addSubview:tabView.view];
	
	// Fim do carregaento
    if (IF_IPAD) 
    {
        splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 768, 1024)];
        splashView.image = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
    }
    else
    {
        splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
        splashView.image = [UIImage imageNamed:@"Default.png"];
    }
    
	[self.window addSubview:splashView];
	[self.window bringSubviewToFront:splashView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:(IF_IPAD)? 1.5 : 1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
	[UIView commitAnimations];
	
	[self.window makeKeyAndVisible];
	[Appirater appLaunched:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    int quantDiasMes = 0;
    
    if ([CacheData existFile:Nacional ano:[[NSDate date] year]]) 
    {
        
        for (SHOLHoliday *feriado in [CacheData readSHOLArrayOfHolidayOfFile:Nacional ano:[[NSDate date] year] codeMunicipal:nil]) 
        {
            if([[NSDate date] year] == [feriado.Date year] && [[NSDate date] month] == [feriado.Date month] && [feriado.Date day] >= [[NSDate date] day])
            {
                quantDiasMes++;
            }
        }
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:quantDiasMes]; 
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    [Appirater appEnteredForeground:YES];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if (![CacheData existFile:Nacional ano:[[NSDate date] year]] && 
        (tabView.indexActivateController != 0 ||
        ([Utiles getAnoApp] != [[NSDate date] year] && tabView.indexActivateController == 0))) 
    {
        SHOLHolidays *service = [SHOLHolidays service];
        [service GetNationalHolidays:self action:@selector(GetNationalHolidaysHandler:) year: [[NSDate date] year]];
    }
    
	[[tabView.tabViewControllers objectAtIndex:tabView.indexActivateController] viewWillAppear:NO];
}

// Handle the response from GetNationalHolidays.
-(void) GetNationalHolidaysHandler: (id) value 
{
	if([value isKindOfClass: [NSError class]]) {
		// If an error has occurred, handle it
		return;
	}
    
	if([value isKindOfClass: [SoapFault class]]) { 
		// If a server error has occurred, handle it
		return;
	}			
	
	// Do something with the SHOLArrayOfHoliday* result
	SHOLArrayOfHoliday* result = (SHOLArrayOfHoliday*)value;
	
	if([result isKindOfClass: [SHOLArrayOfHoliday class]])
    {
        [CacheData saveSHOLArrayOfHolidayInFile:Nacional ano:[[NSDate date] year] data:result codeMunicipal:nil];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
	[tabView release];
    [super dealloc];
}


@end
