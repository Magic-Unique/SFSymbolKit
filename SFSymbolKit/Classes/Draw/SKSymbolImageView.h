//
//  SKSymbolImageView.h
//  Pods
//
//  Created by Magic-Unique on 2023/3/3.
//

#import "SKType.h"
#ifdef SK_TARGET_MAC
#import <AppKit/AppKit.h>
#else
#import <UIKit/UIKit.h>
#endif
#import "SKSymbolDrawable.h"

@interface SKSymbolImageView : SKImageView <SKSymbolDrawable>

- (instancetype)initWithSymbolImage:(SKSymbolImage *)symbolImage;

@end
