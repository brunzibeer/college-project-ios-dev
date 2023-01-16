//
//  ViewController.h
//  GeoNotifier
//
//  Created by Mattia Bernardi on 29/02/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import <MapKit/MapKit.h>
#import "Reminder.h"
#import "PinOnMap.h"

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate> {
    
    CLLocationManager *locationManager;
    CLLocationManager *geofenceManager;
    CLLocation *location;
    double userLatitude;
    double userLongitude;
    NSMutableArray<Reminder *> *reminderList;
    NSMutableArray<PinOnMap *> *pinList;
}

//PROPERTIES
@property (weak, nonatomic) IBOutlet MKMapView *objMapView;

//METHODS
- (IBAction)locateUser:(id)sender; //Centers the map on user position

@end

