//
//  STFavouriteCell.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 07/03/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STFavouriteCell.h"
#import "STFavouriteCellModel.h"
#import <ReactiveObjC.h>

@interface STFavouriteCell()
@property (strong) IBOutlet NSTextField *inputLabel;
@property (strong) IBOutlet NSTextField *outputLabel;
@property (strong) IBOutlet NSButton *removeButton;
@property (strong) IBOutlet NSBox *separator;
@end

@implementation STFavouriteCell
- (void)fillWithModel:(STFavouriteCellModel *)model {
    NSAttributedString *input = [[NSAttributedString alloc] initWithString:model.inputText attributes:[self inputTextStyle]];
    NSAttributedString *output = [[NSAttributedString alloc] initWithString:model.outputText attributes:[self outputTextStyle]];
    
    self.removeButton.rac_command = model.command;
    self.inputLabel.attributedStringValue = input;
    self.outputLabel.attributedStringValue = output;
    self.needsDisplay = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //text fields
    NSTextField *input = [self createTextField];
    NSTextField *output = [self createTextField];
    
    
    [self addSubview:input];
    [self addSubview:output];
    
    [[input.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:15] setActive:YES];
    [[input.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-30] setActive:YES];
    [[input.topAnchor constraintEqualToAnchor:self.topAnchor constant:10] setActive:YES];
    [[input.heightAnchor constraintEqualToConstant:25] setActive:YES];
    
    [[output.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:15] setActive:YES];
    [[output.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-30] setActive:YES];
    [[output.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10] setActive:YES];
    [[output.heightAnchor constraintEqualToConstant:25] setActive:YES];
    
    NSButton *removeButton = [self createRemoveButton];
    [self addSubview:removeButton];
    [[removeButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:10] setActive:YES];
    [[removeButton.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10] setActive:YES];
    [[removeButton.widthAnchor constraintEqualToConstant:20] setActive:YES];
    [[removeButton.heightAnchor constraintEqualToConstant:20] setActive:YES];
    
    NSBox *separator = [self createSeparator];
    [self addSubview:separator];
    [[separator.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
    [[separator.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
    [[separator.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-1] setActive:YES];
    
    self.inputLabel = input;
    self.outputLabel = output;
    self.removeButton = removeButton;
    self.separator = separator;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.separator.alphaValue = 0;
    } else {
        self.separator.alphaValue = 1;
    }
}

- (NSDictionary *)inputTextStyle {
    NSFont *inputStyleFont = [NSFont systemFontOfSize:18 weight:NSFontWeightLight];
    return @{NSFontAttributeName : inputStyleFont, NSForegroundColorAttributeName : [NSColor colorWithCalibratedRed:0.2 green:0.2 blue:0.2 alpha:1]};
}

- (NSDictionary *)outputTextStyle {
    NSFont *outputStyleFont = [NSFont systemFontOfSize:14 weight:NSFontWeightLight];
    return @{NSFontAttributeName : outputStyleFont, NSForegroundColorAttributeName : [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.6]};
    
}

- (NSTextField *)createTextField {
    NSTextField *field = [NSTextField new];
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.drawsBackground = NO;
    field.bordered = NO;
    field.editable = NO;
    field.selectable = NO;
    field.backgroundColor = [NSColor clearColor];
    return field;
}

- (NSButton *)createRemoveButton {
    NSButton *button = [NSButton new];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.image = [NSImage imageNamed:@"ClearButtonMain"];
    button.bordered = NO;
    button.imageScaling = NSImageScaleProportionallyUpOrDown;
    
    return button;
}

- (NSBox *)createSeparator {
    NSBox *separator = [NSBox new];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.boxType = NSBoxSeparator;
    
    return separator;
}

- (void)drawSelectionInRect:(NSRect)dirtyRect {
    NSRect biggerRect = CGRectMake(dirtyRect.origin.x, dirtyRect.origin.y, dirtyRect.size.width + 10, dirtyRect.size.height);
    [super drawSelectionInRect:biggerRect];
}
@end
