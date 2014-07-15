//
//  DetailContactViewController.h
//  Showcase_CRM
//
//  Created by user on 14-7-16.
//  Copyright (c) 2014年 Linfeng Shi. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "Contact.h"


@interface DetailContactViewController : ViewController

@property (weak, nonatomic) IBOutlet UILabel *lastname;
@property (weak, nonatomic) IBOutlet UILabel *firstname;
@property (strong,nonatomic) NSString *lastnamestring;
@property (strong,nonatomic) NSString *firstnamestring;
@end
