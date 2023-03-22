//
//  SKGraphicParser.h
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/13.
//

#import <Foundation/Foundation.h>
#import "SKXMLDocument.h"

@class SKGraphic;

@interface SKGraphicParser : NSObject

@property (nonatomic, assign) CGFloat pointSize;
@property (nonatomic, strong) SKXMLElement *g;

@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, strong, readonly) SKGraphic *graphic;

- (BOOL)parse;

@end
