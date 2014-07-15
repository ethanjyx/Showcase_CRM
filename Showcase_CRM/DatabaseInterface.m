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
#import "TKContact.h"

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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"industry_type == %@", industry];
    [fetchRequest setPredicate:predicate];
    NSError* error;
    NSArray *fetchedIndustries = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedIndustries count]) {
        // this industry already exists
        newEntry.industry = [fetchedIndustries objectAtIndex:0];
    }
    else {
        // create a new industry if the industry does not exist
        Industry * industry1 = [NSEntityDescription insertNewObjectForEntityForName:@"Industry"
                                                             inManagedObjectContext:self.managedObjectContext];
        industry1.industry_type = industry;
        newEntry.industry = industry1;
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
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


- (void)addContactWithLastname:(NSString*)lastname firstname:(NSString*)firstname title:(NSString*)title phoneWork:(NSString*)phoneWork phoneHome:(NSString*)phoneHome phoneMobile:(NSString*)phoneMobile emailWork:(NSString*)emailWork emailPersonal:(NSString*)emailPersonal note:(NSString*)note country:(NSString*)country province:(NSString*)province city:(NSString*)city street:(NSString*)street postcode:(NSString*)postcode companyName:(NSString*)companyName QQ:(NSString*)QQ weChat:(NSString*)weChat skype:(NSString*)Skype weibo:(NSString*) Weibo
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
    newEntry.qq = QQ;
    newEntry.wechat = weChat;
    newEntry.skype = Skype;
    newEntry.weibo = Weibo;
    
    /*
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Address"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(street == %@) AND (city == %@) AND (province == %@) AND (country == %@)", address.street, address.city, address.province, address.country];
    [fetchRequest setPredicate:predicate];
    NSError* error;
    NSArray *fetchedAddresses = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
     
    if ([fetchedAddresses count]) {
        newEntry.address = [fetchedAddresses lastObject];
    }
    else {
        Address * address1 = [NSEntityDescription insertNewObjectForEntityForName:@"Address"
                                                           inManagedObjectContext:self.managedObjectContext];
        address1 = address;
        newEntry.address = address1; // TODO: check address relation with contact
    }
    */
    
    Address * address = [NSEntityDescription insertNewObjectForEntityForName:@"Address"
                                                       inManagedObjectContext:self.managedObjectContext];
    address.country = country;
    address.province = province;
    address.city = city;
    address.street = street;
    address.postal = postcode;
    
    newEntry.address = address; // TODO: check address relation with contact

    
    newEntry.company = [self fetchCompanyByName:companyName];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity2];
    
    // Specify that the request should return dictionaries.
    [request setResultType:NSDictionaryResultType];
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"id"];
    
    // Create an expression to represent the minimum value at the key path 'creationDate'
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    // Create an expression description using the minExpression and returning a date.
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    // The name is the key that will be used in the dictionary for the return value.
    [expressionDescription setName:@"maxId"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    NSError* error;
    NSArray *objects = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (objects == nil) {
        newEntry.id = [[NSNumber alloc] initWithInt:1];
    }
    else {
        if ([objects count] > 0) {
            newEntry.id = @([[[objects objectAtIndex:0] valueForKey:@"maxId"] intValue] + 1);
        }
        else {
            newEntry.id = [[NSNumber alloc] initWithInt:1];
        }
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", companyName];
    [fetchRequest setPredicate:predicate];
    
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return [fetchedObjects lastObject];
}

- (Contact*)fetchContactByName:(NSString*)contactName
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", contactName];
    [fetchRequest setPredicate:predicate];
    
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return [fetchedObjects lastObject];
}




- (void)addCompany:(NSString*)companyName billingAddress:(Address*)billingAddress shippingAddress:(Address*)shippingAddress
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", companyName];
    [fetchRequest setPredicate:predicate];
    
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    Company *fetchedObject = [fetchedObjects lastObject];
    
    
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Address"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest2 setEntity:entity2];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(street == %@) AND (city == %@) AND (province == %@) AND (country == %@)", billingAddress.street, billingAddress.city, billingAddress.province, billingAddress.country];
    [fetchRequest2 setPredicate:predicate2];
    NSArray *fetchedAddress1 = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedAddress1 count]) {
        fetchedObject.billing_address = [fetchedAddress1 lastObject];
    }
    else {
        Address * newAddress = [NSEntityDescription insertNewObjectForEntityForName:@"Address"
                                                           inManagedObjectContext:self.managedObjectContext];
        newAddress = billingAddress;
        fetchedObject.billing_address = newAddress;
    }

    NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity3 = [NSEntityDescription entityForName:@"Address"
                                               inManagedObjectContext:self.managedObjectContext];
    [fetchRequest3 setEntity:entity3];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"(street == %@) AND (city == %@) AND (province == %@) AND (country == %@)", shippingAddress.street, shippingAddress.city, shippingAddress.province, shippingAddress.country];
    [fetchRequest3 setPredicate:predicate3];
    NSArray *fetchedAddress2 = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedAddress2 count]) {
        fetchedObject.shipping_address = [fetchedAddress2 lastObject];
    }
    else {
        Address * newAddress = [NSEntityDescription insertNewObjectForEntityForName:@"Address"
                                                             inManagedObjectContext:self.managedObjectContext];
        newAddress = billingAddress;
        fetchedObject.shipping_address = newAddress;
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
}

- (void)editOldCompany:(Company*) oldCompany toNewCompany:(Company*) newCompany
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", oldCompany.name];
    [fetchRequest setPredicate:predicate];
    
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    Company *editCompany = [fetchedObjects lastObject];
    editCompany = newCompany;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
}


- (void)editContact:(Contact*) contact
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", contact.id];
    [fetchRequest setPredicate:predicate];
    
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    Contact *editContact = [fetchedObjects lastObject];
    editContact = contact;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
}

- (void)deleteContact:(Contact*) contact
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", contact.id];
    [fetchRequest setPredicate:predicate];
    
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    Contact *fetchedContact = [fetchedObjects lastObject];
    [self.managedObjectContext deleteObject:fetchedContact];
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
}

@end
