//
//  STLanguageCell.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import "STLanguageCell.h"
#import "STLanguageCellModel.h"

@interface STLanguageCell()
@property (weak) IBOutlet NSTextField *label;
@property (strong, nonatomic) STLanguageCellModel *model;
@property (strong) IBOutlet NSBox *separator;
@end

@implementation STLanguageCell
- (void)fillWithModel:(STLanguageCellModel *)model {
    self.model = model;
    [self.label setStringValue:model.title];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.selected) {
        self.separator.alphaValue = 0;
    } else {
        self.separator.alphaValue = 1;
    }
    
}
@end
