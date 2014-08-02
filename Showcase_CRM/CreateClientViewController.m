//
//  CreateClientViewController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/12/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "CreateClientViewController.h"
#import "AppDelegate.h"
#import "DatabaseInterface.h"

@interface CreateClientViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *header4;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) IBOutlet UITextField *companyName;
@property (retain, nonatomic) IBOutlet UITextField *phone;
@property (retain, nonatomic) IBOutlet UITextField *website;
@property (retain, nonatomic) IBOutlet UITextField *industryType;


- (IBAction)save:(id)sender;

@end


@implementation CreateClientViewController
@synthesize companyName;
@synthesize phone;
@synthesize website;
@synthesize industryType;
@synthesize header4;

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
    header4.frame=CGRectMake(0, 0, 768, 73);
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
    if ([companyName.text length]<=0 ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建失败"
                                                        message:@"公司名不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    [database addCompanyWithName:companyName.text phone:phone.text website:website.text industry:industryType.text];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:nil];
    [self performSegueWithIdentifier:@"saveCompanyInfo" sender:nil];
}



@end
