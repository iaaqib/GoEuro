//
//  SecondViewController.m
//  GoEuro
//
//  Created by Aaqib Hussain on 15/08/2016.
//  Copyright © 2016 Aaqib Hussain. All rights reserved.
//

#import "SecondViewController.h"
#import "Network.h"
#import "GoEuro-Swift.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize busData;
- (void)viewDidLoad {
    [super viewDidLoad];
    [Network delegate:self];
    
    busData = [NSMutableArray new];
     NSLog(@"Reachability Second");
   
    
    if ([Network connectivityCode] == 0 || [Network connectivityCode] == -1){
        busData = [NSMutableArray new];
        NSArray *savedData = [[DataModel userDefaults] objectForKey:@"busData"];
        if (savedData != NULL){
            [Util showAlert:@"Sorry" message:@"No Internet Available.\nWould you like to load from Cache?" buttonTitle:@"OK" sender:self completion:^{

                busData = [Network loadData:savedData];
                [Util animateCells:self.tableView];
            }];
        }
        else{
            [Util showAlert:@"Sorry" message:@"Internet Isn't Connected" buttonTitle:@"Retry" sender:self completion:^{
                [self sendRequest];
            }];
        }
        
    }
    else {
    
    [self sendRequest];
    
    }
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(sortBy:)];
    rightButton.tintColor =[UIColor whiteColor];
    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;

}


-(void) sendRequest{
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
    
    [Network request:@"https://api.myjson.com/bins/37yzm" parameters:nil completion:^(id finished, NSError *error) {
        //   NSLog(@"success!%@",finished);
        if (error == NULL)
        {
            if (finished != NULL){
                for (int i = 0 ; i < [finished count] ; i++){
                    [busData addObject:[[DataModel alloc] initWithData:finished index:i]];
                    //      NSLog(@"Prices:%@",[[busData objectAtIndex:i] prices]);
                    
                }
                [_activityIndicator stopAnimating];
                //For Sorting Departure Time
                NSArray *sortedArray = [Util sortedData:busData valueKey:@"departureTime"];
                [busData removeAllObjects];
                busData = [NSMutableArray arrayWithArray:sortedArray];
                [Util animateCells:self.tableView];
                [[DataModel userDefaults] setObject:finished forKey:@"busData"];
                
            }
            else{
                if ([Network connectivityCode] == 0 || [Network connectivityCode] == -1){
                    [Util showAlert:@"Sorry" message:@"Internet Isn't Connected" buttonTitle:@"Retry" sender:self completion:^{
                        [self sendRequest];
                    }];
                    
                }
                else{
                    NSLog(@"Nothing To Show");
                    
                    
                    [Util showAlert:@"Sorry" message:@"No Data Available to Show" buttonTitle:@"Retry" sender:self completion:^{
                        [self sendRequest];
                        
                    }];
                    
                }
                
                [_activityIndicator stopAnimating];
                
            }
        }
        else{
            NSLog(@"Nothing To Show");
            [_activityIndicator stopAnimating];
            if ([Network connectivityCode] == 0 || [Network connectivityCode] == -1){
                [Util showAlert:@"Sorry" message:@"Internet Isn't Connected" buttonTitle:@"Retry" sender:self completion:^{
                    [self sendRequest];
                }];
                
            }
            else{
                NSLog(@"Nothing To Show");
                
                
                [Util showAlert:@"Sorry" message:@"No Data Available to Show" buttonTitle:@"Retry" sender:self completion:^{
                    [self sendRequest];
                    
                }];
                
            }
            
            
            
            
        }
        
        
    }];//
    
    
    
    
    
    
}



//for iOS 7
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0 && [alertView.title  isEqual: @"Sort By"]){
        NSArray *sortedArray = [Util sortedData:busData valueKey:@"departureTime"];
        [busData removeAllObjects];
        busData = [NSMutableArray arrayWithArray:sortedArray];
        [Util animateCells:self.tableView];
        return;
        
    }
    else if (buttonIndex == 1 && [alertView.title  isEqual: @"Sort By"]){
        NSArray *sortedArray = [Util sortedData:busData valueKey:@"arrival"];
        [busData removeAllObjects];
        busData = [NSMutableArray arrayWithArray:sortedArray];
        [Util animateCells:self.tableView];
        
        return;
        
    }
    
    
    if (buttonIndex == 0 && [alertView.message  isEqual: @"Offer details are not yet implemented!"]){
        NSLog(@"Alert:%@:",alertView.message);
        [self.tableView reloadData];
        return ;
    }
    if (buttonIndex == 1 && [alertView.message  isEqual:@"No Internet Available.\nWould you like to load from Cache?"]){
        NSLog(@"Alert:%@:",alertView.message);
        NSArray *savedData = [[DataModel userDefaults] objectForKey:@"busData"];
        busData = [NSMutableArray new];
        if (savedData != NULL){
            busData = [Network loadData:savedData];
            [Util animateCells:self.tableView];
        }
        return ;
    }
    if(buttonIndex == 0){
        NSLog(@"Cancel");
        return;
    }
    else if (buttonIndex == 1){
        [self sendRequest];
        
    }
    
    
    
    
}
-(void)connectivityStateChanged:(NSUInteger)connectivityCode{

    NSLog(@"%lu",(unsigned long)connectivityCode);
    if (connectivityCode == 1 || connectivityCode == 2)
    {
        
        
          [self sendRequest];
        
        
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    
    
    return busData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TravelCell *cell = (TravelCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {

        UINib *nib = [UINib nibWithNibName:@"CustomTravelCell" bundle:nil];
        
        [tableView registerNib:nib forCellReuseIdentifier:@"cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
    }
    cell.arrivalTime.text = [[busData objectAtIndex:indexPath.row] arrival];
    cell.priceInEuros.text = [NSString stringWithFormat:@"€ %@",[[busData objectAtIndex:indexPath.row] prices]];
    cell.departTime.text = [[busData objectAtIndex:indexPath.row] departureTime];
    [cell.logo sd_setImageWithURL:[NSURL URLWithString:[[busData objectAtIndex:indexPath.row] providerLogo]]
                 placeholderImage:[UIImage imageNamed:@"goeuro.png"]];
    NSLog(@"Logo:%@",[[busData objectAtIndex:indexPath.row] providerLogo]);
    return cell;
    
    
}
- (IBAction)sortBy:(UIBarButtonItem *)sender {
 
    [Util showActionSheet:self completionForDepart:^{
        NSArray *sortedArray = [Util sortedData:busData valueKey:@"departureTime"];
        [busData removeAllObjects];
        busData = [NSMutableArray arrayWithArray:sortedArray];
        [Util animateCells:self.tableView];
        
    } completionForArrival:^{
        NSArray *sortedArray = [Util sortedData:busData valueKey:@"arrival"];
        [busData removeAllObjects];
        busData = [NSMutableArray arrayWithArray:sortedArray];
        [Util animateCells:self.tableView];
    }];
    

}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [Util alertForOffers:self];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 104.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
