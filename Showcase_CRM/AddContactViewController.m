//
//  AddContactViewController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/12/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "AddContactViewController.h"
#import "DatabaseInterface.h"
#import "Address.h"
#import "sksViewController.h"

@interface AddContactViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *headertitle;
@property (weak, nonatomic) IBOutlet UITextField *lastname;
@property (weak, nonatomic) IBOutlet UITextField *firstname;
@property (weak, nonatomic) IBOutlet UITextField *title;
@property (weak, nonatomic) IBOutlet UITextField *email_work;
@property (weak, nonatomic) IBOutlet UITextField *email_personal;
@property (weak, nonatomic) IBOutlet UITextField *mobile_phone;
@property (weak, nonatomic) IBOutlet UITextField *phone_work;
@property (weak, nonatomic) IBOutlet UITextField *phone_personal;
@property (weak, nonatomic) IBOutlet UITextField *note;
@property (weak, nonatomic) IBOutlet UITextField *QQ;
@property (weak, nonatomic) IBOutlet UITextField *WeChat;
@property (weak, nonatomic) IBOutlet UITextField *Skype;
@property (weak, nonatomic) IBOutlet UITextField *Weibo;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *province;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *street;
@property (weak, nonatomic) IBOutlet UITextField *postcode;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *activeField;

- (IBAction)save:(id)sender;

@end

@implementation AddContactViewController

@synthesize lastname, firstname, title, email_work, email_personal, phone_work, phone_personal, mobile_phone, QQ, WeChat, Skype, Weibo, province, city, street, country, postcode,note,scrollView,activeField;
@synthesize picker,toolbar;
@synthesize company;
@synthesize header2,headertitle;

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
    header2.frame=CGRectMake(152, 123, 780, 73);
    headertitle.title=company;
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
    country.text= @"中国";
    country.enabled = NO;
    // Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"saveContact"]) {
        DatabaseInterface *database = [DatabaseInterface databaseInterface];
        [database addContactWithLastname:lastname.text firstname:firstname.text title:title.text phoneWork:phone_work.text phoneHome:phone_personal.text phoneMobile:mobile_phone.text emailWork:email_work.text emailPersonal:email_personal.text note:note.text country:country.text province:province.text city:city.text street:street.text postcode:postcode.text companyName:company QQ:QQ.text weChat:WeChat.text skype:Skype.text weibo:Weibo.text];
        sksViewController *localContact = segue.destinationViewController;
        localContact.company = company;
    }
    else if([segue.identifier isEqualToString:@"returnFromContact"] || [segue.identifier isEqualToString:@"returnFromContact_2"]) {
        sksViewController *localContact = segue.destinationViewController;
        localContact.company = company;
    }

}


// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.width;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
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
    if ([lastname.text length]<=0 ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建失败"
                                                        message:@"姓氏不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    [self performSegueWithIdentifier:@"saveContact" sender:nil];
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
