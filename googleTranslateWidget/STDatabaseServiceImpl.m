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
static NSString *kUsedFavourites = @"usedFavourites";
static NSString *kWidgetSourceLanguages = @"sourceWidget";
static NSString *kWidgetTargetLanguages = @"targetWidget";
static NSString *kWidgetSourceSelected = @"sourceSelectedWidget";
static NSString *kWidgetTargetSelected = @"targetSelectedWidget";
static NSString *kWidgetTranslation = @"translationWidget";

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
        [self removeOldFavouritesFile];
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
        NSNumber *usedFavourites;
        NSArray *widgetSourceLanguages;
        NSArray *widgetTargetLanguages;
        STLanguage *widgetSourceSelected;
        STLanguage *widgetTargetSelected;
        STTranslation *widgetTranslation;
        [transaction getObject:&sourceLanguages metadata:nil forKey:kSourceLanguages inCollection:nil];
        [transaction getObject:&targetLanguages metadata:nil forKey:kTargetLanguages inCollection:nil];
        [transaction getObject:&sourceSelected metadata:nil forKey:kSourceSelected inCollection:nil];
        [transaction getObject:&targetSelected metadata:nil forKey:kTargetSelected inCollection:nil];
        [transaction getObject:&favourites metadata:nil forKey:kFavourites inCollection:nil];
        [transaction getObject:&usedFavourites metadata:nil forKey:kUsedFavourites inCollection:nil];
        [transaction getObject:&widgetSourceLanguages metadata:nil forKey:kWidgetSourceLanguages inCollection:nil];
        [transaction getObject:&widgetTargetLanguages metadata:nil forKey:kWidgetTargetLanguages inCollection:nil];
        [transaction getObject:&widgetSourceSelected metadata:nil forKey:kWidgetSourceSelected inCollection:nil];
        [transaction getObject:&widgetTargetSelected metadata:nil forKey:kWidgetTargetSelected inCollection:nil];
        [transaction getObject:&widgetTranslation metadata:nil forKey:kWidgetTranslation inCollection:nil];
        if (!sourceLanguages || !targetLanguages || !sourceSelected || !targetSelected || !sourceLanguages.count || !targetLanguages.count || !favourites || !usedFavourites || !widgetSourceLanguages || !widgetSourceLanguages.count || !widgetTargetLanguages || !widgetSourceSelected || !widgetTargetSelected || !widgetTranslation) {
            dataAvailable = NO;
        }
    }];
    
    return dataAvailable;
}

- (void)fillInitialData {
    NSArray *sourceLanguages = [self.languagesService randomLanguagesExcluding:@[[self.languagesService autoLanguage]] withCount:languagesCount];
    NSArray *targetLanguages = [self.languagesService randomLanguagesExcluding:@[[self.languagesService autoLanguage]] withCount:languagesCount];
    NSArray *widgetSourceLanguages = [self.languagesService randomLanguagesExcluding:@[[self.languagesService autoLanguage]] withCount:widgetSourceLanguagesCount];
    NSArray *widgetTargetLanguages = [self.languagesService randomLanguagesExcluding:@[[self.languagesService autoLanguage]] withCount:widgetTargetLanguagesCount];
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:sourceLanguages forKey:kSourceLanguages inCollection:nil];
        [transaction setObject:targetLanguages forKey:kTargetLanguages inCollection:nil];
        [transaction setObject:sourceLanguages[0] forKey:kSourceSelected inCollection:nil];
        [transaction setObject:targetLanguages[0] forKey:kTargetSelected inCollection:nil];
        [transaction setObject:[NSArray new] forKey:kFavourites inCollection:nil];
        [transaction setObject:@(NO) forKey:kUsedFavourites inCollection:nil];
        [transaction setObject:widgetSourceLanguages forKey:kWidgetSourceLanguages inCollection:nil];
        [transaction setObject:widgetTargetLanguages forKey:kWidgetTargetLanguages inCollection:nil];
        [transaction setObject:widgetSourceLanguages[0] forKey:kWidgetSourceSelected inCollection:nil];
        [transaction setObject:widgetTargetLanguages[0] forKey:kWidgetTargetSelected inCollection:nil];
        [transaction setObject:[STTranslation emptyTranslation] forKey:kWidgetTranslation inCollection:nil];
    }];
}

- (void)removeOldFavouritesFile {
    NSString *favouritesPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    favouritesPath = [favouritesPath stringByAppendingPathComponent:@"Application Support"];
    favouritesPath = [favouritesPath stringByAppendingPathComponent:@"mark.Swipe-Translate"];
    favouritesPath = [favouritesPath stringByAppendingPathComponent:@"Favourites.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:favouritesPath]) {
        NSError *error;
        if (![fileManager removeItemAtPath:favouritesPath error:&error]) {
            NSLog(@"STDatabaseService failed removing old favourites file: %@", error);
        }
        
    }
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

- (NSNumber *)hasUsedFavouriteBar {
    return [self objectForKey:kUsedFavourites];
}

- (NSArray *)widgetSourceLanguages {
    return [self objectForKey:kWidgetSourceLanguages];
}

- (NSArray *)widgetTargetLanguages {
    return [self objectForKey:kWidgetTargetLanguages];
}

- (STLanguage *)widgetSourceSelectedLanguage {
    return [self objectForKey:kWidgetSourceSelected];
}

- (STLanguage *)widgetTargetSelectedLanguage {
    return [self objectForKey:kWidgetTargetSelected];
}

- (STTranslation *)widgetLastTranslation {
    return [self objectForKey:kWidgetTranslation];
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

- (void)saveHasUsedFavouriteBar:(NSNumber *)used {
    [self setObject:used forKey:kUsedFavourites];
}

- (void)saveWidgetSourceLanguages:(NSArray *)languages {
    [self setObject:languages forKey:kWidgetSourceLanguages];
}

- (void)saveWidgetTargetLanguages:(NSArray *)languages {
    [self setObject:languages forKey:kWidgetTargetLanguages];
}

- (void)saveWidgetSourceSelected:(STLanguage *)language {
    [self setObject:language forKey:kWidgetSourceSelected];
}

- (void)saveWidgetTargetSelected:(STLanguage *)language {
    [self setObject:language forKey:kWidgetTargetSelected];
}

- (void)saveWidgetLastTranslation:(STTranslation *)translation {
    [self setObject:translation forKey:kWidgetTranslation];
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
