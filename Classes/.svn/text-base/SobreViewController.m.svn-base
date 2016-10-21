//
//  SobreViewController.m
//  Feriados
//
//  Created by mimartinez on 11/02/08.
//  Copyright 2011 Michel Martínez. All rights reserved.
//

#import "SobreViewController.h"
#import "UINavigationBar+Custom.h"
#import "Constantes.h"

@implementation SobreViewController

@synthesize navBar;
@synthesize viewTop;
@synthesize lblversao;
@synthesize legal;

- (void) hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        
        [self hideGradientBackground:subview];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    legal.delegate = self;
	NSString *filePath = [[NSBundle mainBundle] pathForResource:(IF_IPAD)?@"sobre-iPad" : @"sobre" ofType:@"html"];
    NSURL *urlLocation= [NSURL fileURLWithPath:filePath];
	[self.legal loadRequest:[NSURLRequest requestWithURL:urlLocation]];
    
    if([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        [navBar setBackgroundImage:[UIImage imageNamed: (IF_IPAD)? @"Fondo_NavBar-iPad_Novo.png" : @"Fondo_NavBar.png"] forBarMetrics: UIBarMetricsDefault];
        navBar.tintColor = COLOR_ITEMNAVBAR;
    }
    
    [navBar customTitle];
    
    [legal setBackgroundColor:COLOR_FONDO_SOBRE];
    [self hideGradientBackground:legal];
    
	self.lblversao.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	// Botão com o ano
	UIBarButtonItem *btnVoltar = [[[UIBarButtonItem alloc] initWithTitle:@"Voltar"
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(dismissView:)] autorelease];
	self.navBar.topItem.leftBarButtonItem = btnVoltar;	
}

- (IBAction)dismissView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.navBar = nil;
	self.viewTop = nil;
	self.lblversao = nil;
	self.legal = nil;
}


- (void)dealloc {
	[navBar release];
	[viewTop release];
	[lblversao release];
	[legal release];
    [super dealloc];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}


@end
