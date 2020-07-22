#import "UIDevice+notchedDevice.m"

@interface SBDockView : UIView
@end

NSDictionary *settings;
static BOOL enabled;

%group Tweak
%hook SBDockView

-(void)layoutSubviews {
	%orig;
	if([UIDevice.currentDevice isNotched]){ // Detect if the device is notched
		UIView *backgroundView = [self valueForKey:@"backgroundView"]; // Get the background view of the Dock

		backgroundView.frame = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height + 10); // Change background view frame
		backgroundView.layer.cornerRadius = 0; // Remove background view corner radius
	}
}

%end
%hook UITraitCollection
- (CGFloat)displayCornerRadius {
	if(![UIDevice.currentDevice isNotched]){ // Detect if the device is notched
		return 6; // This is based on a bug, if you don't return %orig here, it changes the Dock style for a reason that i don't know
	} else {
		return %orig; // This bug has been found by Nepeta or Kritanta i don't remember
	}
}
%end
%end

%ctor {
	settings = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.thomz.dockchanger"];
	enabled = [([settings valueForKey:@"enabled"] ?: @(YES)) boolValue];
	if(enabled){
		%init(Tweak); // I'm not checking if the device is notched here because running UIDevice related things in the ctor can cause random crashes
	}
}