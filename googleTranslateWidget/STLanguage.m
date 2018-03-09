//
//  STLanguage.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 30/03/2017.
//  Copyright © 2017 Mark Vasiv. All rights reserved.
//

#import "STLanguage.h"

@implementation STLanguage
- (instancetype)initWithKey:(NSString *)key andTitle:(NSString *)title {
    if (self = [super init]) {
        _key = key;
        _title = title;
    }
    return self;
}

- (BOOL)isAuto {
    return [self.key isEqualToString:@"auto"];
}

- (BOOL)isEqual:(id)object {
    if(![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToLanguage:object];
}

- (BOOL)isEqualToLanguage:(STLanguage *)language {
    if(!language) {
        return NO;
    }
    
    return [self.key isEqualToString:language.key] && [self.title isEqualToString:language.title];
}

- (NSUInteger)hash {
    return self.key.hash;
}

- (id)copyWithZone:(NSZone *)zone {
    STLanguage *copy = [[STLanguage allocWithZone:zone] init];
    copy.title = [self.title copy];
    copy.key = [self.key copy];
    
    return copy;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.title forKey:@"title"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _key = [aDecoder decodeObjectForKey:@"key"];
        _title = [aDecoder decodeObjectForKey:@"title"];
    }
    
    return self;
}
@end
