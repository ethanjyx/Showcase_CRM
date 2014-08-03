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



@interface DetailContactViewController : ViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    NSArray *provinces;
    NSArray *cities;
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UITextField *province;
@property (weak, nonatomic) IBOutlet UITextField *city;

@property (nonatomic, strong) Contact *contact;

- (IBAction)finish:(id)sender;

- (IBAction)editcity:(id)sender;
- (IBAction)editprovince:(id)sender;


@end
