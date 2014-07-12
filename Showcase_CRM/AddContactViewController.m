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

@interface AddContactViewController ()

@property (weak, nonatomic) IBOutlet UITextField *lastname;
@property (weak, nonatomic) IBOutlet UITextField *firstname;
@property (weak, nonatomic) IBOutlet UITextField *title;
@property (weak, nonatomic) IBOutlet UITextField *email_work;
@property (weak, nonatomic) IBOutlet UITextField *email_personal;
@property (weak, nonatomic) IBOutlet UITextField *phone_work;
@property (weak, nonatomic) IBOutlet UITextField *phone_personal;
@property (weak, nonatomic) IBOutlet UITextField *mobile_phone;
@property (weak, nonatomic) IBOutlet UITextField *QQ;
@property (weak, nonatomic) IBOutlet UITextField *WeChat;
@property (weak, nonatomic) IBOutlet UITextField *Skype;
@property (weak, nonatomic) IBOutlet UITextField *Weibo;
@property (weak, nonatomic) IBOutlet UITextField *province;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *postcode;
@property (weak, nonatomic) IBOutlet UITextField *note;
@property (weak, nonatomic) IBOutlet UIButton *save;


@end

@implementation AddContactViewController

@synthesize lastname, firstname, title, email_work, email_personal, phone_work, phone_personal, mobile_phone, QQ, WeChat, Skype, Weibo, province, city, address, country, postcode,note;

@synthesize company;

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

- (IBAction)save:(id)sender {
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    [database addContactWithLastname:lastname.text firstname:firstname.text title:title.text phoneWork:phone_work.text phoneHome:phone_personal.text phoneMobile:mobile_phone.text emailWork:email_work.text emailPersonal:email_personal.text note:note.text country:country.text province:province.text city:city.text street:address.text postcode:postcode.text companyName:company QQ:QQ.text weChat:WeChat.text skype:Skype.text weibo:Weibo.text];
}
@end






