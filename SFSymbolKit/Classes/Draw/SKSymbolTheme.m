//
//  SKSymbolTheme.m
//  Pods
//
//  Created by Magic-Unique on 2023/3/10.
//

#import "SKSymbolTheme.h"
#import "SKSymbolColor.h"
#import "SKTypeCategory.h"

@implementation SKSymbolTheme

+ (instancetype)sharedTheme {
    static SKSymbolTheme *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _weight = SKSymbolWeightRegular;
        _scale = SKSymbolScaleSmall;
        _color = [SKSymbolColor monochrome];
    }
    return self;
}

- (void)publish {
    [[NSNotificationCenter defaultCenter] postNotificationName:SKSymbolThemeDidChangeNotification
                                                        object:self
                                                      userInfo:nil];
}

+ (SKSymbolWeight)currentSymbolWeight {
    return [SKSymbolTheme sharedTheme] ? [SKSymbolTheme sharedTheme].weight : SKSymbolWeightRegular;
}

@end

NSNotificationName const SKSymbolThemeDidChangeNotification = @"SKSymbolThemeDidChangeNotification";
