//
//  SKSymbolLayer.h
//  Pods
//
//  Created by Magic-Unique on 2022/9/21.
//

#import <QuartzCore/QuartzCore.h>
#import "SKSymbolDrawable.h"

@class SKSymbol;
@class SKSymbolImage;

@interface SKSymbolLayer : CALayer <SKSymbolDrawable>

@property (nonatomic, strong, readonly) NSArray<CAShapeLayer *> *pathLayers;

@end
