//
//  BillAddressViewController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/20/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "BillAddressViewController.h"
#import "ViewBillingAddressController.h"
#import "Address.h"
#import "DatabaseInterface.h"

@interface BillAddressViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *header6;
@property (weak, nonatomic) IBOutlet UINavigationItem *headertitle1;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *province;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *postcode;

- (IBAction)save:(id)sender;
- (IBAction)returnFromBilling:(id)sender;



@end

@implementation BillAddressViewController

@synthesize company;
@synthesize companyName,country,province,city,address,postcode;
@synthesize headertitle1,header6;
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
    headertitle1.title=company.name;
    header6.frame=CGRectMake(0, 0, 768, 73);
    // Do any additional setup after loading the view.
   
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"returnFromEditBillingAddress"]) {
        BillAddressViewController *billingController = segue.destinationViewController;
        billingController.company = company;
    }
    else if([segue.identifier isEqualToString:@"saveBillingAddress"]) {

        DatabaseInterface *database = [DatabaseInterface databaseInterface];
        
        Address *billingAddress = company.billing_address;
        if (billingAddress == nil) {
            [database addCompanyBillingAddress:company];
            company = [database fetchCompanyByName:company.name];
        }
        billingAddress = company.billing_address;
        billingAddress.country = country.text;
        billingAddress.province = province.text;
        billingAddress.city = city.text;
        billingAddress.street = address.text;
        billingAddress.postal = postcode.text;
        
        
        
        [database editCompany:company billingAddress:billingAddress];
        
        BillAddressViewController *billingController = segue.destinationViewController;
        billingController.company = company;
    }
}


- (IBAction)save:(id)sender {
}

- (IBAction)returnFromBilling:(id)sender {
}
@end
