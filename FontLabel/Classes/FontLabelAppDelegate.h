//
//  FontLabelAppDelegate.h
//  FontLabel
//
//  Created by Amanda Wixted on 4/30/09.
//  Copyright Zynga 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FontLabelViewController;

@interface FontLabelAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FontLabelViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FontLabelViewController *viewController;

@end

