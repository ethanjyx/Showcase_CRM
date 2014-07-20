//
//  Contact.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/20/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Company, Event, Project, Sale;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * email_personal;
@property (nonatomic, retain) NSString * email_work;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * phone_home;
@property (nonatomic, retain) NSString * phone_mobile;
@property (nonatomic, retain) NSString * phone_work;
@property (nonatomic, retain) NSString * qq;
@property (nonatomic, retain) NSString * skype;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * wechat;
@property (nonatomic, retain) NSString * weibo;
@property (nonatomic, retain) NSNumber * sign_up_times;
@property (nonatomic, retain) Address *address;
@property (nonatomic, retain) Company *company;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSSet *projects;
@property (nonatomic, retain) NSSet *sales;
@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addProjectsObject:(Project *)value;
- (void)removeProjectsObject:(Project *)value;
- (void)addProjects:(NSSet *)values;
- (void)removeProjects:(NSSet *)values;

- (void)addSalesObject:(Sale *)value;
- (void)removeSalesObject:(Sale *)value;
- (void)addSales:(NSSet *)values;
- (void)removeSales:(NSSet *)values;

@end
