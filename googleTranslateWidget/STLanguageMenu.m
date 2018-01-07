//
//  STLanguageMenu.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 07/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STLanguageMenu.h"
#import "STLanguagesManager.h"
#import <ReactiveObjC.h>
#import "STLanguage.h"

@interface STLanguageMenu()
@property (strong, nonatomic) RACSubject *selectSubject;
@end

@implementation STLanguageMenu
//TODO: make reusable, not only for languages
- (instancetype)init {
    if (self = [super init]) {
        _selectSubject = [RACSubject new];
        _selectSignal = [_selectSubject deliverOnMainThread];
        [self fillData];
    }
    
    return self;
}

- (void)fillData {
    self.autoenablesItems = NO;
    
    for(NSString *letter in Alphabet) {
        NSMenuItem *lettersMenuItem = [self addItemWithTitle:letter action:nil keyEquivalent:@""];
        lettersMenuItem.enabled = YES;
        
        NSMenu *letterMenu = [NSMenu new];
        letterMenu.autoenablesItems = NO;
        
        NSArray <STLanguage *> *languages = [STLanguagesManager languagesForLetter:letter];
        for(STLanguage *language in languages) {
            NSMenuItem *languageItem = [letterMenu addItemWithTitle:language.title action:@selector(selectedLanguage:) keyEquivalent:@""];
            languageItem.target = self;
            languageItem.enabled = YES;
        }
        
        [self setSubmenu:letterMenu forItem:lettersMenuItem];
    }
}

- (void)selectedLanguage:(NSMenuItem *)item {
    NSString *key = [STLanguagesManager keyForLanguage:item.title];
    STLanguage *language = [[STLanguage alloc] initWithKey:key andTitle:item.title];
    [self.selectSubject sendNext:language];
}
@end
