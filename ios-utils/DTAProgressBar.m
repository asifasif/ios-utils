//
//  DTAProgressBar.m
//  ios-utils
//
//  Created by Derek Trauger on 5/15/13.
//
//

#import "DTAProgressBar.h"
#import <QuartzCore/QuartzCore.h>

#define PERCENT_VIEW_WIDTH 32.0f
#define PERCENT_VIEW_MIN_HEIGHT 14.0f
#define TOP_PADDING 0.0f
#define LEFT_PADDING 5.0f
#define RIGHT_PADDING 3.0f

@implementation DTAProgressBar
{
    UIView *percentView;
    UIImageView *bgImageView;
    UIImageView *progressImageView;
    UIImage *progressFillImage;
    UILabel *customLabel;
    BOOL customViewFromNIB;
    
}


@synthesize progress;
@synthesize progressBarColor;


// Override initWithFrame: if you add the view programmatically.
- (id)initWithFrame:(CGRect)frame andProgressBarColor:(DTAProgressBarColor)barColor
{
    
    if (self = [super initWithFrame:frame])
    {
        customViewFromNIB = NO;
        [self DTAProgressBarDraw:frame withProgressBarColor:barColor];
    }
    
    return self;
}

// Override initWithCoder: if you're loading it from a nib or storyboard.
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        customViewFromNIB = YES;
        [self DTAProgressBarDraw:self.frame
            withProgressBarColor:DTAProgressBarBlue];
    }
    
    return self;
}

// Override layoutSubviews: it gets called whenever the frame of the view changes.
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (customViewFromNIB != YES) {
        return;
    }
    [self progressImageDraw];
}

- (void)setCustomLabelValue:(NSString *)customLabelValue
{
    customLabel.text = customLabelValue;
}


- (void)setProgress:(CGFloat)theProgress
{
    if (self.progress == theProgress) {
        return;
    }
    
    // check range and pin to its limits if required
    if (theProgress < self.minProgressValue) {
        theProgress = self.minProgressValue;
    }
    if (theProgress > self.maxProgressValue) {
        theProgress = self.maxProgressValue;
    }
    
    progress = theProgress;
    
    [self progressImageDraw];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 293.0f, 28.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setProgressBarColor:(DTAProgressBarColor)theColor
{
    NSString* progressFillStr = [self getImageNameFromBarDefinition:theColor];
    
    if ([progressFillStr isEqualToString:@""]) {
        progressFillImage = [self imageWithColor:[UIColor colorWithRed:166.0/255.0 green:218.0/255.0 blue:96.0/255.0 alpha:1.0]];
    } else {
        progressFillImage = [UIImage imageNamed:progressFillStr];
    }
}

- (void) setCustomLabelTextColor:(UIColor *)customLabelTextColor {
    customLabel.textColor = customLabelTextColor;
}

- (void) setCustomLabelFont:(UIFont *)customLabelFont {
    customLabel.font = customLabelFont;
}

- (void)DTAProgressBarDraw:(CGRect)frame withProgressBarColor:(DTAProgressBarColor)barColor
{
    if ( (frame.size.width - LEFT_PADDING - RIGHT_PADDING) < PERCENT_VIEW_WIDTH ) {
        NSLog(@"DTAProgressBarDraw: Frame width is too small to draw PercentView");
        return;
    }
    
    self.progressBarColor = barColor;
    
    bgImageView = [[UIImageView alloc] initWithFrame:
                   CGRectMake(
                              0,
                              0,
                              frame.size.width,
                              frame.size.height )
                   ];
    
    switch (barColor) {
        case DTAProgressBarCustom:
            [bgImageView setImage:[self imageWithColor:[UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.0]]];
            [bgImageView.layer setCornerRadius:10.0f];
            [bgImageView.layer setBorderColor:[UIColor clearColor].CGColor];
            [bgImageView.layer setBorderWidth:1.5f];
            [bgImageView.layer setShadowColor:[UIColor clearColor].CGColor];
            [bgImageView.layer setShadowOpacity:0.8];
            [bgImageView.layer setShadowRadius:3.0];
            [bgImageView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
            bgImageView.layer.masksToBounds = YES;
            break;
        default:
            [bgImageView setImage:[UIImage imageNamed:@"progress-track.png"]];
            break;
    }
    
    [self addSubview:bgImageView];
    
    progressImageView = [[UIImageView alloc] initWithFrame:
                         CGRectMake(
                                    0,
                                    0,
                                    0,
                                    frame.size.height )
                         ];
    
    switch (barColor) {
        case DTAProgressBarCustom:
            [progressImageView.layer setCornerRadius:10.0f];
            [progressImageView.layer setBorderColor:[UIColor clearColor].CGColor];
            [progressImageView.layer setBorderWidth:1.5f];
            [progressImageView.layer setShadowColor:[UIColor clearColor].CGColor];
            [progressImageView.layer setShadowOpacity:0.8];
            [progressImageView.layer setShadowRadius:3.0];
            [progressImageView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
            progressImageView.layer.masksToBounds = YES;
            break;
        default:
            break;
    }
    
    [self addSubview:progressImageView];
    
    CGSize bgImageScale;
    if (customViewFromNIB == YES) {
        bgImageScale = [self getScale:bgImageView.image.size
                            fitInSize:bgImageView.frame.size
                             withMode:self.contentMode
                        ];
    }
    else {
        bgImageScale = [self getScale:bgImageView.frame.size
                            fitInSize:bgImageView.image.size
                             withMode:self.contentMode
                        ];
    }
    
    CGFloat topPadding = TOP_PADDING;
    if (bgImageScale.height > 1) {
        topPadding *= bgImageScale.height;
    }
    
    CGFloat bgImageHeight = bgImageView.frame.size.height;
    if (bgImageScale.height < 1) {
        bgImageHeight -= (bgImageView.frame.size.height - topPadding) * bgImageScale.height;
    }
    
    CGFloat centerY = bgImageView.center.y;
    CGFloat percentViewY = topPadding + centerY - bgImageHeight / 2;
    CGFloat percentViewHeight = (centerY - percentViewY)*2;
    
    if (percentViewHeight < PERCENT_VIEW_MIN_HEIGHT) {
        NSLog(@"DTAProgressBarDraw: Frame heigh is too small to draw PercentView");
        return;
    }
    
    customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    customLabel.backgroundColor = [UIColor clearColor];
    customLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:customLabel];
    
    percentView = [[UIView alloc] initWithFrame:
                   CGRectMake(
                              LEFT_PADDING,
                              percentViewY,
                              PERCENT_VIEW_WIDTH,
                              percentViewHeight )
                   ];
    
    UIImageView* percentImageView = [[UIImageView alloc] initWithFrame:
                                     CGRectMake(
                                                0,
                                                0,
                                                PERCENT_VIEW_WIDTH,
                                                percentViewHeight )
                                     ];
    
    [percentImageView setImage:[UIImage imageNamed:@"progress-count.png"]];
    
    UILabel* percentLabel = [[UILabel alloc] initWithFrame:
                             CGRectMake(
                                        0,
                                        0,
                                        PERCENT_VIEW_WIDTH,
                                        percentViewHeight )
                             ];
    
    [percentLabel setTag:1];
    [percentLabel setText:@"0"];
    [percentLabel setBackgroundColor:[UIColor clearColor]];
    [percentLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [percentLabel setTextAlignment:UITextAlignmentCenter];
    [percentLabel setAdjustsFontSizeToFitWidth:YES];
    
    [percentView addSubview:percentImageView];
    [percentView addSubview:percentLabel];
    
    [self addSubview:percentView];
    
    self.showPercent = YES;
    self.showProgressLabel = YES;
    self.minProgressValue = 0.0f;
    self.maxProgressValue = 1.0f;
    self.progress = 0.0f;
    
}

- (void)progressImageDraw
{
    BOOL showPercent;
    if (self.maxProgressValue <= 1.0 || self.maxProgressValue >= 1000.0) {
        showPercent = YES;
    }
    else {
        showPercent = self.showPercent;
    }
    
    CGFloat percentProgress = (progress - self.minProgressValue) /
    (self.maxProgressValue - self.minProgressValue);
    
    progressImageView.image = progressFillImage;
    
    CGRect frame = progressImageView.frame;
    
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.height = bgImageView.frame.size.height;
    
    frame.size.width = bgImageView.frame.size.width * percentProgress;
    
    progressImageView.frame = frame;
    
    CGRect percentFrame = percentView.frame;
    
    float percentViewWidth = percentView.frame.size.width;
    float leftEdge = (progressImageView.frame.size.width - percentViewWidth) - RIGHT_PADDING;
    
    percentFrame.origin.x = (leftEdge < LEFT_PADDING) ? LEFT_PADDING : leftEdge;
    percentView.frame = percentFrame;
    
    UILabel* percentLabel = (UILabel*)[percentView viewWithTag:1];
    if (showPercent == YES) {
        // show percent
        if (percentProgress > 0) {
            [percentLabel setText:
             [NSString stringWithFormat:@"%d%%", (int)(percentProgress*100)]];
        }
        else {
            [percentLabel setText:@"0"];
        }
    }
    else {
        // show integral
        [percentLabel setText:[NSString stringWithFormat:@"%d", (int)progress]];
    }
    
    if (self.showProgressLabel) {
        percentView.hidden = NO;
        percentLabel.hidden = NO;
    } else {
        percentLabel.hidden = YES;
        percentView.hidden = YES;
    }
}

-(NSString*)getImageNameFromBarDefinition:(DTAProgressBarColor)barDef
{
    NSString* imageName;
    
    switch (barDef) {
        case DTAProgressBarBlue:
            imageName = @"progress-fill-blue.png";
            break;
        case DTAProgressBarRed:
            imageName = @"progress-fill-red.png";
            break;
        case DTAProgressBarBrown:
            imageName = @"progress-fill-brown.png";
            break;
        case DTAProgressBarGreen:
            imageName = @"progress-fill-green.png";
            break;
        case DTAProgressBarCustom:
            imageName = @"";
            break;
        default:
            imageName = @"progress-fill-green.png";
            break;
    }
    
    return imageName;
}

- (CGSize)getScale:(CGSize)originalSize fitInSize:(CGSize)boxSize withMode:(UIViewContentMode)mode
{
    CGFloat sx = boxSize.width/originalSize.width;
    CGFloat sy = boxSize.height/originalSize.height;
    CGFloat s = 1.0;
    
    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFit:
            s = fminf(sx, sy);
            return CGSizeMake(s, s);
            break;
            
        case UIViewContentModeScaleAspectFill:
            s = fmaxf(sx, sy);
            return CGSizeMake(s, s);
            break;
            
        case UIViewContentModeScaleToFill:
            return CGSizeMake(sx, sy);
            
        default:
            return CGSizeMake(s, s);
    }
}


@end
