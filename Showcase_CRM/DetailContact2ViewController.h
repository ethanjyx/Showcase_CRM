//
//  DetailContact2ViewController.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/22/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "ViewController.h"
#import "Contact.h"

@interface DetailContact2ViewController : ViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>{
    NSArray *provinces;
    NSArray *cities;
    NSArray *countries;
}

@property (nonatomic, strong) Contact *contact;
@property (nonatomic, strong) Company *company;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
- (IBAction)finish:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIPickerView *countrypicker;
- (IBAction)editcitiy:(id)sender;
- (IBAction)editcountry:(id)sender;

- (IBAction)editprovince:(id)sender;
@end
