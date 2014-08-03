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
@synthesize toolbar,picker;
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

- (IBAction)save:(id)sender {
}

- (IBAction)returnFromBilling:(id)sender {

}
- (IBAction)finish:(id)sender {
    [province endEditing:YES];
    [country endEditing:YES];
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
