//
//  MainViewControllerModel.h
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 18/08/16.
//  Copyright © 2016 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STMainViewModel : NSObject

@property (strong, nonatomic) NSString *sourceText;
@property (strong, nonatomic) NSString *sourceLanguage;
@property (strong, nonatomic) NSString *targetLanguage;

@property (strong, nonatomic) NSAttributedString *translatedText;

@end
