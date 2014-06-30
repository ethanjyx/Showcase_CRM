//
//  Project.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/25/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * deadline;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * possibility;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSManagedObject *status;
@property (nonatomic, retain) NSManagedObject *sale;
@property (nonatomic, retain) NSSet *contacts;
@property (nonatomic, retain) NSSet *events;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addContactsObject:(NSManagedObject *)value;
- (void)removeContactsObject:(NSManagedObject *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addEventsObject:(NSManagedObject *)value;
- (void)removeEventsObject:(NSManagedObject *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
