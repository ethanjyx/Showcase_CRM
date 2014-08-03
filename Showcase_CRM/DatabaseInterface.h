//
//  DatabaseInterface.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/30/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"
#import "Address.h"
#import "Contact.h"
#import "Event.h"
#import "Project.h"

@interface DatabaseInterface : NSObject


+ (id)databaseInterface;


- (void)addCompanyWithName:(NSString*)name phone:(NSString*) phone website:(NSString*)website industry:(NSString*)industry;

- (NSArray*)getAllCompanies;

- (void)addContactWithLastname:(NSString*)lastname firstname:(NSString*)firstname title:(NSString*)title phoneWork:(NSString*)phoneWork phoneHome:(NSString*)phoneHome phoneMobile:(NSString*)phoneMobile emailWork:(NSString*)emailWork emailPersonal:(NSString*)emailPersonal note:(NSString*)note country:(NSString*)country province:(NSString*)province city:(NSString*)city street:(NSString*)street postcode:(NSString*)postcode companyName:(NSString*)companyName QQ:(NSString*)QQ weChat:(NSString*)weChat skype:(NSString*)Skype weibo:(NSString*) Weibo;

- (void)addProjectWithName:(NSString*)name possibility:(NSNumber*)possibility amount:(NSNumber*)amount memo:(NSString*) memo deadline:(NSDate*)deadline progress:(NSString*)progress companyName:(NSString*) companyName;

- (void)addEventWithName:(NSString*)name date:(NSDate*)date locations:(NSString*)location memo:(NSString*) memo companyName:(NSString*)companyName contact:(Contact*)contact project:(Project*)project;

- (NSArray*)getAllContacts;

- (Company*)fetchCompanyByName:(NSString*)companyName;

- (Contact*)fetchContactByID:(NSNumber*)contactID;

- (void)addCompany:(NSString*)companyName billingAddress:(Address*)billingAddress shippingAddress:(Address*)shippingAddress;

- (void)editOldCompany:(Company*) oldCompany toNewCompany:(Company*) newCompany;

- (void)editContact:(Contact*) contact;

- (void)deleteContact:(Contact*) contact;

- (void)editProject:(Project*) project;

- (void)deleteProject:(Project*) project;

- (void)editEvent:(Event*) event;

- (void)deleteEvent:(Event*) event;

- (void)addCompanyBillingAddress:(Company*) company;

- (void)addCompanyShippingAddress:(Company*) company;


- (void)editCompany:(Company*) company billingAddress:(Address *) billingAddress;

- (void)editCompany:(Company*) company shippingAddress:(Address *) shippingAddress;


@end


