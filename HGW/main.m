//
//  main.m
//  HWG
//
//  Created by Alexander Danilyak on 10/11/2016.
//  Copyright © 2016 adanilyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGW.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        for(NSInteger p = 1; p <= 1000; p++) {
            
            NSDate* now = [NSDate date];
            
            HGW* hgw1 = [[HGW alloc] init];
            [hgw1 makeHGW:p withType:dilation andSaveWithName:[[NSString alloc] initWithFormat:@"dil_%04ld", p]];
            
            NSLog(@"%@", [[NSString alloc] initWithFormat:@"dil_%04ld in %f", p, [[NSDate date] timeIntervalSinceDate:now]]);
            now = [NSDate date];
            
            HGW* hgw2 = [[HGW alloc] init];
            [hgw2 makeHGW:p withType:erosion andSaveWithName:[[NSString alloc] initWithFormat:@"ero_%04ld", p]];
            NSLog(@"%@", [[NSString alloc] initWithFormat:@"ero_%04ld in %f", p, [[NSDate date] timeIntervalSinceDate:now]]);
            
            //HGW* sim1 = [[HGW alloc] init];
            //[sim1 simpleWith:p and:dilation andSaveWithName:[[NSString alloc] initWithFormat:@"s %ld d", p]];
            
            //HGW* sim2 = [[HGW alloc] init];
            //[sim2 simpleWith:p and:erosion andSaveWithName:[[NSString alloc] initWithFormat:@"s %ld e", p]];
        }
    }
    return 0;
}
