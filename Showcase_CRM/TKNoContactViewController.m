//
//  TKNoContactViewController.m
//  Qnote
//
//  Created by Jongtae Ahn on 12. 9. 20..
//  Copyright (c) 2012년 Tabko Inc. All rights reserved.
//

#import "TKNoContactViewController.h"

@interface TKNoContactViewController ()

@end

@implementation TKNoContactViewController
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"所有联系人", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tkNoContactViewControllerDidCancel:)])
        [self.delegate tkNoContactViewControllerDidCancel:self];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
