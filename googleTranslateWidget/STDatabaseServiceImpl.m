//
//  STDatabaseService.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 19/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STDatabaseServiceImpl.h"
#import <YapDatabase.h>
#import "STLanguage.h"
#import "STTranslation.h"
#import "STLanguagesService.h"

static NSString *databaseName = @"yap";
static NSString *kSourceLanguages = @"source";
static NSString *kTargetLanguages = @"target";
static NSString *kSourceSelected = @"sourceSelected";
static NSString *kTargetSelected = @"targetSelected";
static NSString *kFavourites = @"favourites";


@interface STDatabaseServiceImpl()
@property (strong, nonatomic) YapDatabase *database;
@property (strong, nonatomic) YapDatabaseConnection *connection;
@property (strong, nonatomic) NSMutableDictionary *persistentCache;
@property (strong, nonatomic) id <STLanguagesService> languagesService;
@end

@implementation STDatabaseServiceImpl
#pragma mark - Initialization
- (instancetype)init {
    NSAssert(NO, @"Use designated initializer initWithLanguagesService:");
    self = [super init];
    return self;
}

- (instancetype)initWithLanguagesService:(id <STLanguagesService>)service {
    if (self = [super init]) {
        _languagesService = service;
        _database = [[YapDatabase alloc] initWithPath:[[self documentsPath] stringByAppendingPathComponent:databaseName]];
        _connection = [_database newConnection];
        _persistentCache = [NSMutableDictionary new];
        BOOL dataAvailable = [self performInitialDataCheck];
        if (!dataAvailable) {
            [self fillInitialData];
        }
    }
    
    return self;
}

#pragma mark - Initial data check
- (BOOL)performInitialDataCheck {
    __block BOOL dataAvailable = YES;
    
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        NSArray *sourceLanguages;
        NSArray *targetLanguages;
        NSArray *favourites;
        STLanguage *sourceSelected;
        STLanguage *targetSelected;
        [transaction getObject:&sourceLanguages metadata:nil forKey:kSourceLanguages inCollection:nil];
        [transaction getObject:&targetLanguages metadata:nil forKey:kTargetLanguages inCollection:nil];
        [transaction getObject:&sourceSelected metadata:nil forKey:kSourceSelected inCollection:nil];
        [transaction getObject:&targetSelected metadata:nil forKey:kTargetSelected inCollection:nil];
        [transaction getObject:&favourites metadata:nil forKey:kFavourites inCollection:nil];
        if (!sourceLanguages || !targetLanguages || !sourceSelected || !targetSelected || sourceLanguages.count < defaultLanguagesCount || targetLanguages.count < defaultLanguagesCount || !favourites) {
            dataAvailable = NO;
        }
    }];
    
    return dataAvailable;
}

- (void)fillInitialData {
    NSArray *sourceLanguages = [self.languagesService randomLanguagesExcluding:nil withCount:defaultLanguagesCount];
    NSArray *targetLanguages = [self.languagesService randomLanguagesExcluding:nil withCount:defaultLanguagesCount];
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:sourceLanguages forKey:kSourceLanguages inCollection:nil];
        [transaction setObject:targetLanguages forKey:kTargetLanguages inCollection:nil];
        [transaction setObject:sourceLanguages[0] forKey:kSourceSelected inCollection:nil];
        [transaction setObject:targetLanguages[0] forKey:kTargetSelected inCollection:nil];
        [transaction setObject:[NSArray new] forKey:kFavourites inCollection:nil];
    }];
}

#pragma mark - Select
- (NSArray *)sourceLanguages {
    return [self objectForKey:kSourceLanguages];
}

- (NSArray *)targetLanguages {
    return [self objectForKey:kTargetLanguages];
}

- (STLanguage *)sourceSelectedLanguage {
    return [self objectForKey:kSourceSelected];
}

- (STLanguage *)targetSelectedLanguage {
    return [self objectForKey:kTargetSelected];
}

- (NSArray *)favouriteTranslations {
    return [self objectForKey:kFavourites];
}

- (id)objectForKey:(NSString *)key {
    __block id object = self.persistentCache[key];
    if (!object) {
        [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            [transaction getObject:&object metadata:nil forKey:key inCollection:nil];
        }];
        self.persistentCache[key] = object;
    }
    
    return object;
}

#pragma mark - Insert / Remove
- (void)saveSourceLanguages:(NSArray *)languages {
    [self setObject:languages forKey:kSourceLanguages];
}

- (void)saveTargetLanguages:(NSArray *)languages {
    [self setObject:languages forKey:kTargetLanguages];
}

- (void)saveSourceSelected:(STLanguage *)language {
    [self setObject:language forKey:kSourceSelected];
}

- (void)saveTargetSelected:(STLanguage *)language {
    [self setObject:language forKey:kTargetSelected];
}

- (void)saveFavouriteTranslation:(STTranslation *)translation {
    NSMutableArray *favourites = [[self favouriteTranslations] mutableCopy];
    [favourites insertObject:translation atIndex:0];
    [self setObject:[favourites copy] forKey:kFavourites];
}

- (void)removeFavouriteTranslation:(STTranslation *)translation {
    NSMutableArray *favourites = [[self favouriteTranslations] mutableCopy];
    [favourites removeObject:translation];
    [self setObject:[favourites copy] forKey:kFavourites];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    self.persistentCache[key] = object;
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:object forKey:key inCollection:nil];
    }];
}

#pragma mark - Heleprs
- (NSString *)documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
@end
