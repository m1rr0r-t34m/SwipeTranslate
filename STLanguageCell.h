//
//  STLanguageCell.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class STLanguageCellModel;

@interface STLanguageCell : NSTableCellView
@property (weak) IBOutlet NSTextField *label;
@property (strong, nonatomic) STLanguageCellModel *viewModel;
@end
