//
//  SKXMLParser.h
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/1.
//

#import <Foundation/Foundation.h>

@class SKXMLElement;

@interface SKXMLParser : NSObject

+ (SKXMLElement *)parseFile:(NSString *)SVCFilePath error:(NSError **)error;

@end
