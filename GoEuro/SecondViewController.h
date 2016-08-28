//
//  SecondViewController.h
//  GoEuro
//
//  Created by Aaqib Hussain on 15/08/2016.
//  Copyright © 2016 Aaqib Hussain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelCell.h"
#import <AFNetworking.h>

@interface SecondViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property NSMutableArray *busData;

@end

