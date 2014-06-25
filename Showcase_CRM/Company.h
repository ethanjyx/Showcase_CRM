//
//  Company.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/25/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSManagedObject *industry;
@property (nonatomic, retain) NSManagedObject *shipping_address;
@property (nonatomic, retain) NSManagedObject *billing_address;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *contacts;
@property (nonatomic, retain) NSSet *sales;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addEventsObject:(NSManagedObject *)value;
- (void)removeEventsObject:(NSManagedObject *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addContactsObject:(NSManagedObject *)value;
- (void)removeContactsObject:(NSManagedObject *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addSalesObject:(NSManagedObject *)value;
- (void)removeSalesObject:(NSManagedObject *)value;
- (void)addSales:(NSSet *)values;
- (void)removeSales:(NSSet *)values;

@end
