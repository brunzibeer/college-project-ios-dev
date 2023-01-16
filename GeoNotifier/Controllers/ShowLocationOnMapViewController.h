//
//  ShowLocationOnMapViewController.h
//  GeoNotifier
//
//  Created by Mattia Bernardi on 05/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PinOnMap.h"
#import "Reminder.h"
#import "MapAnnotation.h"
#import "EditReminderTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowLocationOnMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, MKLocalSearchCompleterDelegate> {
    
    CLLocationManager *locationManager;
    PinOnMap *editablePin;
    Reminder *editableReminder;
}

//OUTLETS
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MapAnnotation *mapAnnotation;
@property (nonatomic) int numberOfAnnotationsOnMap;
@property (nonatomic) float annotationLatitude;
@property (nonatomic) float annotationLongitude;

//ACTIONS
- (IBAction)longPressGesture:(UILongPressGestureRecognizer *)sender;
- (void)setEditableReminder:(Reminder *)setEditableReminder;
- (void)setEditablePin:(PinOnMap *)setEditablePin;

@end

NS_ASSUME_NONNULL_END
