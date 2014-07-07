//
//  DatabaseInterface.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/30/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseInterface : NSObject


+ (id)databaseInterface;


- (void)addCompanyWithName:(NSString*)name phone:(NSString*) phone website:(NSString*)website industry:(NSString*)industry;

- (NSArray*)getAllCompanies;

- (void)addContactWithLastname:(NSString*)lastname firstname:(NSString*)firstname title:(NSString*)title phoneWork:(NSString*)phoneWork phoneHome:(NSString*)phoneHome phoneMobile:(NSString*)phoneMobile emailWork:(NSString*)emailWork emailPersonal:(NSString*)emailPersonal note:(NSString*)note address:(NSString*)address;

- (NSArray*)getAllContacts;

@end


