//
//  LeftSplitViewModel.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLeftSplitViewModel.h"

@implementation STLeftSplitViewModel

-(instancetype)init {
    if(self = [super init]) {
        self.sourceLanguages = @[@"English", @"Russian", @"Finnish", @"Swedish", @"French", @"German", @"Italian", @"Arabic", @"Danish"];
        self.targetLanguages = @[@"English", @"Russian", @"Finnish", @"Swedish", @"French", @"German", @"Italian", @"Arabic", @"Danish"];
    }
    return self;
}

@end
