//
//  MyAnnotation.h
//  allowsBackgroundLocationUpdates
//
//  Created by zzw on 16/4/18.
//  Copyright © 2016年 zzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyAnnotation : NSObject<MKAnnotation>
@property (nonatomic,readonly)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@end
