//
//  SKStyle.h
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/13.
//

#import <Foundation/Foundation.h>
#import "SKType.h"




@interface SKStyleClassName : NSObject

@property (nonatomic, strong, readonly) NSString *fullName;
@property (nonatomic, strong, readonly) NSString *shortName;
@property (nonatomic, assign, readonly) NSUInteger index;
@property (nonatomic, strong, readonly) NSString *colorName;

+ (instancetype)classNameWithText:(NSString *)text;

@end



@interface SKClassStyle : NSObject

@property (nonatomic, strong) SKStyleClassName *className;

@property (nonatomic, strong) NSDictionary *content;

@property (nonatomic, strong) SKColor *fill;

@property (nonatomic, assign) double variableThreshold;

@property (nonatomic, assign, readonly) BOOL clearBehind;

+ (instancetype)styleWithText:(NSString *)text;

- (BOOL)isEnableForVariable:(double)variable;

@end
