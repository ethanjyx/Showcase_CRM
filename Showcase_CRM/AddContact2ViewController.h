//
//  AddContact2ViewController.h
//  Showcase_CRM
//
//  Created by user on 14-7-15.
//  Copyright (c) 2014年 Linfeng Shi. All rights reserved.
//

#import "ViewController.h"

@interface AddContact2ViewController : ViewController

@property (nonatomic, strong) NSString *company;
@property (weak, nonatomic) IBOutlet UINavigationBar *header3;

- (IBAction)save:(id)sender;

@end
