//
//  CoreDataManager.m
//  CoreDataTest
//
//  Created by 马远征 on 13-12-19.
//  Copyright (c) 2013年 马远征. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager()
{
    NSDateFormatter *_formatter;
}
@end

@implementation CoreDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static CoreDataManager *manager = nil;
    dispatch_once(&pred, ^{ manager = [[self alloc] init]; });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (NSDateFormatter*)dateFormatter
{
    if (_formatter == nil)
    {
        _formatter = [[NSDateFormatter alloc] init];
    }
    return _formatter;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Dabase" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"dabase.sqlite"];
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    NSLog(@"------——perSisent--%@",_persistentStoreCoordinator.persistentStores);
    
    return _persistentStoreCoordinator;
}

- (void)changePersistentStoreCoordinator:(NSString*)dabaseName
{
    if (_persistentStoreCoordinator == nil)
    {
        return;
    }
    
    NSPersistentStore *persistentStore = [_persistentStoreCoordinator.persistentStores objectAtIndex:0];
    
    NSURL *oldUrl = [_persistentStoreCoordinator URLForPersistentStore:persistentStore];
    
    NSString *database = [NSString stringWithFormat:@"%@.sqlite",dabaseName];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:database];
    
    if (![oldUrl.absoluteString isEqualToString:storeURL.absoluteString])
    {
        [_persistentStoreCoordinator removePersistentStore:persistentStore error:nil];
        
        NSError *error = nil;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:options error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }

//        [_persistentStoreCoordinator setURL:storeURL forPersistentStore:persistentStore];
//        [self.managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
        NSLog(@"-----New-——perSisent--%@",self.managedObjectContext.persistentStoreCoordinator.persistentStores);
        
    }
}

#pragma mark -
#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    NSURL *pathURl =
   [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return pathURl;
}

- (BOOL)insertMsg:(NSString*)name age:(NSInteger)age gender:(NSInteger)gender
{
    MsgEntity *entity = (MsgEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"MsgEntity" inManagedObjectContext:[self managedObjectContext]];
    entity.name = name;
    entity.age = [NSNumber numberWithLong:age];
    entity.gender = [NSNumber numberWithLong:gender];
    NSError *error;
    if (![[self managedObjectContext] save:&error])
    {
        return NO;
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
    return YES;
}

- (NSArray*)searchAllRecordOfFace
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MsgEntity"
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *queryError;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&queryError];
    return fetchedObjects;
}

@end
