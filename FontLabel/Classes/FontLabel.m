//
//  FontLabel.m
//  MafiaWars
//
//  Created by Kevin Ballard on 5/8/09.
//  Copyright 2009 Zynga Game Networks. All rights reserved.
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
	CGSize size = [self.text sizeWithCGFont:self.cgFont pointSize:self.pointSize];
	CGPoint point = rect.origin;
	switch (self.textAlignment) {
		case UITextAlignmentLeft:
			// included here to satisfy an optional compiler warning
			break;
		case UITextAlignmentCenter:
			point.x += (rect.size.width - size.width) / 2.0f;
			break;
		case UITextAlignmentRight:
			point.x += (rect.size.width - size.width);
			break;
	}
	point.y += MAX(rect.size.height - size.height, 0.0f) / 2.0f;
	[self.text drawAtPoint:point withCGFont:self.cgFont pointSize:self.pointSize];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
	bounds.size = [self.text sizeWithCGFont:self.cgFont pointSize:self.pointSize];
	return bounds;
}

- (void)dealloc {
	self.cgFont = nil;
	[super dealloc];
}

@end
