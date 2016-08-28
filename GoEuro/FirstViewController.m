//
//  FirstViewController.m
//  GoEuro
//
//  Created by Aaqib Hussain on 15/08/2016.
//  Copyright © 2016 Aaqib Hussain. All rights reserved.
//

#import "FirstViewController.h"
#import "Network.h"
#import "GoEuro-Swift.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize trainData;
- (void)viewDidLoad {
    [super viewDidLoad];
   

    trainData = [NSMutableArray new];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %ld", (long)status);
        [Network setConnectivityCode:status];
        
        if (status == 1 || status == 2)
        {
            
            [self sendRequest];
            
        }
        else{
          //  [Network setConnectivityCode:0];
            [_activityIndicator stopAnimating];
            if (status == 0 || status == -1){
                trainData = [NSMutableArray new];
                NSArray *savedData = [[DataModel userDefaults] objectForKey:@"trainData"];
                if (savedData != NULL){
                    [Util showAlert:@"Sorry" message:@"No Internet Available.\nWould you like to load from Cache?" buttonTitle:@"OK" sender:self completion:^{

                        trainData = [Network loadData:savedData];
                        [Util animateCells:self.tableView];
                        
                    }];
                }
                
            }
            else{
            [Util showAlert:@"Sorry" message:@"Internet Isn't Connected" buttonTitle:@"Retry" sender:self completion:^{
                [self sendRequest];
            }];
            }
        }
        
       
        
    }];


}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    
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

    [Network request:@"https://api.myjson.com/bins/3zmcy" parameters:nil completion:^(id finished, NSError *error) {
     //   NSLog(@"success!%@",finished);
        if (error == NULL)
        {
            if (finished != NULL){
                for (int i = 0 ; i < [finished count] ; i++){
                    [trainData addObject:[[DataModel alloc] initWithData:finished index:i]];
              //      NSLog(@"Prices:%@",[[trainData objectAtIndex:i] prices]);
                    
                }
                [_activityIndicator stopAnimating];
               //For Sorting Departure Time
                NSArray *sortedArray = [Util sortedData:trainData valueKey:@"departureTime"];
                [trainData removeAllObjects];
                trainData = [NSMutableArray arrayWithArray:sortedArray];
                [Util animateCells:self.tableView];
                [[DataModel userDefaults] setObject:finished forKey:@"trainData"];
                
            }
            else{
                NSLog(@"Nothing To Show");
                [_activityIndicator stopAnimating];
                
                [Util showAlert:@"Sorry" message:@"No Data Available to Show" buttonTitle:@"Retry" sender:self completion:^{
                    [self sendRequest];
                    
                }];
                
            }
        }
        else{
            NSLog(@"Nothing To Show");
            [_activityIndicator stopAnimating];
            [Util showAlert:@"Sorry" message:@"No Data Available to Show" buttonTitle:@"Retry" sender:self completion:^{
                [self sendRequest];
            }];

        
        
        
        }
        

    }];//
    





}


//for iOS 7
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0 && [alertView.title  isEqual: @"Sort By"]){
        NSArray *sortedArray = [Util sortedData:trainData valueKey:@"departureTime"];
        [trainData removeAllObjects];
        trainData = [NSMutableArray arrayWithArray:sortedArray];
        [Util animateCells:self.tableView];
        return;
        
    }
    else if (buttonIndex == 1 && [alertView.title  isEqual: @"Sort By"]){
        NSArray *sortedArray = [Util sortedData:trainData valueKey:@"arrival"];
        [trainData removeAllObjects];
        trainData = [NSMutableArray arrayWithArray:sortedArray];
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
        NSArray *savedData = [[DataModel userDefaults] objectForKey:@"trainData"];
        trainData = [NSMutableArray new];
        if (savedData != NULL){
            trainData = [Network loadData:savedData];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{


    return trainData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    TravelCell *cell = (TravelCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
   //     NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTravelCell" owner:self options:nil];
     //   cell = [nib objectAtIndex:0];
        UINib *nib = [UINib nibWithNibName:@"CustomTravelCell" bundle:nil];
        
        [tableView registerNib:nib forCellReuseIdentifier:@"cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
    }
    cell.arrivalTime.text = [[trainData objectAtIndex:indexPath.row] arrival];
    cell.priceInEuros.text = [NSString stringWithFormat:@"€ %@",[[trainData objectAtIndex:indexPath.row] prices]];
    cell.departTime.text = [[trainData objectAtIndex:indexPath.row] departureTime];
    [cell.logo sd_setImageWithURL:[NSURL URLWithString:[[trainData objectAtIndex:indexPath.row] providerLogo]]
                      placeholderImage:[UIImage imageNamed:@"goeuro.png"]];
 //  NSLog(@"Logo:%@",[[trainData objectAtIndex:indexPath.row] providerLogo]);
    return cell;


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 104.0;
}
- (IBAction)sortBy:(UIBarButtonItem *)sender {

    [Util showActionSheet:self completionForDepart:^{
        NSArray *sortedArray = [Util sortedData:trainData valueKey:@"departureTime"];
        [trainData removeAllObjects];
        trainData = [NSMutableArray arrayWithArray:sortedArray];
        [Util animateCells:self.tableView];
     
    } completionForArrival:^{
        NSArray *sortedArray = [Util sortedData:trainData valueKey:@"arrival"];
        [trainData removeAllObjects];
        trainData = [NSMutableArray arrayWithArray:sortedArray];
        [Util animateCells:self.tableView];
    }];


}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [Util alertForOffers:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
