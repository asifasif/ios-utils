//
//  NSNumber+WindSpeed.h
//  ios-utils
//
//  Created by Derek Trauger on 5/8/13.
//  Copyright (c) 2013 Derek Trauger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Speed)

-(NSNumber *) mps;
-(NSNumber *) mph;
-(NSNumber *) kph;
-(NSNumber *) knots;
-(NSNumber *) beaufort;

@end
