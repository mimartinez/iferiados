#import "GTabBar.h"
#import "GTabTabItem.h"
#import "Constantes.h"

#define kSelectedTab	@"SelectedTAB"
@implementation GTabBar
@synthesize tabViewControllers;
@synthesize tabItemsArray;
@synthesize tabBarHolder;
@synthesize initTab;
@synthesize indexActivateController;
@synthesize delegate;

- (void)dealloc {
	[tabBarHolder release];
	[tabViewControllers release];
	[tabItemsArray release];
	[super dealloc];
}
//we are creating a view with the same bounds as the window, so it covers the whole area.
//also we are initializing the arrays that will hold the UIViewControllers and the TabBarItems
- (id)initWithTabViewControllers:(NSMutableArray *)tbControllers tabItems:(NSMutableArray *)tbItems initialTab:(int)iTab {
	if ((self = [super init])) {
		self.view.frame = [UIScreen mainScreen].bounds;
		initTab = iTab;
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		if ([defaults integerForKey:kSelectedTab]) {
			initTab = [defaults integerForKey:kSelectedTab];
		}
		//NSLog(@"%d", initTab);
		tabViewControllers = [[NSMutableArray alloc] initWithCapacity:[tbControllers count]];
		tabViewControllers = tbControllers;
		
		tabItemsArray = [[NSMutableArray alloc] initWithCapacity:[tbItems count]];
		tabItemsArray = tbItems;
	}
    return self;
}
-(void)initialTab:(int)tabIndex {
	[self activateController:tabIndex];
	[self activateTabItem:tabIndex];
}

-(void)updateTab:(int)tabIndex
{
	initTab = tabIndex;
	[self selectedItem:[tabItemsArray objectAtIndex:tabIndex]];
}

- (void)viewWillDisappear:(BOOL)animated 
{
  [super viewWillDisappear:animated];
  [[tabViewControllers objectAtIndex:indexActivateController] viewWillDisappear:animated];
}
 
- (void)viewDidDisappear:(BOOL)animated 
{
  [super viewDidDisappear:animated];
  [[tabViewControllers objectAtIndex:indexActivateController] viewDidDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	//Create a view holder to store the tabbar items
	tabBarHolder = [[UIView alloc] initWithFrame:(IF_IPAD)? CGRectMake(0, 975, 768, 1024) : CGRectMake(0, 431, 320, 480)];
	tabBarHolder.tag = TABBARHOLDER_TAG;
	tabBarHolder.backgroundColor = [UIColor clearColor];
	//add it as a subview
	[self.view addSubview:tabBarHolder];
	//loop thru all the view controllers and add their views to self
	for (int i = [tabViewControllers count]-1; i >= 0; i--) {
		[self.view addSubview:[[tabViewControllers objectAtIndex:i] view]];
	}
	
	//loop thru all the tabbar items and add them to the tabBarHolder
	
	for (int i = [tabItemsArray count]-1; i >= 0; i--) {
		[[tabItemsArray objectAtIndex:i] setDelegate:self];
		[self.tabBarHolder addSubview:[tabItemsArray objectAtIndex:i]];
		//initTab is the index of the tabbar and viewcontroller that you decide to start the app with
		if (i == initTab) {
			[[tabItemsArray objectAtIndex:i] toggleOn:YES];
		}
	}
	[self.view bringSubviewToFront:tabBarHolder];
	//show/hide tabbars and controllers with a particular index
	[self initialTab:initTab];
	//[[tabViewControllers objectAtIndex:initTab] viewDidAppear:animated];
}
//loop thru all tab bar items and set their toogle State to YES/NO
-(void)activateTabItem:(int)index {
	for (int i = [tabItemsArray count]; i < [tabItemsArray count]; i++) {
		if (i == index) {
			[[tabItemsArray objectAtIndex:i] toggleOn:YES];
		} else {
			[[tabItemsArray objectAtIndex:i] toggleOn:NO];
		}
	}
}
//loop thru all UIViewControllers items and set their toogle State to YES/NO
-(void)activateController:(int)index {
	for (int i = 0; i < [tabViewControllers count]; i++) {
		if (i == index) {
			[[tabViewControllers objectAtIndex:i] view].hidden = NO;
			indexActivateController = index;
		} else {
			[[tabViewControllers objectAtIndex:i] view].hidden = YES;
		}
	}
}
//protocol used to communicate between the buttons and the tabbar
#pragma mark -
#pragma mark GTabTabItemDelegate action
- (void)selectedItem:(GTabTabItem *)button {
	int indexC = 0;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger tabIndex;
	for (GTabTabItem *tb in tabItemsArray) {		
		if (tb == button) {
			[tb toggleOn:YES];
			[self activateController:indexC];
			tabIndex = indexC;
			[defaults setInteger:tabIndex forKey:kSelectedTab];
			[[tabViewControllers objectAtIndex:indexActivateController] viewWillAppear:NO];
		} else {
			[tb toggleOn:NO];
		}
		indexC++;
	}	 
}

@end
