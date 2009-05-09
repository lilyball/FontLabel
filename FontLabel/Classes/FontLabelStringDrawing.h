//
//  FontLabelStringDrawing.h
//  MafiaWars
//
//  Created by Kevin Ballard on 5/5/09.
//  Copyright 2009 Zynga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (FontLabelStringDrawing)
- (CGSize)sizeWithCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize;
- (CGSize)drawAtPoint:(CGPoint)point withCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize;
@end
