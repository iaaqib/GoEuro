//
//  Network.m
//  GoEuro
//
//  Created by Aaqib Hussain on 25/08/2016.
//  Copyright © 2016 Aaqib Hussain. All rights reserved.
//

#import "Network.h"

#import <AFNetworking.h>
#import "GoEuro-Swift.h"

@implementation Network

static NSUInteger connectivityCode;
+(void)request:(NSString*)url parameters:(NSDictionary*)parametersDictionary completion:(void (^)(id finished, NSError* error))completion {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    [manager GET:url parameters:parametersDictionary progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, NULL);
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(NULL, error);
        
    }];
 

}
+ (NSUInteger) connectivityCode { return connectivityCode; }
+ (void)setConnectivityCode:(NSUInteger)value
{ connectivityCode = value;
}
+(NSMutableArray*)loadData:(NSArray *)savedData{

   NSMutableArray *array = [NSMutableArray new];
    
    // if (flightData == NULL){
    
    for (int i = 0 ; i < [savedData count] ; i++){
        [array addObject:[[DataModel alloc] initWithData:savedData index:i]];
        //      NSLog(@"Prices:%@",[[trainData objectAtIndex:i] prices]);
        
    }
    NSArray *sortedArray = [Util sortedData:array valueKey:@"departureTime"];
    [array removeAllObjects];
    array = [NSMutableArray arrayWithArray:sortedArray];
    return array;
    // [Util animateCells:self.tableView];


}
@end
