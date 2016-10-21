//
//  MunicipaisTableViewController.m
//  Feriados
//
//  Created by mimartinez on 11/02/15.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "MunicipaisTableViewController.h"
#import "UINavigationBar+Custom.h"
#import "UIView+Utiles.h"
#import "Utiles.h"
#import "Constantes.h"
#import "FeriadosMunicipaisTableViewController.h"

#define TITLE_VIEW @"Municípios";

@interface MunicipaisTableViewController()
@property (retain) NSMutableDictionary *municipios;
@property (retain) NSArray *sections;
@end

@implementation MunicipaisTableViewController

@synthesize municipios;
@synthesize sections;
@synthesize selecionaAnoViewController;
@synthesize filteredListContent;
@synthesize savedSearchTerm;
@synthesize searchWasActive;

#pragma mark -
#pragma mark View lifecycle

- (NSMutableDictionary *)setupArrayMunicipios:(NSArray *)anArray
{
	NSMutableDictionary *dictionaryResult = [NSMutableDictionary dictionary];
	for (int i = 0; i < anArray.count ; i++) 
	{							
		NSDictionary *itemMunicipio = [[NSDictionary alloc] initWithDictionary:[anArray objectAtIndex:i]];
		
		// Lee la primera letra del Lugar para despues guardar en el diccionario
		NSString *firstLetter = [[itemMunicipio objectForKey:@"Nome"] substringToIndex:1];
		NSMutableArray *existingArray = [dictionaryResult objectForKey:firstLetter];
        
		if (existingArray != nil) 
		{
			[existingArray addObject:itemMunicipio];
		} else {
			NSMutableArray *tempArray = [NSMutableArray array];
			[dictionaryResult setObject:tempArray forKey:firstLetter];
			[tempArray addObject:itemMunicipio];
		}
		
		// Libera el objeto para usar en varios arrays
		[itemMunicipio release];
	}
	
	return [[dictionaryResult mutableCopy] autorelease];
}

- (void)presortElementNamesForInitialLetter:(NSString *)aKey 
{
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Nome"
																   ascending:YES
																	selector:@selector(localizedCaseInsensitiveCompare:)] ;
	
	NSArray *descriptors = [NSArray arrayWithObject:nameDescriptor];
	[[self.municipios objectForKey:aKey] sortUsingDescriptors:descriptors];
	[nameDescriptor release];
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	self.searchDisplayController.searchBar.tintColor = COLOR_SEARCHBAR;
	self.searchDisplayController.searchBar.placeholder = @"Pesquisar município";
	self.searchDisplayController.searchBar.autocorrectionType       = UITextAutocorrectionTypeNo;
	self.searchDisplayController.searchBar.autocapitalizationType   = UITextAutocapitalizationTypeNone;
	
	// Load the data.
	NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Municipios" ofType:@"plist"];
	NSArray *arrayData = [NSArray arrayWithContentsOfFile:dataPath];
	
	// create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[arrayData count]];
	
	self.municipios = [self setupArrayMunicipios:arrayData];
	self.sections = [[self.municipios allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	for (NSString *keyLetter in self.sections) {
		[self presortElementNamesForInitialLetter:keyLetter];
	}
	
	// Botão com o ano
	UIBarButtonItem *anoButton = [[[UIBarButtonItem alloc] initWithTitle:@""
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(anoAction:)] autorelease];
	self.navigationItem.rightBarButtonItem = anoButton;
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.rowHeight = 40;
	self.searchDisplayController.searchResultsTableView.rowHeight = 40;
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:(IF_IPAD)? @"background-iPad.png" : @"background.png"]];
	self.tableView.backgroundColor = [UIColor clearColor];
	self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:(IF_IPAD)? @"background-iPad.png" : @"background.png"]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.title = TITLE_VIEW;
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: (IF_IPAD)? @"Fondo_NavBar-iPad_Novo.png" : @"Fondo_NavBar.png"] forBarMetrics: UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = COLOR_ITEMNAVBAR;
    }
    
	[self.navigationController.navigationBar customTitle:self];
	
	self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%d", [Utiles getAnoApp]];
	
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.filteredListContent = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return 1;
    }
	else
	{
        return self.sections.count;
    }		
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
		return [self.filteredListContent count];
	else {
		return [[self.municipios objectForKey:[self.sections objectAtIndex:section]] count];
	}
}

- (NSDictionary *)municipiosAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *municipiosInSection = [self.municipios objectForKey:[self.sections objectAtIndex:indexPath.section]];
	return [municipiosInSection objectAtIndex:indexPath.row];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	const NSInteger LABEL_TAG = 1001;
	UILabel *label;
	
    static NSString *CellIdentifier = @"UITableViewCellMunicipios";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =
		[[[UITableViewCell alloc]
		  initWithStyle:UITableViewCellStyleDefault
		  reuseIdentifier:CellIdentifier]
		 autorelease];
    
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		const CGFloat LABEL_HEIGHT = 20;
		
		// Criar label
		label =
		[[[UILabel alloc]
		  initWithFrame:
		  CGRectMake( 20, ((tableView.rowHeight - LABEL_HEIGHT) * 0.4),
					 tableView.bounds.size.width - 4.0 * cell.indentationWidth, LABEL_HEIGHT)]
		 autorelease];
		
		[cell.contentView addSubview:label];
		
		
		// Configurar texto para label
		label.tag = LABEL_TAG;
		label.backgroundColor = [UIColor clearColor];
		label.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		label.font = [UIFont boldSystemFontOfSize:15];
		
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
		label = (UILabel *)[cell viewWithTag:LABEL_TAG];	
	}

	if (tableView == self.searchDisplayController.searchResultsTableView) {
		label.text = [[self.filteredListContent objectAtIndex:indexPath.row] objectForKey:@"Nome"];
	}else {
		label.text = [[self municipiosAtIndexPath:indexPath] objectForKey:@"Nome"];
	}

    UIImage *rowBackground = [UIImage imageNamed:(IF_IPAD)? @"rowSimple-iPad.png" : @"middleRowSimple.png"];
	UIImage *selectionBackground = [UIImage imageNamed:(IF_IPAD)? @"rowSimpleSelected-iPad.png" : @"middleRowSimpleSelected.png"];
	
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView){
		return @"Resultados da pesquisa";
	}else {
		return [self.sections objectAtIndex:section];
	}
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if (tableView == self.searchDisplayController.searchResultsTableView) return nil;

	return self.sections;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	self.title = TITLE_VIEW;
	
	FeriadosMunicipaisTableViewController *detailsViewController = [[FeriadosMunicipaisTableViewController alloc] init];
	NSDictionary *itemMunicipio = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        itemMunicipio = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        itemMunicipio = [self municipiosAtIndexPath:indexPath];
    }

	detailsViewController.municipio = itemMunicipio;    
    [[self navigationController] pushViewController:detailsViewController animated:YES];
    [detailsViewController release];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{	
	[self.filteredListContent removeAllObjects];

	NSMutableArray *searchArray = [[NSMutableArray alloc] init];

	for (NSString *nomeSection in self.sections)
	{
		NSArray *array = [self.municipios objectForKey:nomeSection];
		[searchArray addObjectsFromArray:array];
	}
	
	for (NSDictionary *municipio in searchArray)
	{

		NSComparisonResult result = [[municipio objectForKey:@"Nome"] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			[self.filteredListContent addObject:municipio];
		}
	}
	
	[searchArray release];
}

#pragma mark -
#pragma mark Search Bar 

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {  
	 searchBar.showsScopeBar = YES;  
     [searchBar sizeToFit];
     [searchBar setShowsCancelButton:YES animated:YES]; 
     return YES;  
}  
   
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {  
     searchBar.showsScopeBar = NO;  
     [searchBar sizeToFit];  
     [searchBar setShowsCancelButton:NO animated:YES]; 
     return YES;  
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
	controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	controller.searchResultsTableView.rowHeight = 40;
	controller.searchResultsTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:(IF_IPAD)? @"background-iPad.png" : @"background.png"]];	
	
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}


- (void)dealloc {
	if (self.selecionaAnoViewController != nil) 
	{
		[self.selecionaAnoViewController release];
	}
	
	[self.municipios release];
	[self.sections release];
	[self.filteredListContent release];

    [super dealloc];
}


@end

