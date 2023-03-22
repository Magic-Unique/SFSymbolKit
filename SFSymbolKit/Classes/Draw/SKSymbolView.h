//
//  SKSymbolView.h
//  Pods
//
//  Created by Magic-Unique on 2022/9/21.
//

#import "SKType.h"
#import "SKSymbolDrawable.h"

#if SK_TARGET_IOS
#import <UIKit/UIKit.h>
typedef UIView SKView;
#elif SK_TARGET_MAC
#import <AppKit/AppKit.h>
typedef NSView SKView;
#endif

@class SKSymbolLayer;
@class SKSymbolImage;

@interface SKSymbolView : SKView <SKSymbolDrawable>

@property (nonatomic, strong) SKSymbolImage *symbolImage;

@property (readonly) SKSymbolLayer *symbolLayer;

- (instancetype)initWithSymbolImage:(SKSymbolImage *)symbolImage;

@end
