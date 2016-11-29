//
//  Image.h
//  HGW
//
//  Created by Alexander Danilyak on 10/11/2016.
//  Copyright © 2016 adanilyak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSImage : NSObject

@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSNumber*>*>* pixels;

@property (nonatomic, assign) NSUInteger w;
@property (nonatomic, assign) NSUInteger h;

- (void)prepareImageForHGWLines:(NSUInteger)p withValues:(NSUInteger)value;
- (void)prepareImageForHGWCols:(NSUInteger)p withValues:(NSUInteger)value;

- (NSUInteger)getX:(NSUInteger)x y:(NSUInteger)y;
- (void)setX:(NSUInteger)x y:(NSUInteger)y value:(NSUInteger)value;

- (void)loadImageNamed:(NSString*)name;
- (void)saveImageWithName:(NSString*)name;

- (void)print;

@end
