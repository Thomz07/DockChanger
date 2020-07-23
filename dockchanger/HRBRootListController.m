#include "HRBRootListController.h"
#include "../UIDevice+notchedDevice.m"

HRBRootListController *controller;

@implementation HRBRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];

	UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
    self.navigationItem.rightBarButtonItem = applyButton;

	controller = self;
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[[UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]] setOnTintColor:[UIColor colorWithRed: 0.46 green: 0.50 blue: 0.60 alpha: 1.00]];
}

-(void)respring:(id)sender {

	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Respring"
							message:@"Are you sure you want to Respring ?"
							preferredStyle:UIAlertControllerStyleActionSheet];

		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel
		handler:^(UIAlertAction * action) {}];

		UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive
		handler:^(UIAlertAction * action) {
			NSTask *t = [[NSTask alloc] init];
			[t setLaunchPath:@"usr/bin/sbreload"];
			[t launch];
		}];

		[alert addAction:defaultAction];
		[alert addAction:yes];
		[self presentViewController:alert animated:YES completion:nil];
}

-(void)openTwitterThomz:(id)sender {
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://twitter.com/Thomzi07"] options:@{} completionHandler:^(BOOL success){}];
}

-(void)openDepiction:(id)sender {
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://repo.packix.com/package/com.thomz.dockchanger/"] options:@{} completionHandler:^(BOOL success){}];
}

-(void)openGithub:(id)sender {
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://github.com/Thomz07/DockChanger"] options:@{} completionHandler:^(BOOL success){}];
}

@end

@implementation DockChangerHeaderCell 

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {

	NSBundle *bundle = [[NSBundle alloc]initWithPath:@"/Library/PreferenceBundles/DockChanger.bundle"];
	UIImage *logo = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"iconFullSize" ofType:@"png"]];
	UIImageView *icon = [[UIImageView alloc]initWithImage:logo];
	icon.frame = CGRectMake(self.contentView.bounds.size.width-35,35,70,70);
	icon.layer.masksToBounds = YES;
	icon.layer.cornerRadius = 15;

	MPUMarqueeView *tweakLabelMarquee = [[MPUMarqueeView alloc] initWithFrame:CGRectMake(12.5,32.5,icon.frame.origin.x-25,55)];
	[tweakLabelMarquee setFadeEdgeInsets:UIEdgeInsetsMake(0,10,0,10)];
    
    UILabel *tweakLabel = [[UILabel alloc] init];
	[tweakLabel setTextAlignment:NSTextAlignmentLeft];
    [tweakLabel setFont:[UIFont systemFontOfSize:47.5 weight: UIFontWeightRegular]];
    tweakLabel.text = @"DockChanger ";

	CGSize size = [tweakLabel sizeThatFits:CGSizeMake(tweakLabel.frame.size.width, FLT_MAX)];
	tweakLabelMarquee.contentSize = size;
	tweakLabel.frame = CGRectMake(0,0,size.width,55);

	[tweakLabelMarquee.contentView addSubview:tweakLabel];
	tweakLabelMarquee.marqueeEnabled = YES;
	tweakLabelMarquee.clipsToBounds = YES;
    
    UILabel *devLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,70,self.contentView.bounds.size.width+30,50)];
	[devLabel setTextAlignment:NSTextAlignmentLeft];
    [devLabel setFont:[UIFont systemFontOfSize:22 weight: UIFontWeightMedium] ];
	devLabel.alpha = 0.8;
    devLabel.text = @"by Thomz";
    
    [self addSubview:tweakLabelMarquee];
    [self addSubview:devLabel];
	[self addSubview:icon];

    }
    	return self;

}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DockChangerHeaderCell" specifier:specifier];
}

- (void)setFrame:(CGRect)frame {
	frame.origin.x = 0;
	[super setFrame:frame];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1{
    return 140.0f;
}

@end

@implementation NotchCheckCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {

    }
    	return self;

}

-(void)layoutSubviews {
	[super layoutSubviews];

	if(!self.marquee){
		self.marquee = [[MPUMarqueeView alloc] initWithFrame:CGRectMake(5,0,self.bounds.size.width,self.bounds.size.height)];
		[self.marquee setFadeEdgeInsets:UIEdgeInsetsMake(0,10,0,10)];

		UILabel *label = [[UILabel alloc]init];
		
		if([UIDevice.currentDevice isAnIpad] || ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatyDock.dylib"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatingDockPlus13.dylib"]) || ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatingDock.dylib"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatingDockPlus.dylib"])){
			label.text = @"Your device is an iPad or FloatingDock is installed, the tweak will not work. ";
		} else if([UIDevice.currentDevice isNotched]){
			label.text = @"Your device is notched, This means you will get the old Dock. ";
		} else {
			label.text = @"Your device is not notched, This means you will get the new Dock. ";
		}

		//CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, FLT_MAX)];
		self.marquee.contentSize = CGSizeMake(label.intrinsicContentSize.width,self.bounds.size.height);
		label.frame = CGRectMake(0,0,label.intrinsicContentSize.width,self.bounds.size.height);

		[self.marquee.contentView addSubview:label];
		self.marquee.marqueeEnabled = YES;
		self.marquee.clipsToBounds = YES;

		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMessage:)];
		tap.delegate = (id<UIGestureRecognizerDelegate>)self;
		tap.numberOfTapsRequired = 1;

		[self.marquee addGestureRecognizer:tap];

		[self addSubview:self.marquee];
	}
}

-(void)showMessage:(id)sender {

	NSString *firstText;
	NSString *secondText;

	if([UIDevice.currentDevice isAnIpad] || ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatyDock.dylib"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatingDockPlus13.dylib"]) || ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatingDock.dylib"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatingDockPlus.dylib"])){
		firstText = @"Invalid";
		secondText = @"Your device is an iPad or FloatingDock is installed, the tweak will not work. ";
	} else if([UIDevice.currentDevice isNotched]){
		firstText = @"Notched";
		secondText = @"Your device is notched, This means you will get the old Dock. ";
	} else {
		firstText = @"Non Notched";
		secondText = @"Your device is not notched, This means you will get the new Dock. ";
	}
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:firstText
							message:secondText
							preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel
		handler:^(UIAlertAction * action) {}];

		[alert addAction:defaultAction];
		[controller presentViewController:alert animated:YES completion:nil];
}

@end
