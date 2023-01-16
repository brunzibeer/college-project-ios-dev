//
//  ShowLocationFromEditViewController.h
//  GeoNotifier
//
//  Created by Mattia Bernardi on 06/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PinOnMap.h"
#import "Reminder.h"
#import "MapAnnotation.h"
#import "EditReminderTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowLocationFromEditViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, MKLocalSearchCompleterDelegate> {
    
    CLLocationManager *locationManager;
    PinOnMap *editablePin;
    Reminder *editableReminder;
}

//PROPERTIES
@property (weak, nonatomic) IBOutlet MKMapView *mapV;
@property (nonatomic) int numberOfAnnotationsOnMap;

//ACTIONS
- (void) setEditableReminder:(Reminder *)setEditableReminder;
- (void) setEditablePin:(PinOnMap *)setEditablePin;

@end

NS_ASSUME_NONNULL_END
