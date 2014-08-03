//
//  AddContact2ViewController.h
//  Showcase_CRM
//
//  Created by user on 14-7-15.
//  Copyright (c) 2014年 Linfeng Shi. All rights reserved.
//

#import "ViewController.h"

@interface AddContact2ViewController : ViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    NSArray *provinces;
    NSArray *cities;
}

@property (nonatomic, strong) NSString *company;
@property (weak, nonatomic) IBOutlet UINavigationBar *header3;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

- (IBAction)save:(id)sender;
- (IBAction)finish:(id)sender;
- (IBAction)editprovince:(id)sender;
- (IBAction)editcity:(id)sender;

@end
