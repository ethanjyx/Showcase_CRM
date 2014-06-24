//
//  Industry.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/25/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Industry : NSManagedObject

@property (nonatomic, retain) NSString * industry_type;
@property (nonatomic, retain) NSSet *companies;
@end

@interface Industry (CoreDataGeneratedAccessors)

- (void)addCompaniesObject:(Company *)value;
- (void)removeCompaniesObject:(Company *)value;
- (void)addCompanies:(NSSet *)values;
- (void)removeCompanies:(NSSet *)values;

@end
