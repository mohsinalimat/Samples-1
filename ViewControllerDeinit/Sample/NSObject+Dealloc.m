//
//  NSObject+Dealloc.m
//  Sample
//
//  Created by Lasha Efremidze on 3/11/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

#import "NSObject+Dealloc.h"

@implementation NSObject (Dealloc)

- (void)swizzled_dealloc
{
    NSLog(@"swizzled_dealloc");
    [self swizzled_dealloc];
}

@end
