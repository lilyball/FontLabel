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

@implementation FontLabel
@synthesize cgFont, pointSize=fontSize;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName pointSize:(CGFloat)pointSize {
	return [self initWithFrame:frame font:[[FontManager sharedManager] fontWithName:fontName] pointSize:pointSize];
}

- (id)initWithFrame:(CGRect)frame font:(CGFontRef)font pointSize:(CGFloat)pointSize {
	if (self = [super initWithFrame:frame]) {
		self.cgFont = font;
		self.pointSize = pointSize;
	}
	return self;
}

- (void)setCGFont:(CGFontRef)font {
	if (font != cgFont) {
		CGFontRelease(cgFont);
		cgFont = CGFontRetain(font);
	}
}

- (void)drawTextInRect:(CGRect)rect {
	UIRectClip(rect);
	// this method is documented as setting the text color for us, but that doesn't appear to be the case
	[self.textColor setFill];
	CGSize size = [self.text sizeWithCGFont:self.cgFont pointSize:self.pointSize constrainedToSize:rect.size];
	CGPoint point = rect.origin;
	point.y += MAX(rect.size.height - size.height, 0.0f) / 2.0f;
	rect = (CGRect){point, CGSizeMake(rect.size.width, size.height)};
	[self.text drawInRect:rect withCGFont:self.cgFont pointSize:self.pointSize
			lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
	bounds.size = [self.text sizeWithCGFont:self.cgFont pointSize:self.pointSize constrainedToSize:bounds.size];
	return bounds;
}

- (void)dealloc {
	self.cgFont = nil;
	[super dealloc];
}

@end
