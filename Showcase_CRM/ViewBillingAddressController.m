//
//  ViewBillingAddressController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/20/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "ViewBillingAddressController.h"
#import "sksViewController.h"
#import "Address.h"

@interface ViewBillingAddressController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *header7;
@property (weak, nonatomic) IBOutlet UINavigationItem *headertitle2;
@property (weak, nonatomic) IBOutlet UILabel *companyName;

@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *province;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *postcode;

- (IBAction)edit:(id)sender;

@end

@implementation ViewBillingAddressController
@synthesize company;
@synthesize companyName,country,province,city,address,postcode;
@synthesize header7,headertitle2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    header7.frame=CGRectMake(0, 0, 768, 73);
    // Do any additional setup after loading the view.
    
    country.enabled = NO;
    province.enabled = NO;
    city.enabled = NO;
    address.enabled = NO;
    postcode.enabled = NO;
    
    
    headertitle2.title = company.name;
    Address *billingAddress = company.billing_address;
    country.text = billingAddress.country;
    province.text = billingAddress.province;
    city.text = billingAddress.city;
    address.text = billingAddress.street;
    postcode.text = billingAddress.postal;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"returnFromViewBilling"]) {
        sksViewController *localContact = segue.destinationViewController;
        localContact.company = company.name;
    }
    else if([segue.identifier isEqualToString:@"editBillingAddress"]) {
        ViewBillingAddressController *billingController = segue.destinationViewController;
        billingController.company = company;
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)edit:(id)sender {
}
@end
