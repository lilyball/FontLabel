//
//  FontLabel.h
//  MafiaWars
//
//  Created by Amanda Wixted on 1/25/09.
//  Copyright 2009 Zynga. All rights reserved.
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
