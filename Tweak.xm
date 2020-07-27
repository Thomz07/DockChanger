#import "UIDevice+notchedDevice.m"

NSDictionary *settings;
static BOOL enabled;
static BOOL iconList;
static BOOL dockBg;

@interface SBDockView : UIView
@property (nonatomic,retain) UIView * backgroundView;
@end

@interface SBWallpaperEffectView : UIView
@property (nonatomic,retain) UIView *blurView;
@end

@interface MTMaterialView : UIView
@property (assign,nonatomic) double weighting;
@end

%group Notched
%hook SBDockView
-(void)layoutSubviews {
	%orig;
	self.backgroundView.frame = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height + 1.5); // Change background view frame
	self.backgroundView.layer.cornerRadius = 0; // Remove background view corner radius
	if(iconList){
		UIView *iconListView = [self valueForKey:@"iconListView"];
		iconListView.translatesAutoresizingMaskIntoConstraints = NO;
		[iconListView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
		[iconListView.centerXAnchor constraintEqualToAnchor:self.backgroundView.centerXAnchor].active = YES;
		[iconListView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
		[iconListView.widthAnchor constraintEqualToAnchor:self.backgroundView.widthAnchor].active = YES;
	}

	if([self.backgroundView respondsToSelector:@selector(_materialLayer)]){
		((MTMaterialView *)self.backgroundView).weighting = dockBg ? 0 : 1;
	}

	if([self.backgroundView respondsToSelector:@selector(blurView)]){
		((SBWallpaperEffectView *)self.backgroundView).blurView.hidden = dockBg ? YES : NO;
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
	dockBg = [([settings valueForKey:@"dockBg"] ?: @(NO)) boolValue];
	if(enabled){
		if([UIDevice.currentDevice isNotched]){ // Check if device is notched or not
			%init(Notched); 
		} else {
			%init(NonNotched);
		}
	}
}