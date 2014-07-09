//
//  DatabaseInterface.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/30/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "DatabaseInterface.h"
#import "AppDelegate.h"
#import "Company.h"
#import "Industry.h"
#import "Contact.h"
#import "Address.h"

@interface DatabaseInterface()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end


@implementation DatabaseInterface

@synthesize managedObjectContext;

+ (id)databaseInterface
{
    static DatabaseInterface *databaseInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseInterface = [[self alloc] init];
    });
    return databaseInterface;
}

- (id)init
{
    if (self = [super init]) {
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    return self;
}


- (void)addCompanyWithName:(NSString*)name phone:(NSString*)phone website:(NSString*)website industry:(NSString*)industry {
    Company * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Company"
                                                       inManagedObjectContext:self.managedObjectContext];
    newEntry.name = name;
    newEntry.phone = phone;
    newEntry.website = website;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Industry"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    //NSString *predicateString = [NSString stringWithFormat: @"industry_type == %@", industry];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"industry_type == %@", industry];
    [fetchRequest setPredicate:predicate];
    NSError* error;
    NSArray *fetchedIndustries = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedIndustries count]) {
        newEntry.industry = [fetchedIndustries objectAtIndex:0];
        //NSLog(@"existing industry");
    }
    else {
        Industry * industry1 = [NSEntityDescription insertNewObjectForEntityForName:@"Industry"
                                                             inManagedObjectContext:self.managedObjectContext];
        industry1.industry_type = industry;
        newEntry.industry = industry1;
    }
    //NSError* error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}



- (NSArray*)getAllCompanies
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *companyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[companyDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedCompanies = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedCompanies;
}


- (void)addContactWithLastname:(NSString*)lastname firstname:(NSString*)firstname title:(NSString*)title phoneWork:(NSString*)phoneWork phoneHome:(NSString*)phoneHome phoneMobile:(NSString*)phoneMobile emailWork:(NSString*)emailWork emailPersonal:(NSString*)emailPersonal note:(NSString*)note address:(Address*)address
{
    Contact *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Contact"
                                                      inManagedObjectContext:self.managedObjectContext];
    newEntry.lastname = lastname;
    newEntry.firstname = firstname;
    newEntry.title = title;
    newEntry.phone_work = phoneWork;
    newEntry.phone_home = phoneHome;
    newEntry.phone_mobile = phoneMobile;
    newEntry.email_work = emailWork;
    newEntry.email_personal = emailPersonal;
    newEntry.note = note;
    
    
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Address"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"street == %@ AND city == %@ AND province == %@ AND country == %@", address.street, address.city, address.province, address.country];
    [fetchRequest setPredicate:predicate];
    NSError* error;
    NSArray *fetchedIndustries = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedIndustries count]) {
        newEntry.address = [fetchedIndustries objectAtIndex:0];
        //NSLog(@"existing industry");
    }
    else {
        Address * address1 = [NSEntityDescription insertNewObjectForEntityForName:@"Address"
                                                           inManagedObjectContext:self.managedObjectContext];
        address1 = address;
        newEntry.address = address1; // TODO: check address relation with contact
    }
    //NSError* error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}



- (NSArray*)getAllContacts
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *contactDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastname" ascending:YES];
    NSArray *sortDescriptors = @[contactDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedContacts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedContacts;
}

- (Company*)fetchCompanyByName:(NSString*)companyName
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", companyName];
    [fetchRequest setPredicate:predicate];
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedContacts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return [fetchedContacts lastObject];
}
























@end
