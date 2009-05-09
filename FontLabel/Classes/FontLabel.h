//
//  FontLabel.h
//  MafiaWars
//
//  Created by Kevin Ballard on 5/8/09.
//  Copyright 2009 Zynga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontLabel : UILabel {
	void *reserved; // works around a bug in UILabel
	CGFontRef cgFont;
	CGFloat fontSize;
}
@property (nonatomic, setter=setCGFont:) CGFontRef cgFont;
@property (nonatomic, assign) CGFloat pointSize;
// -initWithFrame:fontName:pointSize: uses FontManager to look up the font name
- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName pointSize:(CGFloat)pointSize;
- (id)initWithFrame:(CGRect)frame font:(CGFontRef)font pointSize:(CGFloat)pointSize;
@end
