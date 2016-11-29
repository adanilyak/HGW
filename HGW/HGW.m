//
//  HWG.m
//  HWG
//
//  Created by Alexander Danilyak on 10/11/2016.
//  Copyright © 2016 adanilyak. All rights reserved.
//

#import "HGW.h"
#import "GrayScaleImage.h"

@interface HGW() {
    NSUInteger defV;
}

@property(nonatomic, strong) GSImage* img;
@property(nonatomic, assign) HGWType type;

@end

@implementation HGW

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if(self != nil) {
        _img = [[GSImage alloc] init];
        [_img loadImageNamed:@"bw_big_gr"];
    }
    return self;
}

#pragma mark - HGW

- (NSUInteger)minmax:(NSUInteger)a :(NSUInteger)b {
    return _type == dilation ? MAX(a, b) : MIN(a, b);
}

- (void)makeHGW:(NSUInteger)p withType:(HGWType)type andSaveWithName:(NSString*)name {
    @autoreleasepool {
        _type = type;
        defV = _type == dilation ? 0 : 255;
        
        [_img prepareImageForHGWLines:p withValues:defV];
        // rows
        GSImage* img = [_img copy];
        for(NSInteger n = 0; n < _img.h; ++n) {
            [self doHgwOnLineWith:n and:p for:img];
        }
        
        [_img prepareImageForHGWCols:p withValues:defV];
        
        // cols
        for(NSInteger n = 0; n < _img.w; ++n) {
            [self doHgwOnColsWith:n and:p for:_img];
        }
        
        [_img saveImageWithName:name];
    }
}

- (void)doHgwOnLineWith:(NSUInteger)n and:(NSUInteger)p for:(GSImage*)img {
    NSUInteger s = 2 * p + 1;
    NSUInteger step = s - 1;
    NSUInteger B[_img.w];
    for(NSInteger x = 2 * p; x + step < _img.w; x += step) {
        @autoreleasepool {
            NSUInteger L[s-1], R[s-1];
            
            R[0] = [img getX:x y:n];
            for(NSInteger i = 1; i < s - 1; ++i) {
                R[i] = [self minmax:R[i-1] :[img getX:x+i y:n]];
            }
            
            L[s-2] = [img getX:x-1 y:n];
            for(NSInteger i = 1; i < s - 1; ++i) {
                L[s-i-2] = [self minmax:L[s-i-1] :[img getX:x-i-1 y:n]];
            }
            
            for(NSInteger i = 0; i < s - 1; ++i) {
                NSUInteger v = [self minmax:L[i] :R[i]];
                NSUInteger pos = x - p + i + 1;
                B[pos] = v;
            }
        }
    }
    
    for(NSInteger i = 0; i < _img.w; ++i) {
        [_img setX:i y:n value:B[i]];
    }
}

- (void)doHgwOnColsWith:(NSUInteger)n and:(NSUInteger)p for:(GSImage*)img {
    NSUInteger s = 2 * p + 1;
    NSUInteger step = s - 1;
    NSUInteger B[_img.h];
    for(NSInteger x = 2 * p; x + step < _img.h; x += step) {
        @autoreleasepool {
            NSUInteger L[s-1], R[s-1];
            
            R[0] = [img getX:n y:x];
            for(NSInteger i = 1; i < s - 1; ++i) {
                R[i] = [self minmax:R[i-1] :[img getX:n y:x+i]];
            }
            
            L[s-2] = [img getX:n y:x-1];
            for(NSInteger i = 1; i < s - 1; ++i) {
                L[s-2-i] = [self minmax:L[s-1-i] :[img getX:n y:x-i-1]];
            }
            
            for(NSInteger i = 0; i < s - 1; ++i) {
                NSUInteger v = [self minmax:L[i] :R[i]];
                NSUInteger pos = x - p + i + 1;
                B[pos] = v;
            }
        }
    }
    
    for(NSInteger i = 0; i < _img.h; ++i) {
        [_img setX:n y:i value:B[i]];
    }
}

// Simple algo

- (void)simpleWith:(NSUInteger)p and:(HGWType)type andSaveWithName:(NSString*)name {
    _type = type;
    defV = _type == dilation ? 0 : 255;
    
    GSImage* img = [_img copy];
    [self simpleOnLines:p and:img];
    
    _img = img;
    img = [_img copy];
    [self simpleOnCols:p and:img];
    
    [img saveImageWithName:name];
}

- (void)simpleOnLines:(NSInteger)p and:(GSImage*)img {
    for(int i = 0; i < img.h; ++i) {
        for(int j = 0; j < img.w; ++j) {
            NSUInteger v = (NSUInteger)[_img getX:j y:i];
            for(NSInteger t = -p; t <= p; ++t) {
                if(j+t < 0 || j+t >= img.w) { continue; }
                v = [self minmax:v :[_img getX:j+t y:i]];
            }
            [img setX:j y:i value:v];
        }
    }
}

- (void)simpleOnCols:(NSInteger)p and:(GSImage*)img {
    for(int i = 0; i < img.w; ++i) {
        for(int j = 0; j < img.h; ++j) {
            NSUInteger v = [_img getX:i y:j];
            for(NSInteger t = -p; t <= p; ++t) {
                if(j+t < 0 || j+t >= img.h) { continue; }
                v = [self minmax:v :[_img getX:i y:j+t]];
            }
            [img setX:i y:j value:v];
        }
    }
}

@end
