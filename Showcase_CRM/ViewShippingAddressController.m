//
//  ViewShippingAddressController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/20/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "ViewShippingAddressController.h"
#import "sksViewController.h"
#import "Address.h"
#import "ShippingAddressViewController.h"

@interface ViewShippingAddressController ()
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *country;
@property (weak, nonatomic) IBOutlet UILabel *province;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *postcode;
- (IBAction)edit:(id)sender;

@end

@implementation ViewShippingAddressController
@synthesize company;
@synthesize companyName,country,province,city,address,postcode;

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
    // Do any additional setup after loading the view.
    
    companyName.text = company.name;
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
    if([segue.identifier isEqualToString:@"returnFromViewShipping"]) {
        sksViewController *localContact = segue.destinationViewController;
        localContact.company = company.name;
    }
    else if([segue.identifier isEqualToString:@"editShippingAddress"]) {
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

- (IBAction)edit:(id)sender {
}
@end
