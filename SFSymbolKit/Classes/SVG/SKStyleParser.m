//
//  SKStyleParser.m
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/2.
//

#import "SKStyleParser.h"

@implementation SKStyleParser

+ (NSDictionary *)parseStyleTable:(NSString *)style {
    NSMutableDictionary *classMap = [NSMutableDictionary dictionary];
    [style enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        if (line.length == 0) {
            return;
        }
        if ([line containsString:@" {"] && [line containsString:@"}"]) {
            NSString *class = [self string:line between:@"." and:@" {"];
            NSString *body = [self string:line between:@"{" and:@"}"];
            NSDictionary *attr = [self parseStyleAttribute:body];
            classMap[class] = attr;
        }
    }];
    return classMap;
}

+ (NSDictionary *)parseStyleAttribute:(NSString *)style {
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    NSArray *lines = [style componentsSeparatedByString:@";"];
    for (NSString *line in lines) {
        NSArray *item = [line componentsSeparatedByString:@":"];
        attr[item.firstObject] = item.lastObject;
    }
    return attr;
}

+ (NSString *)string:(NSString *)string between:(NSString *)prefix and:(NSString *)suffix {
    NSRange pr = [string rangeOfString:prefix];
    NSRange sr = [string rangeOfString:suffix];
    return [string substringWithRange:NSMakeRange(pr.location + pr.length, sr.location - pr.location - pr.length)];
}

@end
