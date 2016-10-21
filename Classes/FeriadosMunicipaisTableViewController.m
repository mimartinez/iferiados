//
//  FeriadosMunicipaisTableViewController.m
//  Feriados
//
//  Created by mimartinez on 11/02/24.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "FeriadosMunicipaisTableViewController.h"
#import "NSDate+Utiles.h"
#import "SHOLHolidays.h"
#import "SHOLHoliday.h"
#import "SHOLMunicipality.h"
#import "SHOLArrayOfHoliday.h"
#import "NSDate+Utiles.h"
#import "UINavigationBar+Custom.h"
#import "DetalheFeriadoViewController.h"
#import "UIView+Utiles.h"
#import "Constantes.h"
#import "Utiles.h"
#import "CacheData.h"
#import "ExtraHolidays.h"

@interface FeriadosMunicipaisTableViewController()
@property (retain) SHOLArrayOfHoliday *arrayHolidayMunicipal;
@end

@implementation FeriadosMunicipaisTableViewController

@synthesize selecionaAnoViewController;
@synthesize arrayHolidayMunicipal;
@synthesize municipio;
@synthesize extraHolidays;


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

-(void)refreshTableAnimate
{
	NSMutableArray *indexPaths = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < [self.arrayHolidayMunicipal count]; i++) {
		NSIndexPath *updatedPath = [NSIndexPath indexPathForRow:i inSection:0];
		[indexPaths addObject:updatedPath];
	}
	
	[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)loadMunicipalHolidays
{
	self.tableView.hidden = YES;
    
    if ([CacheData existFileMunicipal:[Utiles getAnoApp] codeMunicipal:[self.municipio objectForKey:@"Id"]]) 
    {
        self.arrayHolidayMunicipal = [CacheData readSHOLArrayOfHolidayOfFile:Municipal ano:[Utiles getAnoApp] codeMunicipal:[self.municipio objectForKey:@"Id"]];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        [self refreshTableAnimate];
    }
    else
    {
        [self showHUD];
        self.extraHolidays = [[ExtraHolidays alloc] initWithMunicipality:self.municipio];
        self.extraHolidays.delegate = self;
        [self.extraHolidays getExtraHoliday];
    }
    
	self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%d", [Utiles getAnoApp]];
}

// Handle the response from GetHolidaysByMunicipalityId.
-(void)GetHolidaysByMunicipalityIdHandler: (id) value {
	
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSError *erro = (NSError*)value; 
		if (erro.code == -1009) {
            [HUD hide:true];
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ligação de dados indisponível" 
																message:@"É necessário dispor de uma ligação à internet para aceder ao serviço e dispor de todas as funcionalidades da aplicação." 
															   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		
		return;
	}
	
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		[HUD hide:true];
		SoapFault *soap = (SoapFault*)value;
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Serviço" 
															message:[NSString stringWithFormat:@"Impossível conectar ao serviço.\nPor favor tente mais tarde.\n%@",
																	 [soap description]]
														   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
		return;
	}				
	
	// Do something with the SHOLArrayOfHoliday* result
	SHOLArrayOfHoliday* result = (SHOLArrayOfHoliday*)value;
	
	if([result isKindOfClass: [SHOLArrayOfHoliday class]]) 
    {
		self.arrayHolidayMunicipal = result;
		
		NSMutableArray *discardedItems = [NSMutableArray array];
		
		for (SHOLHoliday *feriado in self.arrayHolidayMunicipal) 
		{
			if ([feriado.Name isEqualToString:[self.municipio objectForKey:@"Nome"]]
				|| [feriado.Municipality.Name isEqualToString:[self.municipio objectForKey:@"Nome"]]) 
			{
					if ([feriado.Municipality.Name isEqualToString:@"N/A"]) 
					{
						feriado.Municipality.Name = [self.municipio objectForKey:@"Nome"];
						
						if (![feriado.Description isEqualToString:@"N/A"]) 
						{
							feriado.Name = feriado.Description;
						}
					}
					else if(![[self.municipio objectForKey:@"Nome"] isEqualToString:feriado.Municipality.Name])
					{
						NSString *descricao = [NSString stringWithString:feriado.Municipality.Name];
						NSString *nome = [NSString stringWithString:feriado.Description];
						feriado.Description = descricao;
						feriado.Name = nome;
						feriado.Municipality.Name = [self.municipio objectForKey:@"Nome"];;
					}
			}else {
				[discardedItems addObject:feriado];
			}
		}
        		
		[self.arrayHolidayMunicipal removeObjectsInArray:discardedItems];
            
        if ([self.arrayHolidayMunicipal count] > 0) 
        // Inserir aqui o save na cache
        [CacheData saveSHOLArrayOfHolidayInFile:Municipal ano:[Utiles getAnoApp] data:self.arrayHolidayMunicipal codeMunicipal:[self.municipio objectForKey:@"Id"]];
        
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        [HUD hide:true];
        [self refreshTableAnimate];
    }
}

-(void)didFinishExtraHolidaysInfo:(ExtraHolidays *)extraHolidays
{
    // Handle errors
	if(self.extraHolidays.erro != nil) 
    { 
		if (self.extraHolidays.erro.code == -1009) {
            [HUD hide:true];
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ligação de dados indisponível" 
																message:@"É necessário dispor de uma ligação à internet para aceder ao serviço e dispor de todas as funcionalidades da aplicação." 
															   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		
		return;
	}
	
	// Handle faults
	if(self.extraHolidays.soap != nil) {
		[HUD hide:true];
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Serviço" 
															message:[NSString stringWithFormat:@"Impossível conectar ao serviço.\nPor favor tente mais tarde.\n%@",
																	 [self.extraHolidays.soap description]]
														   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
		return;
	}		
    
    self.arrayHolidayMunicipal = self.extraHolidays.arrayFeriados;
    
    if ([self.arrayHolidayMunicipal count] > 0)
    {
        // Inserir aqui o save na cache
       [CacheData saveSHOLArrayOfHolidayInFile:Municipal ano:[Utiles getAnoApp] data:self.arrayHolidayMunicipal codeMunicipal:[self.municipio objectForKey:@"Id"]];
    
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        [HUD hide:true];
        [self refreshTableAnimate];
    
        [self.extraHolidays release];
    }
    else
    {
        SHOLHolidays *service = [SHOLHolidays service];
        [service GetHolidaysByMunicipalityId:self action:@selector(GetHolidaysByMunicipalityIdHandler:) year:[Utiles getAnoApp] municipalityId:[self.municipio objectForKey:@"Id"]];
    }
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    // Botão com o ano
	UIBarButtonItem *anoButton = [[[UIBarButtonItem alloc] initWithTitle:@""
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(anoAction:)] autorelease];
	self.navigationItem.rightBarButtonItem = anoButton;
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.rowHeight = (IF_IPAD)? 80 : 50;
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:(IF_IPAD)? @"background-iPad.png" : @"background.png"]];
	self.tableView.backgroundColor = [UIColor clearColor];	
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
		[self loadMunicipalHolidays];
	}
	
	[self.selecionaAnoViewController release];
}


- (void)viewWillAppear:(BOOL)animated {
	
	self.title = [self.municipio objectForKey:@"Nome"];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: (IF_IPAD)? @"Fondo_NavBar-iPad_Novo.png" : @"Fondo_NavBar.png"] forBarMetrics: UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = COLOR_ITEMNAVBAR;
    }
    
	[self.navigationController.navigationBar customTitle:self];
	
	if (!self.arrayHolidayMunicipal || [self.navigationItem.rightBarButtonItem.title intValue] != [Utiles getAnoApp]) 
	{
		[self loadMunicipalHolidays];
	}
	
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.arrayHolidayMunicipal count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    const NSInteger IMAGE_SIZE_WIDTH = (IF_IPAD)? 85 : 48;
	const NSInteger NOMEDIASEMANA_LABEL_TAG = 1001;
	const NSInteger NOMEFERIADO_LABEL_TAG = 1002;
	const NSInteger DIASEMANA_LABEL_TAG = 1003;
	const NSInteger NOMEMES_LABEL_TAG = 1004;
	UILabel *labelNomeDataCompleta;
	UILabel *labelNomeFeriado;
	UILabel *labelDiaSemana;
	UILabel *labelNomeMes;
	
	SHOLHoliday *feriado = (SHOLHoliday *)[self.arrayHolidayMunicipal objectAtIndex:indexPath.row];
	static NSString *CellIdentifierNormal = @"FeriadoTableViewCell";
	static NSString *CellIdentifierPasado = @"FeriadoPasadoTableViewCell";
	
	UITableViewCell *cell = ([feriado.Date isEarlierToDateIgnoringTime:[NSDate date]])?[tableView dequeueReusableCellWithIdentifier:CellIdentifierPasado] :[tableView dequeueReusableCellWithIdentifier:CellIdentifierNormal];
	
	if (cell == nil)
	{
		if ([feriado.Date isEarlierToDateIgnoringTime:[NSDate date]]) {
			cell =
			[[[UITableViewCell alloc]
			  initWithStyle:UITableViewCellStyleDefault
			  reuseIdentifier:CellIdentifierPasado]
			 autorelease];
		}else
		{
			cell =
			[[[UITableViewCell alloc]
			  initWithStyle:UITableViewCellStyleDefault
			  reuseIdentifier:CellIdentifierNormal]
			 autorelease];
		}
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		const CGFloat LABEL_NOMEDIASEMANA_HEIGHT = (IF_IPAD)? 24 : 15;
		const CGFloat LABEL_NOMEFERIADO_HEIGHT = (IF_IPAD)? 27 : 20;
		const CGFloat LABEL_DIASEMANA_HEIGHT = (IF_IPAD)? 37 : 30;
		const CGFloat LABEL_NOMEMES_HEIGHT = (IF_IPAD)? 18 : 11;
		
		// Criar label para o nome dia da semana
		labelNomeDataCompleta =
		[[[UILabel alloc]
		  initWithFrame:
		  CGRectMake(
					 IMAGE_SIZE_WIDTH + 2.0 * cell.indentationWidth,
					 (0.5 * (tableView.rowHeight - 2 * LABEL_NOMEDIASEMANA_HEIGHT)) - 3,
					 tableView.bounds.size.width -
					 IMAGE_SIZE_WIDTH - 4.0 * cell.indentationWidth,
					 LABEL_NOMEDIASEMANA_HEIGHT)]
		 autorelease];
		[cell.contentView addSubview:labelNomeDataCompleta];
		
		// Configurar texto para nome dia da semana
		labelNomeDataCompleta.tag = NOMEDIASEMANA_LABEL_TAG;
		labelNomeDataCompleta.backgroundColor = [UIColor clearColor];
		//labelNomeDataCompleta.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
		labelNomeDataCompleta.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		labelNomeDataCompleta.font = [UIFont systemFontOfSize:(IF_IPAD)? 20 : 13];
		
		// Criar label para nome do feriado
		labelNomeFeriado =
		[[[UILabel alloc]
		  initWithFrame:
		  CGRectMake(
					 IMAGE_SIZE_WIDTH + 2.0 * cell.indentationWidth,
					 (0.5 * (tableView.rowHeight - 2 * LABEL_NOMEFERIADO_HEIGHT) + LABEL_NOMEFERIADO_HEIGHT) - 4,
					 tableView.bounds.size.width -
					 IMAGE_SIZE_WIDTH - 4.0 * cell.indentationWidth,
					 LABEL_NOMEFERIADO_HEIGHT)]
		 autorelease];
		[cell.contentView addSubview:labelNomeFeriado];
		
		
		// Configurar texto para nome do feriado
		labelNomeFeriado.tag = NOMEFERIADO_LABEL_TAG;
		labelNomeFeriado.backgroundColor = [UIColor clearColor];
		//labelNomeFeriado.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
		labelNomeFeriado.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		labelNomeFeriado.font = (IF_IPAD)? [UIFont boldSystemFontOfSize:[UIFont labelFontSize] + 5] : [UIFont boldSystemFontOfSize:[UIFont labelFontSize] - 2];
		
		// Criar label para o dia da semana
		labelDiaSemana =
		[[[UILabel alloc]
		  initWithFrame:
		  CGRectMake(
					 (IMAGE_SIZE_WIDTH / 2) - ((IF_IPAD)? 28 : 14),
					 ((tableView.rowHeight - LABEL_DIASEMANA_HEIGHT) * 0.5) + 4,
					 IMAGE_SIZE_WIDTH,
					 LABEL_DIASEMANA_HEIGHT)]
		 autorelease];
		[cell.contentView addSubview:labelDiaSemana];
		
		
		// Configurar texto para o dia da semana
		labelDiaSemana.tag = DIASEMANA_LABEL_TAG;
		labelDiaSemana.backgroundColor = [UIColor clearColor];
		//labelDiaSemana.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
		labelDiaSemana.highlightedTextColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
		labelDiaSemana.font = [UIFont boldSystemFontOfSize:(IF_IPAD)? 33 : 26];
		labelDiaSemana.textAlignment = UITextAlignmentCenter;
		
		
		// Criar label para o nome do mes
		labelNomeMes =
		[[[UILabel alloc]
		  initWithFrame:
		  CGRectMake(
					 (IMAGE_SIZE_WIDTH / 2) - ((IF_IPAD)? 27 : 14),
					 ((tableView.rowHeight - LABEL_NOMEMES_HEIGHT) * 0.1),
					 IMAGE_SIZE_WIDTH,
					 LABEL_NOMEMES_HEIGHT)]
		 autorelease];
		[cell.contentView addSubview:labelNomeMes];
		
		
		// Configurar texto para o nome do mes
		labelNomeMes.tag = NOMEMES_LABEL_TAG;
		labelNomeMes.backgroundColor = [UIColor clearColor];
		labelNomeMes.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
		labelNomeMes.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		labelNomeMes.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(IF_IPAD)? 14.0 : 9.0];
		labelNomeMes.textAlignment = UITextAlignmentCenter;
		
		// Compara as datas para o estilo
		if([feriado.Date isEarlierToDateIgnoringTime:[NSDate date]]) 
		{
			labelNomeDataCompleta.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
			labelNomeFeriado.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
			labelDiaSemana.textColor = [UIColor colorWithRed:0.50 green:0 blue:0 alpha:0.7];
		}
		else 
		{
			labelNomeDataCompleta.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
			labelNomeFeriado.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
			labelDiaSemana.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
		}
		
		//
		// Create a background image view.
		//
		cell.backgroundView =
		[[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
		[[[UIImageView alloc] init] autorelease];
	}
	else
	{
		labelNomeDataCompleta = (UILabel *)[cell viewWithTag:NOMEDIASEMANA_LABEL_TAG];
		labelNomeFeriado = (UILabel *)[cell viewWithTag:NOMEFERIADO_LABEL_TAG];
		labelDiaSemana = (UILabel *)[cell viewWithTag:DIASEMANA_LABEL_TAG];
		labelNomeMes = (UILabel *)[cell viewWithTag:NOMEMES_LABEL_TAG];
	}
	
	labelDiaSemana.text = [NSString stringWithFormat:@"%d", [feriado.Date day]];
	labelNomeDataCompleta.text = [NSString stringWithFormat:@"%@, %d de %@ %d", 
								  [feriado.Date dateNameDay], 
								  [feriado.Date day],
								  [feriado.Date dateNameMonthQuatro],
								  [feriado.Date year]];
	labelNomeFeriado.text = feriado.Name;
	labelNomeMes.text = [feriado.Date dateNameMonth];
	
	//
	// Set the background and selected background images for the text.
	// Since we will round the corners at the top and bottom of sections, we
	// need to conditionally choose the images based on the row index and the
	// number of rows in the section.
	//
	UIImage *rowBackground;
	UIImage *selectionBackground;
    
    if (IF_IPAD) {
        rowBackground = [UIImage imageNamed:@"row-iPad.png"];
		selectionBackground = [UIImage imageNamed:@"rowSelected-iPad.png"];
    }
    else
    {
	NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
	NSInteger row = [indexPath row];
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
    }
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	self.title = @"Voltar";
	SHOLHoliday *feriado = (SHOLHoliday *)[self.arrayHolidayMunicipal objectAtIndex:indexPath.row];
	DetalheFeriadoViewController *detalhe = [[DetalheFeriadoViewController alloc] initWithStyle:UITableViewStyleGrouped];
	detalhe.feriado = feriado;
	[self.navigationController pushViewController:detalhe animated:YES];
    [detalhe release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	if (self.selecionaAnoViewController != nil) 
	{
		[self.selecionaAnoViewController release];
	}
    
    if (self.extraHolidays != nil) 
    {
        [self.extraHolidays release];
    }
    
	[self.arrayHolidayMunicipal release];
	[self.municipio release];
    [super dealloc];
}


@end

