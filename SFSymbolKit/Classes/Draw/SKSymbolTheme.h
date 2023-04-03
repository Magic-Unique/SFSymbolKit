//
//  SKSymbolTheme.h
//  Pods
//
//  Created by Magic-Unique on 2023/3/10.
//

#import <Foundation/Foundation.h>
#import "SKType.h"

@class SKSymbolColor;

@interface SKSymbolTheme : NSObject

/// Symbol weight must set when init
@property (nonatomic, strong) SKSymbolWeight weight;

/// Symbol scale must set when init
@property (nonatomic, strong) SKSymbolScale scale;

/// Set the color, and publish manually
@property (nonatomic, strong) SKSymbolColor *color;

+ (instancetype)sharedTheme;

/// Publish color changed, Redraw all loaded SKSymbolImage whose color is nil.
- (void)publish;

@end

UIKIT_EXTERN NSNotificationName const SKSymbolThemeDidChangeNotification;
