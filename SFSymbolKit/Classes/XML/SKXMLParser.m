//
//  SKXMLParser.m
//  SKSymbolKit
//
//  Created by Magic-Unique on 2022/9/1.
//

#import "SKXMLParser.h"
#import "SKStack.h"
#import "SKXMLDocument.h"
#import "SKStyleParser.h"

@interface SKXMLParser ()

@property (nonatomic, strong) NSXMLParser *XMLParser;

@property (nonatomic, strong, readonly) SKStack<SKXMLElement *> *elementStack;

@property (nonatomic, strong) SKXMLElement *rootElement;

@end

@interface SKXMLParser (XML) <NSXMLParserDelegate> @end

@implementation SKXMLParser

+ (SKXMLElement *)parseURL:(NSURL *)URL error:(NSError *__autoreleasing *)error {
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
    SKXMLParser *svgParser = [[SKXMLParser alloc] initWithXMLParser:xmlParser];
    NSError *_error = [svgParser parse];
    if (error) {
        *error = _error;
    }
    if (_error) {
        return nil;
    }
    return svgParser.rootElement;
}

- (instancetype)initWithXMLParser:(NSXMLParser *)XMLParser {
    self = [super init];
    if (self) {
        _XMLParser = XMLParser;
        _XMLParser.delegate = self;
        _elementStack = [[SKStack alloc] init];
    }
    return self;
}

- (NSError *)parse {
    [self.XMLParser parse];
    return self.XMLParser.parserError;
}

@end

#pragma mark - XML Parser

@implementation SKXMLParser (XML)

// sent when the parser begins parsing of the document.
- (void)parserDidStartDocument:(NSXMLParser *)parser {}

// sent when the parser has completed parsing. If this is encountered, the parse was successful.
- (void)parserDidEndDocument:(NSXMLParser *)parser {}

// sent when the parser finds an element start tag.
// In the case of the cvslog tag, the following is what the delegate receives:
//   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
// In the case of the radar tag, the following is what's passed in:
//    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
// If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, the elementName is 'radar:radar' and there is no qualifiedName.
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    SKXMLElement *last = [self.elementStack topElement];
    SKXMLElement *current = [[SKXMLElement alloc] init];
    current.name = elementName;
    current.attributes = attributeDict;
    [last.subelements addObject:current];
    [self.elementStack pushElement:current];
    
    if (!self.rootElement) {
        self.rootElement = current;
    }
}

// sent when an end tag is encountered. The various parameters are supplied as above.
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {
    [self.elementStack popElement];
}

// This returns the string of the characters encountered thus far. You may not necessarily get the longest character run. The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    SKXMLElement *element = [self.elementStack topElement];
    element.contents = string;
}

// A comment (Text in a <!-- --> block) is reported to the delegate as a single string
- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment {
    if (!self.elementStack.topElement) {
        return;
    }
    NSArray *list = [comment componentsSeparatedByString:@", "];
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    NSCharacterSet *trimSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
    for (NSString *line in list) {
        NSArray<NSString *> *components = [line componentsSeparatedByString:@": "];
        if (components.count == 2) {
            NSString *key = components.firstObject;
            NSString *value = components.lastObject;
            map[key] = [value stringByTrimmingCharactersInSet:trimSet];
        }
    }
    self.elementStack.topElement.comments = map;
}

@end
