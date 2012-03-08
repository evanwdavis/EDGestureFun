//
//  EDHiddenTableViewController.h
//  EDGestureFun
//
//  Created by Evan Davis on 3/3/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EDHiddenTableViewControllerDelegate;

@interface EDHiddenTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@end


@protocol EDHiddenTableViewControllerDelegate <NSObject>

@end