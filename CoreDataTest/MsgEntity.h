//
//  MsgEntity.h
//  CoreDataTest
//
//  Created by 马远征 on 14-6-17.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MsgEntity : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * gender;

@end
