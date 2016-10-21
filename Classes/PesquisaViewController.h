//
//  PesquisaViewController.h
//  Feriados
//
//  Created by mimartinez on 11/02/08.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelecionaAnoViewController.h"
#import "MBProgressHUD.h"
#import "Constantes.h"

@interface PesquisaViewController : UIViewController <SelecionaAnoViewControllerDelegate, MBProgressHUDDelegate>
{
	IBOutlet UIButton *btnCarnaval;
	IBOutlet UIButton *btnCorpoDeDeus;
	IBOutlet UIButton *btnPascoa;
	IBOutlet UIButton *btnSextaSanta;
    MBProgressHUD *HUD;
    TipoFeriado tipoFeriado;
}

@property (nonatomic) TipoFeriado tipoFeriado;
@property (nonatomic, retain) SelecionaAnoViewController *selecionaAnoViewController;
@property (nonatomic, retain) IBOutlet UIButton *btnCarnaval;
@property (nonatomic, retain) IBOutlet UIButton *btnCorpoDeDeus;
@property (nonatomic, retain) IBOutlet UIButton *btnPascoa;
@property (nonatomic, retain) IBOutlet UIButton *btnSextaSanta;

- (IBAction)actionCarnaval:(id)sender;
- (IBAction)actionCorpoDeus:(id)sender;
- (IBAction)actionPascoa:(id)sender;
- (IBAction)actionSextaSanta:(id)sender;

- (void)selecionaAnoViewController:(SelecionaAnoViewController *)controller didFinishSelecionaAnoWithInfo:(NSNumber *)anoInfo;

@end
