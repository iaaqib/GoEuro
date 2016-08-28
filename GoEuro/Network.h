//
//  Model.h
//  GoEuro
//
//  Created by Aaqib Hussain on 25/08/2016.
//  Copyright © 2016 Aaqib Hussain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoEuro-Swift.h"

@interface Network : NSObject
+(void)request:(NSString*)url parameters:(NSDictionary*)parametersDictionary completion:(void (^)(id finished, NSError* error))completion;

+ (NSUInteger) connectivityCode;
+ (void) setConnectivityCode:(NSUInteger)value;

+(NSMutableArray*)loadData:(NSArray *)savedData;
@end
