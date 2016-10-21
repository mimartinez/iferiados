#import <UIKit/UIKit.h>
@protocol GTabTabItemDelegate;


@interface GTabTabItem : UIButton {
	BOOL _on;
	id <GTabTabItemDelegate> delegate;
}
@property (nonatomic, assign) id <GTabTabItemDelegate> delegate;
@property (nonatomic) BOOL _on;
- (id)initWithFrame:(CGRect)frame normalState:(NSString*)n toggledState:(NSString *)t;              // This class enforces a size appropriate for the control. The frame size is ignored.
-(BOOL)isOn;
-(void)toggleOn:(BOOL)state;
@end

@protocol GTabTabItemDelegate
- (void)selectedItem:(GTabTabItem *)button;
@end
