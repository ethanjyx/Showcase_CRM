//
//  Address.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/25/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company, Contact;

@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * postal;
@property (nonatomic, retain) Company *company_billing;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) Company *company_shipping;

@end
