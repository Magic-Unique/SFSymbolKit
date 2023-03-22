//
//  SKPath.h
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/6.
//

#import <Foundation/Foundation.h>
#import "SKType.h"

@class SKXMLElement, SKStyleClassName;

@interface SKPath : NSObject

@property (nonatomic, strong) SKBezierPath *bezierPath;

@property (nonatomic, strong) SKColor *fillColor;

@property (nonatomic, strong) SKColor *strockColor;

@property (nonatomic, strong) NSArray<SKStyleClassName *> *classList;

- (instancetype)initWithElement:(SKXMLElement *)element;

@end
