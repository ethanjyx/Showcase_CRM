//
//  DetailViewController.h
//  Showcase_CRM
//
//  Created by user on 14-6-24.
//  Copyright (c) 2014年 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DetailViewController : UIViewController{
    
    NSString *state;
    
    NSString *capital;
    
    IBOutlet UILabel *stateLabel;
    
    IBOutlet UILabel *capitalLabel;
    
}

@property (nonatomic, retain)NSString *state, *capital;

@property (nonatomic, retain)IBOutlet UILabel *stateLabel, *capitalLabel;

@end


    



