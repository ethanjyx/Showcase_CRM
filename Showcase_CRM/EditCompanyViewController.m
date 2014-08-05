//
//  EditCompanyViewController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 8/5/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "EditCompanyViewController.h"
#import "Company.h"
#import "Industry.h"
#import "sksViewController.h"
#import "DatabaseInterface.h"

@interface EditCompanyViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *header;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *website;
@property (weak, nonatomic) IBOutlet UITextField *industry;



- (IBAction)returnToCompany:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)deleteCompany:(id)sender;


@end

@implementation EditCompanyViewController

@synthesize header,name,phone,website,industry,company;

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
    header.frame=CGRectMake(0, 0, 768, 73);
    name.text = company.name;
    phone.text = company.phone;
    website.text = company.website;
    Industry *localIndustry = company.industry;
    industry.text = localIndustry.industry_type;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"returnFromEditCompany"]) {
        sksViewController *localController = segue.destinationViewController;
        localController.company = company.name;
    }
    else if([segue.identifier isEqualToString:@"saveEditCompany"]) {
        


        sksViewController *localController = segue.destinationViewController;
        localController.company = company.name;
    }
    else if ([segue.identifier isEqualToString:@"deleteCompany"]) {
    
    
    }
}


- (IBAction)returnToCompany:(id)sender {
    [self performSegueWithIdentifier:@"returnFromEditCompany" sender:nil];
}

- (IBAction)save:(id)sender {
    if ([name.text length]<=0 ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建失败"
                                                        message:@"公司名不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [name endEditing:YES];
        name.text = company.name;
        [alert show];
        return;
    }
    
    company.name = name.text;
    company.phone = phone.text;
    company.website = website.text;
    company.industry.industry_type = industry.text;
    
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    [database editCompanyInfo:company];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:nil];

    [self performSegueWithIdentifier:@"saveEditCompany" sender:nil];
}

- (IBAction)deleteCompany:(id)sender {
    
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    [database deleteCompany:company];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:nil];
    [self performSegueWithIdentifier:@"deleteCompany" sender:nil];
}
@end
