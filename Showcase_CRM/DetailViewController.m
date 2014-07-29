//
//  DetailViewController.m
//  Showcase_CRM
//
//  Created by user on 14-6-24.
//  Copyright (c) 2014年 Linfeng Shi. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
 */

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

@synthesize state,capital,stateLabel, capitalLabel;
@synthesize n,m;

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    m= [[UINavigationBar alloc] initWithFrame:CGRectMake(-31, 100, 768, 100)];
    
    
    stateLabel.text = state;
    
    capitalLabel.text = capital;
    
}

@end
