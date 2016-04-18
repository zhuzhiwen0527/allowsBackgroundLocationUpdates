//
//  MyAnnotation.m
//  allowsBackgroundLocationUpdates
//
//  Created by zzw on 16/4/18.
//  Copyright © 2016年 zzw. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate NS_AVAILABLE(10_9, 4_0){
    
    _coordinate = newCoordinate;
    
}
@end
