//
//  DataSourceDelegate.h
//  googleTranslateWidget
//
//  Created by Andrei on 24/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataSourceDelegate < NSObject >
-(void)sourceLanguageTableSelectionDidChange:(NSString *)index;
-(void)targetLanguageTableSelectionDidChange:(NSString *)index;
@end
