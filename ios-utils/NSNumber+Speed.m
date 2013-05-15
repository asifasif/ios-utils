//
//  NSNumber+WindSpeed.m
//  ios-utils
//
//  Created by Derek Trauger on 5/8/13.
//  Copyright (c) 2013 Derek Trauger. All rights reserved.
//

#import "NSNumber+Speed.h"

@implementation NSNumber (Speed)

-(NSNumber *) mps {
    return self;
}

-(NSNumber *) mph {
    return [NSNumber numberWithFloat:[self floatValue] * 2.2369362920544];
}

-(NSNumber *) kph {
    return [NSNumber numberWithFloat:[self floatValue] * 3.6];
}

-(NSNumber *) knots {
    return [NSNumber numberWithFloat:[self floatValue] * 1.9438];
}

-(NSNumber *) mach {
    return [NSNumber numberWithFloat:[self floatValue] * 0.0029];
}

-(NSNumber *) beaufort {
    if ([self floatValue] < 0.3) {
        return [NSNumber numberWithInt:0];
    } else if ([self floatValue] < 1.6) {
        return [NSNumber numberWithInt:1];
    } else if ([self floatValue] < 3.5) {
        return [NSNumber numberWithInt:2];
    } else if ([self floatValue] < 5.5) {
        return [NSNumber numberWithInt:3];
    } else if ([self floatValue] < 8.0) {
        return [NSNumber numberWithInt:4];
    } else if ([self floatValue] < 10.8) {
        return [NSNumber numberWithInt:5];
    } else if ([self floatValue] < 13.9) {
        return [NSNumber numberWithInt:6];
    } else if ([self floatValue] < 17.2) {
        return [NSNumber numberWithInt:7];
    } else if ([self floatValue] < 20.8) {
        return [NSNumber numberWithInt:8];
    } else if ([self floatValue] < 24.5) {
        return [NSNumber numberWithInt:9];
    } else if ([self floatValue] < 28.5) {
        return [NSNumber numberWithInt:10];
    } else if ([self floatValue] < 32.7) {
        return [NSNumber numberWithInt:11];
    } else if ([self floatValue] >= 32.7) {
        return [NSNumber numberWithInt:12];
    } else {
        return [NSNumber numberWithInt:0];
    }
}

@end
