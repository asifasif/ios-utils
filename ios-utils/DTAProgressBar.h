//
//  DTAProgressBar.h
//  ios-utils
//
//  Created by Derek Trauger on 5/15/13.
//
//

/*!
 Define a Custom UIView to depict the progress of a task over time.
 The amount of **progress** is displayed by a horizontal bar,
 called **progressImageView**, that represents a range of values.
 This range is controlled by the **minProgressValue** and the **maxProgressValue**
 properties, whose default values are 0.0 and 1.0 respectively.
 The user can customize the appearance of the **progressImageView** horizontal bar
 selecting its color in the **DTAProgressBarColor** set.
 The current **progress** is represented by a floating-point value (default 0.0)
 between **minProgressValue** and **maxProgressValue**, inclusive;
 values less or greater are pinned to those limits.
 The current **progress** is shown by the position of a cursor, coupled with
 the **progressImageView** and called **percentView**; within its bounds, it is
 shown a textual indication of the amount of the task that has completed.
 The way this indication is displayed, is controlled by the **showPercent**
 property: by default its value is 'YES' and the current **progress** is
 formatted as a percent complete respect the range of values.
 The user can set to 'NO' the **showPercent** property to display the integral
 amount of the task that has completed.
 Since the width of the **progressImageView** cursor is fixed to 3 textual
 characters wide, if **maxProgressValue** is greater than 999, then the current
 **progress** is formatted as a percent even if the **showPercent** property
 is set to 'NO'.
 The **showPercent** property isn't taken in account also when the
 **maxProgressValue** is less or equal to 1.0: the current **progress** will be
 always formatted as a percent.
 This Custom UIView can be created and instantiated both in-code
 (programmatically) or via a nib (storyboard).
 For this reason, are supported both 'initWithFrame:andProgressBarColor:' and
 'initWithCoder:' methods respectively.
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DTAProgressBar : UIControl

// Types

/// Set of **progressImageView** horizontal bar colors.
typedef enum
{
    DTAProgressBarGreen,
    DTAProgressBarRed,
    DTAProgressBarBrown,
    DTAProgressBarBlue,
    DTAProgressBarCustom
} DTAProgressBarColor;

// Properties

/// The current amount of the task that has completed (default 0.0).
@property (nonatomic, readwrite, assign) CGFloat progress;

/// The **progressImageView** horizontal bar color in the **DTAProgressBarColor** set
/// (default DTAProgressBarBlue).
@property (nonatomic, readwrite, assign) DTAProgressBarColor progressBarColor;

/// Minimum in the range of **progress** values (default 0.0).
@property (nonatomic, readwrite, assign) CGFloat minProgressValue;

/// Maximum in the range of **progress** values (default 1.0).
@property (nonatomic, readwrite, assign) CGFloat maxProgressValue;

/// Toggle between percent or integral view of current **progress**
/// (default 'YES' = percent)
@property (nonatomic, readwrite, assign) BOOL showPercent;

/// Toggle Progress Label
/// (default 'YES' = show)
@property (nonatomic, readwrite, assign) BOOL showProgressLabel;

/// Custom Label Value
/// default '' = empty string
@property (nonatomic, readwrite, assign) NSString *customLabelValue;
@property (nonatomic, readwrite, assign) UIFont *customLabelFont;
@property (nonatomic, readwrite, assign) UIColor *customLabelTextColor;


// Methods

/*!
 Override 'initWithFrame' if the view is added programmatically.
 Initializes and returns a newly allocated 'DTAProgressBar' view object.
 The view is allocated with the specified frame rectangle and
 the **progressImageView** horizontal bar color.
 @param frame
 The frame rectangle for the view, measured in points.
 The origin of the frame is relative to the superview in which you plan to add it.
 @param barColor
 The **progressImageView** horizontal bar color in the **DTAProgressBarColor** set.
 @return
 An initialized 'DTAProgressBar' view object
 or nil if the object couldn't be created.
 */
- (id)initWithFrame:(CGRect)frame
andProgressBarColor:(DTAProgressBarColor)barColor;


/*!
 Override 'initWithCoder' if the view is loaded from a nib or storyboard.
 @param coder
 A nib or storyboard object.
 @return
 An 'DTAProgressBar' initialized from a nib or storyboard.
 */
- (id)initWithCoder:(NSCoder *)coder;

@end