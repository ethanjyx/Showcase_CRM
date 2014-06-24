//
//  Project.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/25/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Event, Sales, Status;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * deadline;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * possibility;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) Status *status;
@property (nonatomic, retain) NSSet *contacts;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Sales *sales;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

@end
