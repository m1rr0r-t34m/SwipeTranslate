//
//  STDatabaseManager.m
//  Swipe Translate
//
//  Created by Mark Vasiv on 08/01/2018.
//  Copyright © 2018 Mark Vasiv. All rights reserved.
//

#import "STDatabaseManager.h"
#import <YapDatabase.h>
#import "STLanguage.h"
#import "STLanguagesManager.h"

static NSString *databaseName = @"yap";
static STDatabaseManager *instance;

static NSString *kSourceLanguages = @"source";
static NSString *kTargetLanguages = @"target";
static NSString *kSourceSelected = @"sourceSelected";
static NSString *kTargetSelected = @"targetSelected";
static NSUInteger defaultLanguagesCount = 10;

@interface STDatabaseManager()
@property (strong, nonatomic) YapDatabase *database;
@property (strong, nonatomic) YapDatabaseConnection *connection;
@property (strong, nonatomic) NSMutableDictionary *persistentCache;
@end

//TODO: we could make connections async, but why?
//TODO: we could also handle DB errors later
@implementation STDatabaseManager
#pragma mark - Initialization
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [STDatabaseManager new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
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
        STLanguage *sourceSelected;
        STLanguage *targetSelected;
        [transaction getObject:&sourceLanguages metadata:nil forKey:kSourceLanguages inCollection:nil];
        [transaction getObject:&targetLanguages metadata:nil forKey:kTargetLanguages inCollection:nil];
        [transaction getObject:&sourceSelected metadata:nil forKey:kSourceSelected inCollection:nil];
        [transaction getObject:&targetSelected metadata:nil forKey:kTargetSelected inCollection:nil];
        
        if (!sourceLanguages || !targetLanguages || !sourceSelected || !targetSelected || sourceLanguages.count < defaultLanguagesCount || targetLanguages.count < defaultLanguagesCount) {
            dataAvailable = NO;
        }
    }];
    
    return dataAvailable;
}

- (void)fillInitialData {
    NSArray *sourceLanguages = [STLanguagesManager randomLanguagesExcluding:nil withCount:defaultLanguagesCount];
    NSArray *targetLanguages = [STLanguagesManager randomLanguagesExcluding:nil withCount:defaultLanguagesCount];
    [self.connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:sourceLanguages forKey:kSourceLanguages inCollection:nil];
        [transaction setObject:targetLanguages forKey:kTargetLanguages inCollection:nil];
        [transaction setObject:sourceLanguages[0] forKey:kSourceSelected inCollection:nil];
        [transaction setObject:targetLanguages[0] forKey:kTargetSelected inCollection:nil];
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

#pragma mark - Insert
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
