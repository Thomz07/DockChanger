#import "UIDevice+notchedDevice.m"

NSDictionary *settings;
static BOOL enabled;
static BOOL iconList;

@interface SBDockView : UIView
@property (nonatomic,retain) UIView * backgroundView;
@end

%group Notched
%hook SBDockView
-(void)layoutSubviews {
	%orig;
	self.backgroundView.frame = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height + 10); // Change background view frame
	self.backgroundView.layer.cornerRadius = 0; // Remove background view corner radius
	if(iconList){
		UIView *iconListView = [self valueForKey:@"iconListView"];
		iconListView.frame = CGRectMake(iconListView.frame.origin.x,iconListView.frame.origin.y + 5,iconListView.bounds.size.width,iconListView.bounds.size.height);
	}
}
%end

%end
%group NonNotched
%hook UITraitCollection
- (CGFloat)displayCornerRadius {
	return 6; // This is based on a bug, if you don't return %orig here, the dock will turn into the new Dock. This bug has been found by Nepeta a while ago
}
%end
%end

%ctor {
	settings = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.thomz.dockchanger"];
	enabled = [([settings valueForKey:@"enabled"] ?: @(YES)) boolValue];
	iconList = [([settings valueForKey:@"iconList"] ?: @(NO)) boolValue];
	if(enabled){
		if([UIDevice.currentDevice isNotched]){ // Check if device is notched or not
			%init(Notched); 
		} else {
			%init(NonNotched);
		}
	}
}