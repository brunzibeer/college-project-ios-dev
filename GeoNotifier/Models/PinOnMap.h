//
//  PinOnMap.h
//  GeoNotifier
//
//  Created by Mattia Bernardi on 04/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PinOnMap : NSObject <MKAnnotation> {
    CLLocationCoordinate2D location;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSString *associatedReminderName;

@end

NS_ASSUME_NONNULL_END
