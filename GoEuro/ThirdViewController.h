//
//  ThirdViewController.h
//  GoEuro
//
//  Created by Muhammad Raza on 28/08/2016.
//  Copyright © 2016 Aaqib Hussain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelCell.h"

@interface ThirdViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property NSMutableArray *flightData;
@end
