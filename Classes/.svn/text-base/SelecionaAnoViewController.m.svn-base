//
//  SelecionaAnoViewController.m
//  Feriados
//
//  Created by mimartinez on 11/02/16.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "SelecionaAnoViewController.h"
#import "UINavigationBar+Custom.h"
#import "NSDate+Utiles.h"
#import "FeriadosAppDelegate.h"
#import "Constantes.h"
#import "UIView+Utiles.h"

@implementation SelecionaAnoViewController

@synthesize txtAno;
@synthesize delegate;
@synthesize anoInfo;
@synthesize navBar;
@synthesize toolBar;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
    if (IF_IPAD) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(myKeyboardWillHideHandler:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
	txtAno.delegate = self;
	txtAno.clearButtonMode = UITextFieldViewModeWhileEditing;
	txtAno.placeholder = [NSString stringWithFormat:@"Ano entre %d e %d", ANO_INICIAL, ANO_FINAL];
	toolBar.frame = CGRectMake( 0, (((IF_IPAD)? APP_IPAD_HEIGHT : APP_HEIGHT) - ((IF_IPAD)? KEYBOARD_IPAD_HEIGHT : KEYBOARD_HEIGHT) - toolBar.frame.size.height + STATUS_BAR_HEIGHT)
							   , toolBar.frame.size.width
							   , toolBar.frame.size.height);
}


-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	txtAno.keyboardType = (IF_IPAD)? UIKeyboardTypeNumberPad : UIKeyboardTypeNumberPad;
	[txtAno becomeFirstResponder];
	txtAno.text = @"";
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	UIBarButtonItem *btnAceitar = [[[UIBarButtonItem alloc] initWithTitle:@"Aceitar"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(done:)] autorelease];
	self.navBar.topItem.rightBarButtonItem = btnAceitar;	
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.navBar = nil;
	self.txtAno = nil;
	self.toolBar = nil;
}


- (void)dealloc {
	[anoInfo release];
	[navBar release];
	[txtAno release];
	[toolBar release];
    [super dealloc];
}

- (void)hideModal:(UIView*) modalView {
	CGSize offSize = [[UIScreen mainScreen] applicationFrame].size;
	CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
	[UIView beginAnimations:nil context:modalView];
	[UIView setAnimationDuration:(IF_IPAD)? ANIMATION_KEYBOARD_IPAD : ANIMATION_KEYBOARD];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideModalEnded:finished:context:)];
	modalView.center = offScreenCenter;
	[txtAno resignFirstResponder];
	[UIView commitAnimations];
}

- (void)hideModalEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	UIView* modalView = (UIView *)context;
	[modalView removeFromSuperview];
	//[modalView release];
}

- (void) myKeyboardWillHideHandler:(NSNotification *)notification {
    [self hideModal:self.view];
}

- (IBAction)anoActual:(id)sender
{
	txtAno.text = [NSString stringWithFormat:@"%d", [[NSDate date] year]];
}

- (IBAction)done:(id)sender {
	self.anoInfo = [NSNumber numberWithInt:[txtAno.text intValue]];
	if (([anoInfo intValue] == 0 && [txtAno.text length] == 0) || ([anoInfo intValue] >= ANO_INICIAL && [anoInfo intValue] <= ANO_FINAL)) 
	{
		[txtAno resignFirstResponder];
		[self hideModal:self.view];
		if ([delegate respondsToSelector:@selector(selecionaAnoViewController:didFinishSelecionaAnoWithInfo:)]) {
			[delegate selecionaAnoViewController:self didFinishSelecionaAnoWithInfo:anoInfo];
		}
	}else 
	{
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Informação" 
															message:[NSString stringWithFormat:@"Os anos válidos são entre \n%d e %d.\nPor favor insira um ano válido.", ANO_INICIAL, ANO_FINAL] 
												            delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
		//((UILabel*)[[alertView subviews] objectAtIndex:2]).textAlignment = UITextAlignmentLeft;
	}

}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex == 0) {
		txtAno.text = @"";
	}
}

//Implement UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField 
{
	//self.anoInfo = [NSNumber numberWithInt:[textField.text intValue]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{	
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 4) ? NO : YES;
}

@end
