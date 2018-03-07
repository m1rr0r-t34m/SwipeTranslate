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

- (void)setObjectValue:(id)objectValue {
    if (objectValue) {
        [self fillWithModel:(STFavouriteCellModel *)objectValue];
    }
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    
    //border
    self.wantsLayer = YES;
    NSColor *borderColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    CALayer *cellBorder = [CALayer layer];
    cellBorder.frame = CGRectMake(0.0f, 0, self.frame.size.width, 1.0f);
    cellBorder.backgroundColor = borderColor.CGColor;
    [self.layer addSublayer:cellBorder];
    
    //text fields
    NSTextField *input = [self createTextField];
    NSTextField *output = [self createTextField];
    
    
    [self addSubview:input];
    [self addSubview:output];
    
    [[input.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:15] setActive:YES];
    [[input.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20] setActive:YES];
    [[input.topAnchor constraintEqualToAnchor:self.topAnchor constant:10] setActive:YES];
    [[input.heightAnchor constraintEqualToConstant:25] setActive:YES];
    
    [[output.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:15] setActive:YES];
    [[output.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20] setActive:YES];
    [[output.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10] setActive:YES];
    [[output.heightAnchor constraintEqualToConstant:25] setActive:YES];
    
    NSButton *removeButton = [self createRemoveButton];
    [self addSubview:removeButton];
    [[removeButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:10] setActive:YES];
    [[removeButton.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0] setActive:YES];
    [[removeButton.widthAnchor constraintEqualToConstant:20] setActive:YES];
    [[removeButton.heightAnchor constraintEqualToConstant:20] setActive:YES];
    
    self.inputLabel = input;
    self.outputLabel = output;
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
    self.removeButton = button;
    
    return button;
}
@end
