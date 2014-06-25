//
//  Sale.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/25/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company, Project;

@interface Sale : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSSet *contacts;
@property (nonatomic, retain) NSSet *companies;
@property (nonatomic, retain) NSSet *projects;
@end

@interface Sale (CoreDataGeneratedAccessors)

- (void)addContactsObject:(NSManagedObject *)value;
- (void)removeContactsObject:(NSManagedObject *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addCompaniesObject:(Company *)value;
- (void)removeCompaniesObject:(Company *)value;
- (void)addCompanies:(NSSet *)values;
- (void)removeCompanies:(NSSet *)values;

- (void)addProjectsObject:(Project *)value;
- (void)removeProjectsObject:(Project *)value;
- (void)addProjects:(NSSet *)values;
- (void)removeProjects:(NSSet *)values;

@end
