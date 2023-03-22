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

@property (nonatomic, strong) SKSymbolWeight weight;

@property (nonatomic, strong) SKSymbolScale scale;

@property (nonatomic, strong) SKSymbolColor *color;

+ (instancetype)sharedTheme;

- (void)publish;


+ (SKSymbolWeight)currentSymbolWeight;

@end

UIKIT_EXTERN NSNotificationName const SKSymbolThemeDidChangeNotification;
