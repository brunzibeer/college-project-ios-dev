//
//  MapAnnotation.h
//  GeoNotifier
//
//  Created by Mattia Bernardi on 04/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapAnnotation : NSObject

@property (nonatomic) float annotationLatitude;
@property (nonatomic) float annotationLongitude;

@end

NS_ASSUME_NONNULL_END
