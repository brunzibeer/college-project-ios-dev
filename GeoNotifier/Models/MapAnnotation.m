//
//  MapAnnotation.m
//  GeoNotifier
//
//  Created by Mattia Bernardi on 04/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

//Custom initializer
- (instancetype)initAnnotationWithLatitude:(float)latitude
                              andLongitude:(float) longitude {
    
    self = [super init];
    
    if (self) {
        self.annotationLatitude = latitude;
        self.annotationLongitude = longitude;
    }
    
    return self;
}

@end
