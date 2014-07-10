//
//  SplitViewSelectionDelegate.h
//  Showcase_CRM
//
//  Created by Yixing Jiang on 7/10/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Company;
@protocol SplitViewSelectionDelegate <NSObject>
@required
-(void) setSelectedCompany:(Company*)comp;

@end
