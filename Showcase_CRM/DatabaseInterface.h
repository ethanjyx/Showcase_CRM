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

@interface DatabaseInterface : NSObject


+ (id)databaseInterface;


- (void)addCompanyWithName:(NSString*)name phone:(NSString*) phone website:(NSString*)website industry:(NSString*)industry;

- (NSArray*)getAllCompanies;

- (void)addContactWithLastname:(NSString*)lastname firstname:(NSString*)firstname title:(NSString*)title phoneWork:(NSString*)phoneWork phoneHome:(NSString*)phoneHome phoneMobile:(NSString*)phoneMobile emailWork:(NSString*)emailWork emailPersonal:(NSString*)emailPersonal note:(NSString*)note country:(NSString*)country province:(NSString*)province city:(NSString*)city street:(NSString*)street postcode:(NSString*)postcode companyName:(NSString*)companyName QQ:(NSString*)QQ weChat:(NSString*)weChat skype:(NSString*)Skype weibo:(NSString*) Weibo;

- (NSArray*)getAllContacts;

- (Company*)fetchCompanyByName:(NSString*)companyName;

- (Contact*)fetchContactByID:(NSNumber*)contactID;

- (void)addCompany:(NSString*)companyName billingAddress:(Address*)billingAddress shippingAddress:(Address*)shippingAddress;

- (void)editOldCompany:(Company*) oldCompany toNewCompany:(Company*) newCompany;

- (void)editContact:(Contact*) contact;

- (void)deleteContact:(Contact*) contact;

@end


