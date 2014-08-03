//
//  BillAddressViewController.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/20/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "ViewController.h"
#import "Company.h"

@interface BillAddressViewController : ViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    NSArray *provinces;
    NSArray *cities;
}

@property (nonatomic, strong) Company *company;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
- (IBAction)finish:(id)sender;
- (IBAction)editprovince:(id)sender;
- (IBAction)editcity:(id)sender;

@end
