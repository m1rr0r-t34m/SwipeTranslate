//
//  MainViewControllerModel.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "MainViewControllerModel.h"

@implementation MainViewControllerModel

-(instancetype)init {
    if(self = [super init]) {
        self.sourceLanguages = @[@"English", @"Russian", @"Finnish", @"Swedish", @"French", @"German", @"Italian", @"Arabic", @"Danish"];
        self.targetLanguages = @[@"English", @"Russian", @"Finnish", @"Swedish", @"French", @"German", @"Italian", @"Arabic", @"Danish"];
    }
    return self;
}

@end
