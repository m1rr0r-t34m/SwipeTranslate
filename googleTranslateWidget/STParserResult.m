//
//  STParserResult.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 23/02/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STParserResult.h"
#import "STLanguage.h"

@implementation STParserResult
#pragma mark - NSCoding
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

#pragma mark - Equality
- (BOOL)isEqual:(id)object {
    if(![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToParserResult:object];
}

- (BOOL)isEqualToParserResult:(STParserResult *)parserResult {
    if (!parserResult) {
        return NO;
    }
    
    BOOL equality = (self.type == parserResult.type) && ([self.parsedResponse isEqual:parserResult.parsedResponse]);
    
    if (self.detectedLanguage) {
        equality = equality && ([self.detectedLanguage isEqual:parserResult.detectedLanguage]);
    }
    
    return equality;
}

- (NSUInteger)hash {
    return self.type ^ self.parsedResponse.hash;
}
@end
