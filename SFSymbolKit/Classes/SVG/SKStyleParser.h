//
//  SKStyleParser.h
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/2.
//

#import <Foundation/Foundation.h>

@class SKStyle;

@interface SKStyleParser : NSObject

+ (NSDictionary *)parseStyleTable:(NSString *)style;

+ (NSDictionary *)parseStyleAttribute:(NSString *)style;

@end
