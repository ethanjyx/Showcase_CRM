//
//  AddProjectViewController.h
//  Showcase_CRM
//
//  Created by Yixing Jiang on 7/25/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddProjectViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>{
    NSArray *pickerArray;
}

@property (nonatomic, strong) NSString *company;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)finish:(id)sender;

- (IBAction)edit:(id)sender;
@end
