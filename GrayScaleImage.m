//
//  Image.m
//  HGW
//
//  Created by Alexander Danilyak on 10/11/2016.
//  Copyright © 2016 adanilyak. All rights reserved.
//

#import "GrayScaleImage.h"
#import <AppKit/AppKit.h>

static NSString* formatOutString = @"/Users/Alexander/Desktop/HGW/%@.bmp";

@interface GSImage() <NSCopying> {
    NSUInteger offsetX;
    NSUInteger offsetY;
}

@property (nonatomic) NSBitmapImageRep* bitMapImage;

@end

@implementation GSImage

@synthesize w;
@synthesize h;

- (void)loadImageNamed:(NSString*)name {
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"bmp" inDirectory:nil forLocalization:nil];
    NSImage* image = [[NSImage alloc] initWithContentsOfFile:path];
    _bitMapImage = (NSBitmapImageRep*)[[image representations]objectAtIndex:0];
    [self makeArrayFromImage];
}

- (void)makeArrayFromImage {
    offsetX = 0;
    offsetY = 0;
    
    _pixels = [[NSMutableArray alloc] initWithCapacity:_bitMapImage.pixelsHigh];
    for(int i = 0; i < _bitMapImage.pixelsHigh; ++i) {
        _pixels[i] = [[NSMutableArray alloc] initWithCapacity:_bitMapImage.pixelsWide];
        for(int j = 0; j < _bitMapImage.pixelsWide; ++j) {
            NSUInteger data[3];
            [_bitMapImage getPixel:data atX:j y:i];
            _pixels[i][j] = @(data[0]);
        }
    }
}

- (void)saveImageWithName:(NSString*)name {
    unsigned char* emptyData = malloc(_bitMapImage.pixelsWide * _bitMapImage.pixelsHigh * _bitMapImage.bitsPerPixel);
    NSBitmapImageRep* outImg = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&emptyData
                                                                       pixelsWide:_bitMapImage.pixelsWide
                                                                       pixelsHigh:_bitMapImage.pixelsHigh
                                                                    bitsPerSample:_bitMapImage.bitsPerSample
                                                                  samplesPerPixel:_bitMapImage.samplesPerPixel
                                                                         hasAlpha:_bitMapImage.hasAlpha
                                                                         isPlanar:_bitMapImage.isPlanar
                                                                   colorSpaceName:_bitMapImage.colorSpaceName
                                                                      bytesPerRow:_bitMapImage.bytesPerRow
                                                                     bitsPerPixel:_bitMapImage.bitsPerPixel];
    
    for(int i = 0; i < _bitMapImage.pixelsHigh; ++i) {
        for(int j = 0; j < _bitMapImage.pixelsWide; ++j) {
            NSUInteger value = [_pixels[i + offsetY][j + offsetX] unsignedIntegerValue];
            NSUInteger data[3] = {value, value, value};
            [outImg setPixel:data atX:j y:i];
        }
    }
    
    NSString* path = [NSString stringWithFormat:formatOutString, name];;
    NSData* data = [outImg representationUsingType:NSBMPFileType properties:@{}];
    NSLog(@"[SAVE] RESULT %d", [data writeToFile:path atomically:NO]);
}

//

- (NSUInteger)w {
    return _pixels[0].count;
}

- (NSUInteger)h {
    return _pixels.count;
}

- (void)prepareImageForHGWLines:(NSUInteger)p withValues:(NSUInteger)value {
    offsetX = 2 * p;
    
    for(NSInteger i = 0; i < _pixels.count; ++i) {
        NSUInteger n = _pixels[i].count + 4 * p;
        NSMutableArray<NSNumber*>* resizedLine = [[NSMutableArray alloc] initWithCapacity:n];
        
        for(NSInteger j = 0; j < n; ++j) {
            NSUInteger v;
            if(j < 2 * p || j >= 2 * p + _pixels[i].count) { v = value; }
            else { v = [_pixels[i][j - 2 * p] unsignedIntegerValue]; }
            resizedLine[j] = @(v);
        }
        
        _pixels[i] = resizedLine;
    }
}

- (void)prepareImageForHGWCols:(NSUInteger)p withValues:(NSUInteger)value {
    offsetY = 2 * p;
    
    NSMutableArray<NSMutableArray<NSNumber*>*>* newRows = [[NSMutableArray alloc] initWithCapacity:4 * p];
    for(int i = 0; i < 4 * p; ++i) {
        newRows[i] = [[NSMutableArray alloc] initWithCapacity:_pixels[0].count];
        for(int j = 0; j < _pixels[0].count; ++j) {
            newRows[i][j] = @(value);
        }
    }
    
    for(int i = 0; i < 4 * p; ++i) {
        if(i < 2 * p) {
            [_pixels insertObject:newRows[i] atIndex:0];
        } else {
            [_pixels addObject:newRows[i]];
        }
    }
}

//

- (NSUInteger)getX:(NSUInteger)x y:(NSUInteger)y {
    return [_pixels[y][x] unsignedIntegerValue];
}

- (void)setX:(NSUInteger)x y:(NSUInteger)y value:(NSUInteger)value {
    _pixels[y][x] = @(value);
}

- (id)copyWithZone:(NSZone *)zone
{
    GSImage *copy = [[[self class] allocWithZone:zone] init];
    [copy setPixels:[self copyPixels]];
    [copy setBitMapImage:[[self bitMapImage] copy]];
    return copy;
}

- (NSMutableArray*)copyPixels {
    NSMutableArray* new = [[NSMutableArray alloc] initWithCapacity:_pixels.count];
    for(int i = 0; i < _pixels.count; ++i) {
        new[i] = [[NSMutableArray alloc] initWithCapacity:_pixels[0].count];
        for(int j = 0; j < _pixels[0].count; ++j) {
            new[i][j] = _pixels[i][j];
        }
    }
    return new;
}

- (void)print {
    for(int i = 0; i < _pixels.count; ++i) {
        for(int j = 0; j < _pixels[0].count; ++j) {
            printf("%03ld ", [_pixels[i][j] unsignedIntegerValue]);
        }
        printf("\n");
    }
}

@end
