//
//  Event.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 8/4/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company, Contact, Project;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * attachment_url;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Company *company;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) Project *project;

@end
