//
//  DetailContact2ViewController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/22/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "DetailContact2ViewController.h"
#import "Address.h"
#import "sksViewController.h"
#import "Company.h"
#import "DatabaseInterface.h"

@interface DetailContact2ViewController ()

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


@property (weak, nonatomic) IBOutlet UIButton *save_button;
@property (weak, nonatomic) IBOutlet UIButton *edit_button;
@property (weak, nonatomic) IBOutlet UIButton *cancel_button;
@property (weak, nonatomic) IBOutlet UIButton *delete_button;
@property (weak, nonatomic) IBOutlet UIButton *returnCompany_button;


- (IBAction)returnCompany:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)delete:(id)sender;



@end

@implementation DetailContact2ViewController

@synthesize contact,company;

@synthesize lastname,firstname,title,email_personal,email_work,mobile_phone,phone_personal,phone_work,note,QQ,WeChat,Weibo,Skype,country,province,city,street,postcode,edit_button,save_button,delete_button,cancel_button,returnCompany_button;

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
    [self setAllTextField];
    [self disableAllTextField];
    save_button.hidden = YES;
    delete_button.hidden = YES;
    cancel_button.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAllTextField
{
    lastname.text = contact.lastname;
    firstname.text = contact.firstname;
    title.text = contact.title;
    email_work.text = contact.email_work;
    email_personal.text = contact.email_personal;
    mobile_phone.text = contact.phone_mobile;
    phone_work.text = contact.phone_work;
    phone_personal.text = contact.phone_home;
    note.text = contact.note;
    QQ.text = contact.qq;
    WeChat.text = contact.wechat;
    Skype.text = contact.skype;
    Weibo.text = contact.weibo;
    Address *address = contact.address;
    country.text = address.country;
    province.text = address.province;
    city.text = address.city;
    street.text = address.street;
    postcode.text = address.postal;
}


- (void)enableAllTextField
{
    lastname.enabled = YES;
    firstname.enabled = YES;
    title.enabled = YES;
    email_work.enabled = YES;
    email_personal.enabled = YES;
    mobile_phone.enabled = YES;
    phone_work.enabled = YES;
    phone_personal.enabled = YES;
    note.enabled = YES;
    QQ.enabled = YES;
    WeChat.enabled = YES;
    Skype.enabled = YES;
    Weibo.enabled = YES;
    country.enabled = YES;
    province.enabled = YES;
    city.enabled = YES;
    street.enabled = YES;
    postcode.enabled = YES;
}

- (void)disableAllTextField
{
    lastname.enabled = NO;
    firstname.enabled = NO;
    title.enabled = NO;
    email_work.enabled = NO;
    email_personal.enabled = NO;
    mobile_phone.enabled = NO;
    phone_work.enabled = NO;
    phone_personal.enabled = NO;
    note.enabled = NO;
    QQ.enabled = NO;
    WeChat.enabled = NO;
    Skype.enabled = NO;
    Weibo.enabled = NO;
    country.enabled = NO;
    province.enabled = NO;
    city.enabled = NO;
    street.enabled = NO;
    postcode.enabled = NO;
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

- (IBAction)returnCompany:(id)sender {
}

- (IBAction)save:(id)sender {
    contact.lastname = lastname.text;
    contact.firstname = firstname.text;
    contact.title = title.text;
    contact.email_work = email_work.text;
    contact.email_personal = email_personal.text;
    contact.phone_mobile = mobile_phone.text;
    contact.phone_work = phone_work.text;
    contact.phone_home = phone_personal.text;
    contact.note = note.text;
    contact.qq = QQ.text;
    contact.wechat = WeChat.text;
    contact.skype = Skype.text;
    contact.weibo = Weibo.text;
    contact.address.country = country.text;
    contact.address.province = province.text;
    contact.address.city = city.text;
    contact.address.street = street.text;
    contact.address.postal = postcode.text;
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    [database editContact:contact];
    [self disableAllTextField];
    edit_button.hidden = NO;
    returnCompany_button.hidden = NO;
    save_button.hidden = YES;
    delete_button.hidden = YES;
    cancel_button.hidden = YES;
}

- (IBAction)edit:(id)sender {
    [self enableAllTextField];
    edit_button.hidden = YES;
    returnCompany_button.hidden = YES;
    save_button.hidden = NO;
    cancel_button.hidden = NO;
    delete_button.hidden = NO;
}

- (IBAction)cancel:(id)sender {
    [self disableAllTextField];
    [self setAllTextField];
    edit_button.hidden = NO;
    returnCompany_button.hidden = NO;
    save_button.hidden = YES;
    delete_button.hidden = YES;
    cancel_button.hidden = YES;
}

- (IBAction)delete:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"returnToCompany"]) {
        sksViewController *companyViewController = segue.destinationViewController;
        companyViewController.company = company.name;
    }
    else if ([segue.identifier isEqualToString:@"deleteContact"]) {
        DatabaseInterface *database = [DatabaseInterface databaseInterface];
        [database deleteContact:contact];
        sksViewController *companyViewController = segue.destinationViewController;
        companyViewController.company = company.name;
    }
}

@end
