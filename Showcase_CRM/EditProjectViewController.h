//
//  EditProjectViewController.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 7/28/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "ViewController.h"
#import "Project.h"

@interface EditProjectViewController : ViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    NSArray *pickerArray;
}

@property (nonatomic, strong) Project *project;
@property (nonatomic, strong) Company *company;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

- (IBAction)Edit:(id)sender;
- (IBAction)finish:(id)sender;

@end
