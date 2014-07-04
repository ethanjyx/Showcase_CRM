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




@end


