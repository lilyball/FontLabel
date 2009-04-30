//
//  FontLabelAppDelegate.m
//  FontLabel
//
//  Created by Amanda Wixted on 4/30/09.
//  Copyright Zynga 2009. All rights reserved.
//

#import "FontLabelAppDelegate.h"
#import "FontLabelViewController.h"
#import "FontLabel.h"


@implementation FontLabelAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	
	[FontLabel loadFont:@"Paint Boy"];
	[FontLabel loadFont:@"A Damn Mess"];
	[FontLabel loadFont:@"Scissor Cuts"];
	[FontLabel loadFont:@"Abberancy"];
	[FontLabel loadFont:@"Schwarzwald Regular"];
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
