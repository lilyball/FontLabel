//
//  FontLabel.m
//  FontLabel
//
//  Created by Kevin Ballard on 5/8/09.
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

#import "FontLabel.h"
#import "FontManager.h"
#import "FontLabelStringDrawing.h"
#import "ZFont.h"

@implementation FontLabel
@synthesize zFont;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName pointSize:(CGFloat)pointSize {
	return [self initWithFrame:frame zFont:[[FontManager sharedManager] zFontWithName:fontName pointSize:pointSize]];
}

- (id)initWithFrame:(CGRect)frame zFont:(ZFont *)font {
	if (self = [super initWithFrame:frame]) {
		zFont = [font retain];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame font:(CGFontRef)font pointSize:(CGFloat)pointSize {
	return [self initWithFrame:frame zFont:[ZFont fontWithCGFont:font size:pointSize]];
}

- (CGFontRef)cgFont {
	return self.zFont.cgFont;
}

- (void)setCGFont:(CGFontRef)font {
	if (self.zFont.cgFont != font) {
		self.zFont = [ZFont fontWithCGFont:font size:self.zFont.pointSize];
	}
}

- (CGFloat)pointSize {
	return self.zFont.pointSize;
}

- (void)setPointSize:(CGFloat)pointSize {
	if (self.zFont.pointSize != pointSize) {
		self.zFont = [ZFont fontWithCGFont:self.zFont.cgFont size:pointSize];
	}
}

- (void)drawTextInRect:(CGRect)rect {
	UIRectClip(rect);
	// this method is documented as setting the text color for us, but that doesn't appear to be the case
	[self.textColor setFill];
	CGSize size = [self.text sizeWithZFont:self.zFont constrainedToSize:rect.size];
	CGPoint point = rect.origin;
	point.y += MAX(rect.size.height - size.height, 0.0f) / 2.0f;
	rect = (CGRect){point, CGSizeMake(rect.size.width, size.height)};
	[self.text drawInRect:rect withZFont:self.zFont lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
	bounds.size = [self.text sizeWithZFont:self.zFont constrainedToSize:bounds.size lineBreakMode:self.lineBreakMode];
	return bounds;
}

- (void)dealloc {
	[zFont release];
	[super dealloc];
}
@end