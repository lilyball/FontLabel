//
//  FontLabelViewController.m
//  FontLabel
//
//  Created by Amanda Wixted on 4/30/09.
//  Modified by Kevin Ballard on 5/8/09.
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
#import "FontLabelStringDrawing.h"
#import "FontManager.h"

@implementation FontLabelViewController

- (void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	FontLabel *label = [[FontLabel alloc] initWithFrame:CGRectMake(10, 50, 0, 0) fontName:@"Paint Boy" pointSize:40.0f];
	label.textColor = [UIColor magentaColor];
	label.text = @"lorem ipsum";
	[label sizeToFit];
	label.backgroundColor = nil;
	label.opaque = NO;
	[self.view addSubview:label];
	
	FontLabel *label2 = [[FontLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame) + 10, 0, 0)
													  fontName:@"Scissor Cuts" pointSize:24.0f];
	label2.textColor = [UIColor greenColor];
	label2.text = @"commanda hearts opensource!";
	[label2 sizeToFit];
	label2.backgroundColor = nil;
	label2.opaque = NO;
	[self.view addSubview:label2];
	
	FontLabel *label3 = [[FontLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label2.frame) + 10, 0, 0)
												  fontName:@"Abberancy" pointSize:30.0f];
	label3.textColor = [UIColor orangeColor];
	label3.text = @"Troy RULEZ!";
	[label3 sizeToFit];
	label3.backgroundColor = nil;
	label3.opaque = NO;
	[self.view addSubview:label3];
	
	FontLabel *label4 = [[FontLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label3.frame) + 10, 0, 0)
												  fontName:@"Schwarzwald Regular" pointSize:30.0f];
	label4.textColor = [UIColor yellowColor];
	label4.text = @"your name here";
	[label4 sizeToFit];
	label4.backgroundColor = nil;
	label4.opaque = NO;
	[self.view addSubview:label4];
	
	FontLabel *label5 = [[FontLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label4.frame) + 10, 300, 100)
												  fontName:@"Schwarzwald Regular" pointSize:20.0f];
	label5.textColor = [UIColor blackColor];
	label5.text = @"centered in a frame";
	label5.textAlignment = UITextAlignmentCenter;
	label5.backgroundColor = [UIColor greenColor];
	[self.view addSubview:label5];
	
	FontLabel *label6 = [[FontLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label5.frame) + 10, 300, 100)
												  fontName:@"Schwarzwald Regular" pointSize:20.0f];
	label6.textColor = [UIColor magentaColor];
	label6.text = @"right justified";
	label6.textAlignment = UITextAlignmentRight;
	label6.backgroundColor = [UIColor blueColor];
	[self.view addSubview:label6];
}

- (void)dealloc {
    [super dealloc];
}
@end
