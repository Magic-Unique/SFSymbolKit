//
//  SKExtensions.m
//  Pods
//
//  Created by Magic-Unique on 2023/3/12.
//

#import "SKExtensions.h"

id SKFirstObjectInArray(NSArray *array, BOOL (^filter)(id object)) {
    for (id object in array) {
        if (filter(object)) {
            return object;
        }
    }
    return nil;
}

id SKLastObjectInArray(NSArray *array, BOOL (^filter)(id object)) {
    for (id object in array.reverseObjectEnumerator) {
        if (filter(object)) {
            return object;
        }
    }
    return nil;
}
