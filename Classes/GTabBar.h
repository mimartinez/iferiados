#import <UIKit/UIKit.h>
#import "GTabTabItem.h"

@protocol GTabBarViewDelegate;
@interface GTabBar : UIViewController <GTabTabItemDelegate> {
	UIView *tabBarHolder;
	NSMutableArray *tabViewControllers;
	NSMutableArray *tabItemsArray;
	id <GTabBarViewDelegate> delegate;
	int initTab;
	int indexActivateController;
}
//properties
@property int initTab;
@property int indexActivateController;
@property (nonatomic, retain) UIView *tabBarHolder;
@property (nonatomic, assign) id <GTabBarViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *tabViewControllers;
@property (nonatomic, retain) NSMutableArray *tabItemsArray;
//actions
- (id)initWithTabViewControllers:(NSMutableArray *)tbControllers tabItems:(NSMutableArray *)tbItems initialTab:(int)iTab;
-(void)initialTab:(int)tabIndex;
-(void)activateController:(int)index;
-(void)activateTabItem:(int)index;
-(void)updateTab:(int)tabIndex;
@end

//protocol
@protocol GTabBarViewDelegate
- (void)addController:(id)controller;
@end
