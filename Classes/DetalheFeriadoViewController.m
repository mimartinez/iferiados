//
//  DetalheFeriadoViewController.m
//  Feriados
//
//  Created by mimartinez on 11/02/21.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "DetalheFeriadoViewController.h"
#import "UINavigationBar+Custom.h"
#import "SHOLHoliday.h"
#import "SHOLMunicipality.h"
#import "NSDate+Utiles.h"
#import "Constantes.h"
#import "TopCell.h"
#import "MiddleCell.h"
#import "BottomCell.h"
#import "NSString+Utiles.h"
#import "FeriadosAppDelegate.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 310.0f
#define CELL_CONTENT_MARGIN 23.0f
#define FONT_SIZE_IPAD 20.0f
#define CELL_CONTENT_WIDTH_IPAD 640.0f
#define CELL_CONTENT_MARGIN_IPAD 70.0f

@implementation DetalheFeriadoViewController

@synthesize feriado;

#pragma mark -
#pragma mark View lifecycle


- (void)calculaHeightLabel:(UILabel*)label textOfLabel:(NSString*)text
{
	//Calculate the expected size based on the font and linebreak mode of your label
	CGSize maximumLabelSize = CGSizeMake(296,9999);
	
	CGSize expectedLabelSize = [text sizeWithFont:label.font 
								constrainedToSize:maximumLabelSize 
									lineBreakMode:label.lineBreakMode]; 
	
	//adjust the label the the new height.
	CGRect newFrame = label.frame;
	newFrame.size.height = expectedLabelSize.height;
	label.frame = newFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.opaque = NO;
	self.tableView.backgroundView = nil;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:(IF_IPAD)? @"background-iPad.png" : @"background.png"]];
	
	
	self.title = @"Detalhe do feriado";
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: (IF_IPAD)? @"Fondo_NavBar-iPad_Novo.png" : @"Fondo_NavBar.png"] forBarMetrics: UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = COLOR_ITEMNAVBAR;
    }
    
	[self.navigationController.navigationBar customTitle:self];
    
    NSMutableArray *arrayBtns = [NSMutableArray array];
    if ([MFMailComposeViewController canSendMail]) {
        [arrayBtns addObject:[UIImage imageNamed:@"email.png"]];
    }

    if ([feriado.Date isLaterThanDate:[NSDate date]] 
        && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.0) 
    {
        [arrayBtns addObject:[UIImage imageNamed:@"event.png"]];
    }
    
    // "Segmented" control to the right
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:arrayBtns];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, (40 * [arrayBtns count]), kCustomButtonHeight);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
    
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release];
    
	self.navigationItem.rightBarButtonItem = segmentBarItem;
    [segmentBarItem release];

}

- (void)enviaEmail
{
	NSString *info = nil;
	
	if ([self.feriado.Type isEqualToString:@"Municipal"]) {
		info = [NSString stringWithFormat:@"%@<br>Município de %@", [self.feriado.Date infoFeriado], self.feriado.Municipality.Name];
	}else {
		info = [self.feriado.Date infoFeriado];
	}
	
	NSString *tipo = [NSString stringWithFormat:@"Feriado %@", NSLocalizedString(self.feriado.Type, @"")];
	
	NSString *eMailBody = @"<table><tr><td valign='top' style='text-align:right'><b>Nome</b>:</td><td>%@</td></tr><tr><td valign='top' style='text-align:right'><b>Data</b>:</td><td>%@</td></tr><tr><td valign='top' style='text-align:right'><b>Tipo<b/>:</td><td>%@</td></tr><tr><td valign='top' style='text-align:right'><b>Informação<b/>:</td><td>%@</td></tr><tr><td valign='top' style='text-align:right'><b>Descrição<b/>:</td><td>%@</td></tr></table>";
	NSString *encodedBody = [NSString stringWithFormat:eMailBody,self.feriado.Name
							 ,[self.feriado.Date dateNameFull]
							 ,tipo
							 ,info
							 ,self.feriado.Description];
	
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.navigationBar.tag = NAVBAR_EMAIL;
	controller.navigationBar.barStyle = UIBarStyleBlackOpaque; 
    
    if([controller.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        [controller.navigationBar setBackgroundImage:[UIImage imageNamed: (IF_IPAD)? @"Fondo_NavBarEmail-iPad.png" : @"Fondo_NavBarEmail.png"] forBarMetrics: UIBarMetricsDefault];
        controller.navigationBar.tintColor = COLOR_ITEMNAVBAR;
    }
    
	controller.mailComposeDelegate = self;
	[controller setSubject:[NSString stringWithFormat:@"Feriado: %@", self.feriado.Name]];
	[controller setMessageBody:encodedBody isHTML:YES];
	FeriadosAppDelegate *appDelegate = (FeriadosAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.window viewWithTag:TABBARHOLDER_TAG].hidden = YES;
	[self presentModalViewController:controller animated:YES];
		
	[controller release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
	FeriadosAppDelegate *appDelegate = (FeriadosAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.window viewWithTag:TABBARHOLDER_TAG].hidden = NO;
	CGRect rectApp = [[UIScreen mainScreen] applicationFrame];
	self.navigationController.view.frame = CGRectMake(rectApp.origin.x, rectApp.origin.y, rectApp.size.width, rectApp.size.height - HEIGHT_TABBAR);
}

#pragma mark -
#pragma mark Add a new event

- (void)createEvent  
{

	EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = self.feriado.Name;
    event.startDate = self.feriado.Date;
    event.endDate   = self.feriado.Date;
    event.notes     = self.feriado.Description;
	event.allDay    = YES;
    [event addAlarm:[EKAlarm alarmWithRelativeOffset:0]];
    
    
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    addController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    addController.navigationBar.tintColor = COLOR_ITEMNAVBAR;
    
    // set the addController's event store to the current event store.
    addController.eventStore = eventStore;
    addController.event=event;
    
    addController.navigationBar.tag = NAVBAR_EVENT;
    
    if([addController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        [addController.navigationBar setBackgroundImage:[UIImage imageNamed: (IF_IPAD)? @"Fondo_NavBarEmail-iPad.png" : @"Fondo_NavBarEmail.png"] forBarMetrics: UIBarMetricsDefault];
        addController.navigationBar.tintColor = COLOR_ITEMNAVBAR;
    }
    
    FeriadosAppDelegate *appDelegate = (FeriadosAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.window viewWithTag:TABBARHOLDER_TAG].hidden = YES;
    // present EventsAddViewController as a modal view controller
    [self presentModalViewController:addController animated:YES];
    
    addController.editViewDelegate = self;
    [addController release];
}

#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller 
          didCompleteWithAction:(EKEventEditViewAction)action {
	
	NSError *error = nil;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing. 
			break;
		case EKEventEditViewActionSaved:
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			break;
			
		default:
			break;
	}
    
	// Dismiss the modal view controller
	[controller dismissModalViewControllerAnimated:YES];
    
    FeriadosAppDelegate *appDelegate = (FeriadosAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.window viewWithTag:TABBARHOLDER_TAG].hidden = NO;
	CGRect rectApp = [[UIScreen mainScreen] applicationFrame];
	self.navigationController.view.frame = CGRectMake(rectApp.origin.x, rectApp.origin.y, rectApp.size.width, rectApp.size.height - HEIGHT_TABBAR);
    
    if (action == EKEventEditViewActionSaved) 
    {
    if (error == noErr) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Evento criado com sucesso"
                              message:[NSString stringWithFormat:@"Criado um evento no calendário do dispositivo para o feriado \"%@\", na data \"%@\".", self.feriado.Name, [self.feriado.Date dateNameFull]]
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Erro evento"
                              message:[NSString stringWithFormat:@"Erro ao tentar criar um evento no calendário do dispositivo para o feriado %@, na data %@.", self.feriado.Name, [self.feriado.Date dateNameFull]]
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    }
}

- (IBAction)segmentAction:(id)sender
{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            if ([MFMailComposeViewController canSendMail]) {
                [self enviaEmail];
            }
            else
            {
                [self createEvent];    
            }
            break;
        case 1:
            [self createEvent];
            break;
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	CGFloat height = 0;
  if (indexPath.row == 0) {
	  height = (IF_IPAD)? 98.0f : 85.0f;
  }
  else if (indexPath.row == 1) {
	  height = (IF_IPAD)? 92.0f : 57.0f;
  }
  else
  {
	  NSString *text = nil;
	  
	  if (indexPath.row == 2) {
		  if ([self.feriado.Type isEqualToString:@"Municipal"]) {
			  text = [NSString stringWithFormat:@"%@\nMunicípio de %@", [self.feriado.Date infoFeriado], self.feriado.Municipality.Name];
		  }else {
			  text = [self.feriado.Date infoFeriado];
		  }
	  }else {
		  text = self.feriado.Description;
	  }
	  
	  CGSize constraint = CGSizeMake((IF_IPAD)? CELL_CONTENT_WIDTH_IPAD : CELL_CONTENT_WIDTH - ((IF_IPAD)? CELL_CONTENT_MARGIN_IPAD : CELL_CONTENT_MARGIN * 2), 20000.0f);
	  
	  CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:(IF_IPAD)? FONT_SIZE_IPAD : FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	  
	  height = MAX(size.height, 20.0f) + ((IF_IPAD)? CELL_CONTENT_MARGIN_IPAD : CELL_CONTENT_MARGIN * 2);
  }

	return height;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifierTop = @"TopCell";
	static NSString *CellIdentifierMiddle = @"MiddleCell";
	static NSString *CellIdentifierInfo = @"InfoCell";
	static NSString *CellIdentifierBottom = @"BottomCell";
	
	if (indexPath.row == 0) {
	TopCell *cell = (TopCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierTop];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:(IF_IPAD)? @"TopCell-iPad" : @"TopCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[TopCell class]]) {
				cell = (TopCell*)currentObject;
				break;
			}
		}
    }
		if([self.feriado.Date isEarlierToDateIgnoringTime:[NSDate date]]) 
		{
			cell.dia.textColor = [UIColor colorWithRed:0.50 green:0 blue:0 alpha:0.7];
		}
		
		cell.nomeText.text = self.feriado.Name;
		cell.nomeMes.text = [self.feriado.Date dateNameMonth];
		cell.dia.text = [NSString stringWithFormat:@"%d", [self.feriado.Date day]];
		[self calculaHeightLabel:cell.nomeText textOfLabel:self.feriado.Name];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		return cell;
	}
	else if(indexPath.row == 1)
	{
		MiddleCell *cell = (MiddleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierMiddle];
		if (cell == nil) {
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:(IF_IPAD)? @"MiddleCell-iPad" : @"MiddleCell" owner:self options:nil];
			
			for (id currentObject in topLevelObjects) {
				if ([currentObject isKindOfClass:[MiddleCell class]]) {
					cell = (MiddleCell*)currentObject;
					break;
				}
			}
		}
		
		if([self.feriado.Date isEarlierToDateIgnoringTime:[NSDate date]]) 
		{
			cell.dataFeriado.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
		}
		
		cell.dataFeriado.text = [self.feriado.Date dateNameFull];
		cell.tipoFeriado.text = [NSString stringWithFormat:@"Feriado %@", NSLocalizedString(self.feriado.Type, @"")];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
		
	}
	else
	{
		BottomCell *cell = (indexPath.row == 2)?(BottomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierInfo]:(BottomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierBottom];
		if (cell == nil) {
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:(IF_IPAD)? @"BottomCell-iPad" : @"BottomCell" owner:self options:nil];
			
			for (id currentObject in topLevelObjects) {
				if ([currentObject isKindOfClass:[BottomCell class]]) {
					cell = (BottomCell*)currentObject;
					break;
				}
			}
		}

		NSString *text = nil;
		
		if (indexPath.row == 2) {
			if ([self.feriado.Type isEqualToString:@"Municipal"]) {
				text = [NSString stringWithFormat:@"%@\nMunicípio de %@", [self.feriado.Date infoFeriado], self.feriado.Municipality.Name];
			}else {
				text = [self.feriado.Date infoFeriado];
			}
			cell.titleLabel.text = @"Informação";
            cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, cell.titleLabel.frame.size.width + 8, cell.titleLabel.frame.size.height);
		}else {
			text = self.feriado.Description;
			cell.titleLabel.text = @"Descrição";
		}

		CGSize constraint = CGSizeMake((IF_IPAD)? CELL_CONTENT_WIDTH_IPAD : CELL_CONTENT_WIDTH - ((IF_IPAD)? CELL_CONTENT_MARGIN_IPAD : CELL_CONTENT_MARGIN * 2), 20000.0f);
		
		CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:(IF_IPAD)? FONT_SIZE_IPAD : FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		
		cell.descricao.text = text;
		[cell.descricao setFrame:CGRectMake(cell.descricao.frame.origin.x, cell.descricao.frame.origin.y, (IF_IPAD)? CELL_CONTENT_WIDTH_IPAD : CELL_CONTENT_WIDTH - ((IF_IPAD)? CELL_CONTENT_MARGIN_IPAD : CELL_CONTENT_MARGIN * 2), MAX(size.height, 20.0f))];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}

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
	[self.feriado release];
    [super dealloc];
}


@end

