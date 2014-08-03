//
//  EditEventViewController.h
//  Showcase_CRM
//
//  Created by Yixing Jiang on 7/29/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import "Event.h"
#import <UIKit/UIKit.h>

@interface EditEventViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) Company *company;

@property (nonatomic, strong) NSMutableArray *allContacts;
@property (nonatomic, strong) NSMutableArray *allProjects;

@end
