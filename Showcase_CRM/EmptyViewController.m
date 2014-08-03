//
//  EmptyViewController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 8/3/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "EmptyViewController.h"

@interface EmptyViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *header;

@end

@implementation EmptyViewController
@synthesize header;

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

@end
