//
//  HWG.h
//  HWG
//
//  Created by Alexander Danilyak on 10/11/2016.
//  Copyright © 2016 adanilyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

typedef NS_ENUM(NSUInteger, HGWType) {
    dilation,
    erosion
};

@interface HGW : NSObject

- (void)makeHGW:(NSUInteger)p withType:(HGWType)type andSaveWithName:(NSString*)name;
- (void)simpleWith:(NSUInteger)p and:(HGWType)type andSaveWithName:(NSString*)name;

@end


