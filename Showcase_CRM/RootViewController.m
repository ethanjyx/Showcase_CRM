//
//  RootViewController.m
//  Showcase_CRM
//
//  Created by Yixing Jiang on 7/10/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "sksViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController
@synthesize toolbar;

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"initSplitView"]) {
        UISplitViewController *splitViewController = (UISplitViewController *)[segue destinationViewController];
        NSLog(@"%@", NSStringFromClass(splitViewController.class));
        ViewController *leftViewController = [splitViewController.viewControllers objectAtIndex:0];
        sksViewController *rightViewController = [splitViewController.viewControllers objectAtIndex:1];
        leftViewController.delegate = rightViewController;
    }
}


- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination to supported by Viewcontroller.
    return UIInterfaceOrientationMaskLandscape;
}

@end
