//
//  AddContactViewController.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/12/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "ViewController.h"

@interface AddContactViewController : ViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>{
    NSArray *provinces;
    NSArray *cities;
}

@property (nonatomic, strong) NSString *company;
@property (weak, nonatomic) IBOutlet UINavigationBar *header2;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
- (IBAction)finish:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)editprovince:(id)sender;
- (IBAction)editcity:(id)sender;

@end
