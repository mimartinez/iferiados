//
//  PesquisaViewController.m
//  Feriados
//
//  Created by mimartinez on 11/02/08.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "PesquisaViewController.h"
#import "UINavigationBar+Custom.h"
#import "Utiles.h"
#import "UIView+Utiles.h"
#import "SHOLHolidays.h"
#import "SHOLHoliday.h"
#import "SHOLMunicipality.h"
#import "DetalheFeriadoViewController.h"
#import "Constantes.h"
#import "CacheData.h"

#define TITLE_VIEW @"Móveis"

@implementation PesquisaViewController

@synthesize btnCarnaval;
@synthesize btnCorpoDeDeus;
@synthesize btnPascoa;
@synthesize btnSextaSanta;
@synthesize selecionaAnoViewController;
@synthesize tipoFeriado;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:(IF_IPAD)? @"background-iPad.png" : @"background.png"]];
	
	// Botão com o ano
	UIBarButtonItem *anoButton = [[[UIBarButtonItem alloc] initWithTitle:@""
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(anoAction:)] autorelease];
	self.navigationItem.rightBarButtonItem = anoButton;
}

- (IBAction)anoAction:(id)sender
{
	self.selecionaAnoViewController = [[SelecionaAnoViewController alloc] initWithNibName:(IF_IPAD)? @"SelecionaAnoViewController-iPad" : @"SelecionaAnoViewController" bundle:nil];
	self.selecionaAnoViewController.delegate = self;
	[self.selecionaAnoViewController.view showModal];
}

- (void)selecionaAnoViewController:(SelecionaAnoViewController *)controller didFinishSelecionaAnoWithInfo:(NSNumber *)anoInfo
{
	if ([anoInfo intValue] != 0 && [anoInfo intValue] != [Utiles getAnoApp]) 
	{
		[Utiles saveAnoApp:[anoInfo intValue]];
		self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%d", [Utiles getAnoApp]];
	}
	
	[self.selecionaAnoViewController release];
}

- (void)viewWillAppear:(BOOL)animated 
{
    self.title = TITLE_VIEW;
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: (IF_IPAD)? @"Fondo_NavBar-iPad_Novo.png" : @"Fondo_NavBar.png"] forBarMetrics: UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = COLOR_ITEMNAVBAR;
    }
    
	[self.navigationController.navigationBar customTitle:self];
	self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%d", [Utiles getAnoApp]];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

-(void)showHUD
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Carregando";
	[HUD show:YES];
}

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)enviaFeriadoParaDetalhe:(SHOLHoliday*)feriado
{
	self.title = TITLE_VIEW;
	DetalheFeriadoViewController *detalhe = [[DetalheFeriadoViewController alloc] initWithStyle:UITableViewStyleGrouped];
	detalhe.feriado = feriado;
	[self.navigationController pushViewController:detalhe animated:YES];
    [detalhe release];
}

- (void)loadFeriado:(TipoFeriado)tipo
{
    if ([CacheData existFileMovil:[Utiles getAnoApp] tipoFeriado:tipo]) 
    {
        [self enviaFeriadoParaDetalhe:[CacheData readSHOLHolidayOfFile:[Utiles getAnoApp] tipoFeriado:tipo]];
    }
    else
    {
        [self showHUD];
        self.tipoFeriado = tipo;
        SHOLHolidays *service = [SHOLHolidays service];
	
        switch (tipo) {
            case Carnaval:
                [service GetCarnival:self action:@selector(GetSHOLHolidaysHandler:) year: [Utiles getAnoApp]];
                break;
            case CorpoDeDeus:
                [service GetCorpusChristi:self action:@selector(GetSHOLHolidaysHandler:) year: [Utiles getAnoApp]];
                break;
            case Pascoa:
                [service GetEaster:self action:@selector(GetSHOLHolidaysHandler:) year: [Utiles getAnoApp]];
                break;
            case SextaSanta:
                [service GetGoodFriday:self action:@selector(GetSHOLHolidaysHandler:) year: [Utiles getAnoApp]];
                break;
            default:
                break;
        }
    }	
}

- (void)mostraAlertLigacaoIndisponivel
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ligação de dados indisponível" 
														message:@"É necessário dispor de uma ligação à internet para aceder ao serviço e dispor de todas as funcionalidades da aplicação." 
													   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)mostraAlertServicoindisponivel:(NSString*)descricao
{
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Serviço" 
														message:[NSString stringWithFormat:@"Impossível conectar ao serviço.\nPor favor tente mais tarde.\n%@"
																 ,descricao]
													   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

// Handle the response.
-(void) GetSHOLHolidaysHandler: (id) value {
	
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSError *erro = (NSError*)value; 
		if (erro.code == -1009) {
            [HUD hide:true];
			[self mostraAlertLigacaoIndisponivel];
		}
		return;
	}
	
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		[HUD hide:true];
		SoapFault *soap = (SoapFault*)value;
		[self mostraAlertServicoindisponivel:[soap description]];
		return;
	}				
	
	// Do something with the SHOLHoliday* result
	SHOLHoliday* result = (SHOLHoliday*)value;
	
    [HUD hide:true];
	if([result isKindOfClass: [SHOLHoliday class]]) {
        [CacheData saveSHOLHolidayInFile:[Utiles getAnoApp] data:result tipoFeriado:self.tipoFeriado];
		[self enviaFeriadoParaDetalhe:result];
	}
}

- (IBAction)actionCarnaval:(id)sender
{
	[self loadFeriado:Carnaval];
}

- (IBAction)actionCorpoDeus:(id)sender
{
	[self loadFeriado:CorpoDeDeus];
}

- (IBAction)actionPascoa:(id)sender
{
	[self loadFeriado:Pascoa];
}

- (IBAction)actionSextaSanta:(id)sender
{
	[self loadFeriado:SextaSanta];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.btnCarnaval = nil;
	self.btnCorpoDeDeus = nil;
	self.btnPascoa = nil;
	self.btnSextaSanta = nil;
}


- (void)dealloc {
	[self.btnCarnaval release];
	[self.btnCorpoDeDeus release];
	[self.btnPascoa release];
	[self.btnSextaSanta release];
    [super dealloc];
}


@end
