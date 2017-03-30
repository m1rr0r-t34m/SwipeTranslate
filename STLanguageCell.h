//
//  STLanguageCell.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STLanguageCellModel;


@interface STLanguageCell : NSTableRowView

@property (weak) IBOutlet NSTextField *Label;
@property (strong, nonatomic) STLanguageCellModel *viewModel;

@end
