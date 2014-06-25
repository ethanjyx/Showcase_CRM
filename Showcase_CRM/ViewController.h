//
//  ViewController.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/10/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKPeoplePickerController.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate, TKPeoplePickerControllerDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (IBAction)showPeoplePicker:(id)sender;

@end