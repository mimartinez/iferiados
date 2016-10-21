//
//  MunicipaisTableViewController.h
//  Feriados
//
//  Created by mimartinez on 11/02/15.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelecionaAnoViewController.h"

@interface MunicipaisTableViewController : UITableViewController <SelecionaAnoViewControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
	NSMutableDictionary *municipios;
	NSArray *sections;
	NSMutableArray *filteredListContent;
	NSString		*savedSearchTerm;
    BOOL			searchWasActive;
}

@property (nonatomic, retain) SelecionaAnoViewController *selecionaAnoViewController;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) BOOL searchWasActive;

- (void)selecionaAnoViewController:(SelecionaAnoViewController *)controller didFinishSelecionaAnoWithInfo:(NSNumber *)anoInfo;

@end
