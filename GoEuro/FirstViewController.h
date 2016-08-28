//
//  FirstViewController.h
//  GoEuro
//
//  Created by Aaqib Hussain on 15/08/2016.
//  Copyright © 2016 Aaqib Hussain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelCell.h"
#import <AFNetworking.h>

@interface FirstViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
//For iOS 7: For differentiating between two alerts
@property NSString *keyForAlert;
@property NSMutableArray *trainData;
@end

