//
//  SKSymbolManager.h
//  SFSymbolKit
//
//  Created by Magic-Unique on 2023/4/1.
//

#import <Foundation/Foundation.h>

@class SKSymbol;

@interface SKSymbolManager : NSObject

+ (instancetype)sharedManager;

- (SKSymbol *)symbolWithURL:(NSURL *)URL error:(NSError **)error;

@end
