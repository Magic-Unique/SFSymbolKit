//
//  SKBezierParser.h
//  Pods
//
//  Created by Magic-Unique on 2022/9/16.
//

#import <Foundation/Foundation.h>
#import "SKType.h"

@interface SKBezierParser : NSObject

@property (nonatomic, strong) NSString *d;
@property (nonatomic, strong, readonly) SKBezierPath *path;
@property (nonatomic, strong, readonly) NSError *error;

- (BOOL)parse;

@end
