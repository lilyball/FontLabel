//
//  FontLabelViewController.m
//  FontLabel
//
//  Created by Amanda Wixted on 4/30/09.
//  Copyright © 2009 Zynga Game Networks 
//
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//


#import "FontLabelViewController.h"
#import "FontLabel.h"


@implementation FontLabelViewController





// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	CGFloat size = 30.0f; 
	
	
	FontLabel *label = [[FontLabel alloc] initWithPoint:(CGPoint){10, 50} name:@"Paint Boy" size:40.0f color:[UIColor magentaColor] autoframe:YES];
	[label setString:@"lorem ipsum"];
	[self.view addSubview:label];
	
	
	FontLabel *label2 = [[FontLabel alloc] initWithPoint:(CGPoint){10, label.frame.origin.y + label.frame.size.height + 10} name:@"Scissor Cuts" size:24.0f color:[UIColor greenColor] autoframe:YES];
	[label2 setString:@"commanda hearts opensource!"];
	[self.view addSubview:label2];
	
	
	FontLabel *label3 = [[FontLabel alloc] initWithPoint:(CGPoint){10, label2.frame.origin.y + label2.frame.size.height + 10} name:@"Abberancy" size:size color:[UIColor orangeColor] autoframe:YES];
	[label3 setString:@"Troy RULEZ!"];
	[self.view addSubview:label3];
	
	FontLabel *label4 = [[FontLabel alloc] initWithPoint:(CGPoint){10, label3.frame.origin.y + label3.frame.size.height + 10} name:@"Schwarzwald Regular" size:size color:[UIColor yellowColor] autoframe:YES];
	[label4 setString:@"your name here"];
	[self.view addSubview:label4];
	
	
	FontLabel *label5 = [[FontLabel alloc] initWithFrame:(CGRect){10, label4.frame.origin.y + label4.frame.size.height + 10, 300, 100} name:@"Schwarzwald Regular" size:20.0f color:[UIColor blackColor] justify:kCenter];
	[label5 setString:@"centered in a frame"];
	label5.backgroundColor = [UIColor greenColor];
	[self.view addSubview:label5];
	
	
	FontLabel *label6 = [[FontLabel alloc] initWithFrame:(CGRect){10, label5.frame.origin.y + label5.frame.size.height + 10, 300, 100} name:@"Schwarzwald Regular" size:20.0f color:[UIColor magentaColor] justify:kRight];
	[label6 setString:@"right justified"];
	label6.backgroundColor = [UIColor blueColor];
	[self.view addSubview:label6];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}
@end
