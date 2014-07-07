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
    [database addCompanyWithName:companyName.text phone:phone.text website:website.text industry:industryType.text];
    //NSLog(@"saved customer");
}



@end
