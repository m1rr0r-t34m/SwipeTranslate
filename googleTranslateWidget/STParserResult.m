//
//  STParserResult.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 23/02/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STParserResult.h"

@implementation STParserResult
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.parsedResponse forKey:@"parsedResponse"];
    [aCoder encodeObject:self.detectedLanguage forKey:@"detectedLanguage"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _type = [aDecoder decodeIntegerForKey:@"type"];
        _parsedResponse = [aDecoder decodeObjectForKey:@"parsedResponse"];
        _detectedLanguage = [aDecoder decodeObjectForKey:@"detectedLanguage"];
    }
    
    return self;
}
@end
