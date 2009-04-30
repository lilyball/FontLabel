//
//  FontLabel.h
//  MafiaWars
//
//  Created by Amanda Wixted on 1/25/09.
//  Copyright © 2009 Zynga Game Networks 
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

#import <UIKit/UIKit.h>



typedef enum
	{
		kLeft,
		kCenter,
		kRight,
	}ZJustify;




@interface FontLabel : UILabel {
	NSString *fontname;   // the filename of the font to use for this label
	CGFloat fontSize;
	UIColor *strokeColor;
	UIColor *fillColor;
	CGSize size;
	int drawX;
	int drawY;
	ZJustify justify;
	BOOL autoframe;
	BOOL sizeDidChange;
	CGPoint fixedLoc;
}

@property (nonatomic,retain) NSString *fontname;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic,retain) UIColor *strokeColor;
@property (nonatomic,retain) UIColor *fillColor;
@property (readonly) CGSize size;
@property (readonly) int drawX;
@property (readonly) int drawY;
@property (nonatomic) ZJustify justify;
@property (nonatomic) BOOL autoframe;
@property (nonatomic) BOOL sizeDidChange;
@property (nonatomic) CGPoint fixedLoc;



+ (void)loadFont:(NSString*)filename;

- (id)initWithFrame:(CGRect)frame name:(NSString*)theName size:(CGFloat)sizeOfFont color:(UIColor*)color justify:(ZJustify)justifyStyle;
- (id)initWithPoint:(CGPoint)loc name:(NSString*)theName size:(CGFloat)sizeOfFont color:(UIColor*)color autoframe:(BOOL)shouldautoframe;
- (void)setString:(NSString *)string;

@end
