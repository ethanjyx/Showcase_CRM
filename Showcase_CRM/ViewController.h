//
//  ViewController.h
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/10/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
}
@property(nonatomic,retain) NSMutableDictionary *states;
@property(nonatomic,retain) NSArray *datasource;

-(void)setupArray;

@end



