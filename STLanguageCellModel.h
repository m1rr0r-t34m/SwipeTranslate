//
//  STLanguageCellModel.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 30/03/2017.
//  Copyright © 2017 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STLanguage;

@interface STLanguageCellModel : NSObject <NSCopying>
@property (strong, nonatomic) STLanguage *language;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL selected;
- (instancetype)initWithLanguage:(STLanguage *)language;
@end
