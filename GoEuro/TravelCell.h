//
//  TravelCell.h
//  GoEuro
//
//  Created by Muhammad Raza on 27/08/2016.
//  Copyright © 2016 Aaqib Hussain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTime;
@property (weak, nonatomic) IBOutlet UILabel *priceInEuros;
@property (weak, nonatomic) IBOutlet UILabel *departTime;

@end
