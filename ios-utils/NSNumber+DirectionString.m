//
//  NSNumber+DirectionString.m
//  ios-utils
//
//  Created by Derek Trauger on 5/10/13.
//  Copyright (c) 2013 Derek Trauger. All rights reserved.
//

#import "NSNumber+DirectionString.h"

@implementation NSNumber (DirectionString)

-(NSString *) directionString {
    CGFloat currentHeading = [self floatValue];
    
    NSString *strDirection = @"";
    
    if (currentHeading <= 360.0 && currentHeading >= 348.75) {
        strDirection = NSLocalizedString(@"N", nil);
    } else if (currentHeading >= 0 && currentHeading <= 11.25) {
        strDirection = NSLocalizedString(@"N", nil);
    } else if (currentHeading >= 11.25 && currentHeading <= 33.75) {
        strDirection = NSLocalizedString(@"NNE", nil);
    } else if (currentHeading >= 33.75 && currentHeading <= 56.25) {
        strDirection = NSLocalizedString(@"NE", nil);
    } else if (currentHeading >= 56.25 && currentHeading <= 78.75) {
        strDirection = NSLocalizedString(@"ENE", nil);
    } else if (currentHeading >= 78.75 && currentHeading <= 101.25) {
        strDirection = NSLocalizedString(@"E", nil);
    } else if (currentHeading >= 101.25 && currentHeading <= 123.75) {
        strDirection = NSLocalizedString(@"ESE", nil);
    } else if (currentHeading >= 123.75 && currentHeading <= 146.25) {
        strDirection = NSLocalizedString(@"SE", nil);
    } else if (currentHeading >= 146.25 && currentHeading <= 168.75) {
        strDirection = NSLocalizedString(@"SSE", nil);
    } else if (currentHeading >= 168.75 && currentHeading <= 191.25) {
        strDirection = NSLocalizedString(@"S", nil);
    } else if (currentHeading >= 191.25 && currentHeading <= 213.75) {
        strDirection = NSLocalizedString(@"SSW", nil);
    } else if (currentHeading >= 213.75 && currentHeading <= 236.25) {
        strDirection = NSLocalizedString(@"SW", nil);
    } else if (currentHeading >= 236.25 && currentHeading <= 258.75) {
        strDirection = NSLocalizedString(@"WSW", nil);
    } else if (currentHeading >= 258.75 && currentHeading <= 281.25) {
        strDirection = NSLocalizedString(@"W", nil);
    } else if (currentHeading >= 281.25 && currentHeading <= 303.75) {
        strDirection = NSLocalizedString(@"WNW", nil);
    } else if (currentHeading >= 303.75 && currentHeading <= 326.25) {
        strDirection = NSLocalizedString(@"NW", nil);
    } else if (currentHeading >= 326.25 && currentHeading <= 348.47) {
        strDirection =NSLocalizedString(@"NNW", nil);
    } else {
        strDirection = NSLocalizedString(@"Not Available", nil);
    }
    
    return strDirection;

}

@end
