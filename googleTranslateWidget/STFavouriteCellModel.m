//
//  STFavouriteCellModel.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 07/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STFavouriteCellModel.h"

@implementation STFavouriteCellModel
- (instancetype)initWithInput:(NSString *)input output:(NSString *)output {
    if (self = [super init]) {
        _inputText = input;
        _outputText = output;
    }
    
    return self;
}
@end
