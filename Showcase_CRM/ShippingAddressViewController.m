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
@synthesize toolbar,picker;
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
    
    provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities.plist" ofType:nil]];
    cities = [[provinces objectAtIndex:0] objectForKey:@"Cities"];
    province.inputView=picker;
    province.inputAccessoryView=toolbar;
    city.inputAccessoryView=toolbar;
    city.inputView=picker;
    province.delegate=self;
    city.delegate=self;
    picker.delegate=self;
    picker.dataSource=self;
    country.enabled = NO;
    country.text = @"中国";

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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[provinces objectAtIndex:row] objectForKey:@"State"];
            break;
        case 1:
            return [[cities objectAtIndex:row] objectForKey:@"city"];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            cities = [[provinces objectAtIndex:row] objectForKey:@"Cities"];
            [self.picker selectRow:0 inComponent:1 animated:NO];
            [self.picker reloadComponent:1];
            
            self.province.text = [[provinces objectAtIndex:row] objectForKey:@"State"];
            self.city.text = [[cities objectAtIndex:0] objectForKey:@"city"];
            break;
        case 1:
            self.city.text = [[cities objectAtIndex:row] objectForKey:@"city"];
            if ([province.text length]<=0){
                province.text=@"直辖市";
            }
            break;
        default:
            break;
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
- (IBAction)finish:(id)sender {
    [province endEditing:YES];
    [city endEditing:YES];
    picker.hidden=YES;
    toolbar.hidden=YES;
}

- (IBAction)editprovince:(id)sender {
    toolbar.hidden=NO;
    picker.hidden=NO;
}

- (IBAction)editcity:(id)sender {
    toolbar.hidden=NO;
    picker.hidden=NO;
}
@end
