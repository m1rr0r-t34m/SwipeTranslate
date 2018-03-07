//
//  STTranslation.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 21/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STTranslation.h"
#import "STParserResult.h"

@implementation STTranslation
+ (instancetype)emptyTranslation {
    STTranslation *translation = [STTranslation new];
    translation.parserResult = [STParserResult new];
    return translation;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.inputText forKey:@"inputText"];
    [aCoder encodeObject:self.parserResult forKey:@"parserResult"];
    [aCoder encodeObject:self.sourceLanguage forKey:@"sourceLanguage"];
    [aCoder encodeObject:self.targetLanguage forKey:@"targetLanguage"];
    [aCoder encodeObject:self.detectedLanguage forKey:@"detectedLanguage"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _type = [aDecoder decodeIntegerForKey:@"type"];
        _inputText = [aDecoder decodeObjectForKey:@"inputText"];
        _parserResult = [aDecoder decodeObjectForKey:@"parserResult"];
        _sourceLanguage = [aDecoder decodeObjectForKey:@"sourceLanguage"];
        _targetLanguage = [aDecoder decodeObjectForKey:@"targetLanguage"];
        _detectedLanguage = [aDecoder decodeObjectForKey:@"detectedLanguage"];
    }
    
    return self;
}
@end
