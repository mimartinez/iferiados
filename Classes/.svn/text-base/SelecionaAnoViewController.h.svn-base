//
//  SelecionaAnoViewController.h
//  Feriados
//
//  Created by mimartinez on 11/02/16.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelecionaAnoViewController;

@protocol SelecionaAnoViewControllerDelegate <NSObject>

@optional

- (void)selecionaAnoViewController:(SelecionaAnoViewController *)controller didFinishSelecionaAnoWithInfo:(NSNumber *)anoInfo;

@end

@interface SelecionaAnoViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
{
	UINavigationBar *navBar;
	id <SelecionaAnoViewControllerDelegate> delegate;
	UITextField *txtAno;
	UIToolbar *toolBar;
	NSNumber *anoInfo;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UITextField *txtAno;
@property (nonatomic, retain) NSNumber *anoInfo;
@property (nonatomic, retain) id <SelecionaAnoViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;

- (IBAction)done:(id)sender;
- (IBAction)anoActual:(id)sender;

@end
