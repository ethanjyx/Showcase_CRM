//
//  Company.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/28/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Contact, Event, Industry, Project, Sale;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) Address *billing_address;
@property (nonatomic, retain) NSSet *contacts;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) Industry *industry;
@property (nonatomic, retain) NSSet *sales;
@property (nonatomic, retain) Address *shipping_address;
@property (nonatomic, retain) NSSet *projects;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addSalesObject:(Sale *)value;
- (void)removeSalesObject:(Sale *)value;
- (void)addSales:(NSSet *)values;
- (void)removeSales:(NSSet *)values;

- (void)addProjectsObject:(Project *)value;
- (void)removeProjectsObject:(Project *)value;
- (void)addProjects:(NSSet *)values;
- (void)removeProjects:(NSSet *)values;

@end
