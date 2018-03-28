//
//  STServicesImpl.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 11/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STServicesImpl.h"
#import "STLanguagesServiceImpl.h"
#import "STTranslationServiceImpl.h"
#import "STDatabaseServiceImpl.h"
#import "STParserServiceImpl.h"
#import "STAPIServiceImpl.h"
#import "STTrackingServiceImpl.h"

@interface STServicesImpl()
@property (strong, nonatomic) id <STLanguagesService> languagesService;
@property (strong, nonatomic) id <STTranslationService> translationService;
@property (strong, nonatomic) id <STDatabaseService> databaseService;
@property (strong, nonatomic) id <STParserService> parserService;
@property (strong, nonatomic) id <STAPIService> apiService;
@property (strong, nonatomic) id <STTrackingService> trackingService;
@end

@implementation STServicesImpl
- (instancetype)init {
    if (self = [super init]) {
        _languagesService = [STLanguagesServiceImpl new];
        _parserService = [[STParserServiceImpl alloc] initWithLanguageService:self.languagesService];
        _databaseService = [[STDatabaseServiceImpl alloc] initWithLanguagesService:self.languagesService];
        _apiService = [[STAPIServiceImpl alloc] initWithParserService:self.parserService];
        _translationService = [[STTranslationServiceImpl alloc] initWithAPIService:self.apiService];
        _trackingService = [STTrackingServiceImpl new];
    }
    
    return self;
}

@end
