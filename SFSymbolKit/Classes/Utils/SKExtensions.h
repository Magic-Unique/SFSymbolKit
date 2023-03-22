//
//  SKExtensions.h
//  Pods
//
//  Created by Magic-Unique on 2023/3/12.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN id SKFirstObjectInArray(NSArray *array, BOOL (^filter)(id object));

FOUNDATION_EXTERN id SKLastObjectInArray(NSArray *array, BOOL (^filter)(id object));
