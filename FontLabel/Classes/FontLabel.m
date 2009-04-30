//
//  FontLabel.m
//  
//
//  Created by Amanda Wixted on 1/25/09.
//  Copyright 2009 Zynga. All rights reserved.
//

#import "FontLabel.h"




@implementation FontLabel

static NSMutableDictionary *fonts;

@synthesize fontSize;
@synthesize fontname;
@synthesize strokeColor;
@synthesize fillColor;
@synthesize size;
@synthesize justify;
@synthesize autoframe;
@synthesize sizeDidChange;
@synthesize fixedLoc;
@synthesize drawX;
@synthesize drawY;



- (id)initWithFrame:(CGRect)frame name:(NSString*)theName size:(CGFloat)sizeOfFont color:(UIColor*)color justify:(ZJustify)justifyStyle 
{
	
	
	
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		fontname = nil;  // Interesting bug which requires us to nil out this ivar (rdar link forthcoming)
		self.fontname = theName;
		
		
		// set the default backgroundColor
		self.backgroundColor = [UIColor clearColor];
		
		// For debug, to see the frame bounds, uncomment this line
		//self.backgroundColor = [UIColor magentaColor];
		
		// set the default font size
		self.fontSize = sizeOfFont;
		
		
		self.fillColor = color;
		
		// Make the stroke color using the given color, but with a lighter alpha channel
		const CGFloat *channels = CGColorGetComponents(color.CGColor);  
		self.strokeColor = [[UIColor alloc] initWithRed:channels[0] green:channels[1] blue:channels[2] alpha:(channels[CGColorGetNumberOfComponents(color.CGColor)-1]/20)];
		
		self.justify = justifyStyle;
		
		
    }
    return self;
}

// Autoframe should be YES when you want this class to create the frame based on the text that will be set later. 
- (id)initWithPoint:(CGPoint)loc name:(NSString*)theName size:(CGFloat)sizeOfFont color:(UIColor*)color autoframe:(BOOL)shouldautoframe
{
	
	self.autoframe = shouldautoframe;
	self.fixedLoc = loc;
	return [self initWithFrame:(CGRect){loc.x,loc.y,1.0f,1.0f} name:theName size:sizeOfFont color:color justify:kLeft];
}


// Load a .ttf file from the Resources and add it to the static table of available fonts for this app
+ (void)loadFont:(NSString *)filename 
{
	if(fonts == nil)
	{
		fonts = [[NSMutableDictionary alloc]init];
	}
	
	NSString *fontPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"ttf"]; 
	
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
	// Create the font with the data provider, then release the data provider. 
	CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider); 
	CGDataProviderRelease(fontDataProvider); 

	[fonts setObject:(NSObject*)newFont forKey:filename];
}

// Return the width of this string in the current font and pointsize
-(CGSize)getSize:(NSString *)string
{
	CGSize retVal = (CGSize){0.0f,0.0f};
	// Create an array of Glyph's the size of text that will be drawn. 
	CGGlyph textToPrint[[string length]];
	
	// Loop through the entire length of the text. 
	for (int i = 0; i < [string length]; ++i) 
	{ 
		// Store each letter in a Glyph and subtract the MagicNumber to get appropriate value.
		textToPrint[i] = [string  characterAtIndex:i] + 3 - 32; 
	}
	
	CGRect bboxes[[string length]];
	
	CGFontGetGlyphBBoxes (
							(CGFontRef)[fonts objectForKey:fontname],
							textToPrint,
							[string length],
							bboxes
	);
	
	for(int i = 0; i < [string length]; i++)
	{
		//NSLog(@"[%f %f %f %f]", bboxes[i].origin.x, bboxes[i].origin.y, bboxes[i].size.width, bboxes[i].size.height);
		// special case for the space character which has no width in the bbox
		if([string characterAtIndex:i] == ' ')
		{
			bboxes[i].size.width = 304;
		}
		
		retVal.width += bboxes[i].size.width;
		if(bboxes[i].size.height > retVal.height)
		{
			retVal.height = bboxes[i].size.height;
		}
	}
	
	
	// divide by the (max fontsize/actual fontsize) to get the ratio of actual pixels to ttf size units
	// TODO: there's probably a smarter/more accurate equation that should be used here.
	retVal.width = retVal.width/(850.0/fontSize);
	
	retVal.height = fontSize;
	
	return retVal;
}


-(void)drawRect:(CGRect)rect
{ 

	
	// Get the context. 
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	// Fill the background color behind the letters
	CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
	
	CGContextFillRect(context, self.frame);
	
	// Set the font used to draw. 
	CGContextSetFont(context, (CGFontRef)[fonts objectForKey:fontname]);

	
	// Set how the context draws the font, what color, how big. 
	CGContextSetTextDrawingMode(context, kCGTextFillStroke); 

	CGContextSetFillColorWithColor(context, fillColor.CGColor); 
	CGContextSetStrokeColorWithColor(context, strokeColor.CGColor); 
	CGContextSetFontSize(context, self.fontSize);
	
	
	// Create an array of Glyph's the size of text that will be drawn. 
	CGGlyph textToPrint[[self.text length]];
	
	// Map the chars in the text string to glyphs in the font
	// Loop through the entire length of the text. 
	
	for (int i = 0; i < [self.text length]; ++i) 
	{ 
		// Store each letter in a Glyph and subtract the Magic Number to get appropriate value.  The Magic Number is different in many ttfs, but is often -29.  Maybe this value is in the header of the .ttf?
		textToPrint[i] = [self.text characterAtIndex:i] - 29; 
		
	} 
	
	
	
	// flip it upside-down because our 0,0 is upper-left, whereas ttfs are for screens where 0,0 is lower-left
	CGAffineTransform textTransform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
	CGContextSetTextMatrix(context, textTransform); 
	
	
	CGContextShowGlyphsAtPoint(context, drawX, drawY, textToPrint, [self.text length]);
	
}

- (void)setString:(NSString *)string
{
	self.text = string;
	
	size = [self getSize:string];
	
	// if this label wants us to pick the frame for it, do that now
	if(autoframe)
	{
		CGRect newFrame;
		switch (self.justify) {
			case kLeft:
				 newFrame = (CGRect){self.frame.origin.x, self.frame.origin.y, size.width+6, size.height+2};
				self.frame = newFrame;
				sizeDidChange = YES;
				break;
			case kCenter:
				newFrame = (CGRect){(self.fixedLoc.x) - (size.width/2), self.frame.origin.y, size.width+6, size.height+2};
				self.frame = newFrame;
				sizeDidChange = YES;
				break;
			case kRight:
				// TODO: fix the position hackery here, which is due to the inaccurate size function.
				newFrame = (CGRect){self.fixedLoc.x - (size.width) - 6, self.frame.origin.y, size.width+6, size.height+2};
				self.frame = newFrame;
				sizeDidChange = YES;
				break;
			default:
				break;
		}
		

	}
	
	// pick the x value depending on whether this text is to be centered, left-justified, or right-justified
	drawY = (self.frame.size.height/2) + (size.height/2) - (size.height/8.0);
	
	
	switch (self.justify) {
		case kLeft:
			drawX = 0;
			break;
		case kCenter:
			drawX = ((self.frame.size.width) / 2) - (size.width/2);
			break;
		case kRight:
			drawX = (self.frame.size.width) - (size.width);
			break;
		default:
			break;
	}
	
}

- (void)dealloc 
{
	[fontname release];
	[fillColor release];
	[strokeColor release];
    [super dealloc];
}



@end
