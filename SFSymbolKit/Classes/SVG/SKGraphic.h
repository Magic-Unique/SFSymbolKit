//
//  SKGraphic.h
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/6.
//

#import "SKType.h"

@class SKPath;

@interface SKGraphic : NSObject

@property (nonatomic, strong) SKSymbolWeight symbolWeight;

@property (nonatomic, strong) SKSymbolScale symbolScale;

@property (nonatomic, assign) CGAffineTransform transform;

@property (nonatomic, assign) SKSize contentSize;

@property (nonatomic, strong) NSArray<SKPath *> *paths;

@property (nonatomic, strong) SKBezierPath *fullBezierPath;

@end

