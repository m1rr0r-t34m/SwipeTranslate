//
//  LeftSplitViewModel.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 19/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLeftSplitViewModel.h"
#import "STLanguages.h"
@implementation STLeftSplitViewModel

-(instancetype)init {
    if(self = [super init]) {
        self.sourceLanguages = Languages;
        self.targetLanguages = Languages;
    }
    return self;
}

@end
