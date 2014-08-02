//
//  ShippingAddressViewController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/20/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "ShippingAddressViewController.h"
#import "Address.h"
#import "DatabaseInterface.h"

@interface ShippingAddressViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *header;
@property (weak, nonatomic) IBOutlet UINavigationItem *headertitle;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *province;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *postcode;


- (IBAction)save:(id)sender;
- (IBAction)returnFromShipping:(id)sender;

@end

@implementation ShippingAddressViewController

@synthesize company;
@synthesize companyName,country,province,city,address,postcode;
@synthesize headertitle,header;

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
    header.frame=CGRectMake(0, 0, 768, 73);
    // Do any additional setup after loading the view.
    headertitle.title = company.name;
    Address *shippingAddress = company.shipping_address;
    country.text = shippingAddress.country;
    province.text = shippingAddress.province;
    city.text = shippingAddress.city;
    address.text = shippingAddress.street;
    postcode.text = shippingAddress.postal;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"returnFromEditShippingAddress"]) {
        ShippingAddressViewController *shippingController = segue.destinationViewController;
        shippingController.company = company;
    }
    else if([segue.identifier isEqualToString:@"saveShippingAddress"]) {
        
        DatabaseInterface *database = [DatabaseInterface databaseInterface];
        
        Address *shippingAddress = company.shipping_address;
        if (shippingAddress == nil) {
            [database addCompanyShippingAddress:company];
            company = [database fetchCompanyByName:company.name];
            if (company.shipping_address == nil) {
                NSLog(@"MLGBBBBBBBBB");
            }
        
        }
        shippingAddress = company.shipping_address;
        //NSLog(@"%@", shippingAddress.country);
        shippingAddress.country = country.text;
        NSLog(@"%@???", shippingAddress.country);
        shippingAddress.province = province.text;
        shippingAddress.city = city.text;
        shippingAddress.street = address.text;
        shippingAddress.postal = postcode.text;
        
        
        
        [database editCompany:company shippingAddress:shippingAddress];
        
        ShippingAddressViewController *shippingController = segue.destinationViewController;
        shippingController.company = company;
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

- (IBAction)save:(id)sender {
}

- (IBAction)returnFromShipping:(id)sender {
}
@end
