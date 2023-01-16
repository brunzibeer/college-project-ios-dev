//
//  ShowLocationOnMapViewController.m
//  GeoNotifier
//
//  Created by Mattia Bernardi on 05/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import "ShowLocationOnMapViewController.h"
#import "EditReminderTableViewController.h"
#import "SearchLocationViewController.h"

@interface ShowLocationOnMapViewController ()

@end

@implementation ShowLocationOnMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Setting the value to 0 so I can start count
    self.numberOfAnnotationsOnMap = 0;
    //User position code -> I'll use it in the long press gesture
    locationManager.delegate = self;
    self.mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Adding the annotation on the map
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = editablePin.coordinate;
    pointAnnotation.title = editablePin.associatedReminderName;
    [self.mapView addAnnotation:pointAnnotation];
    
    //Code for initial map coordinates
    CLLocationCoordinate2D locationCoordinate;
    locationCoordinate.latitude = pointAnnotation.coordinate.latitude;
    locationCoordinate.longitude = pointAnnotation.coordinate.longitude;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    region.span = span;
    region.center = locationCoordinate;
    [self.mapView setRegion:region animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) setEditableReminder:(Reminder *)setEditableReminder {
    editableReminder = setEditableReminder;
}

- (void) setEditablePin:(PinOnMap *)setEditablePin {
    editablePin = setEditablePin;
}


- (void) removeMapAnnotation {
    //Current user location annotation
    id userAnnotation = self.mapView.userLocation;
    //Remove added annotation
    [self.mapView removeAnnotations:self.mapView.annotations];
    //Re-adding the user location
    if (userAnnotation != nil) {
        [self.mapView addAnnotation:userAnnotation];
    }
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self setEditablePin:editablePin];
    //Let the pin name be the reminder one
    editablePin.associatedReminderName = editableReminder.reminderName;
    
    //Positionining the pin on the map
    if (editablePin.coordinate.longitude != 0 && editablePin.coordinate.latitude != 0) {
        //Updating the properties
        editableReminder.reminderLatitude = editablePin.coordinate.latitude;
        editableReminder.reminerLongitude = editablePin.coordinate.longitude;
        
        //Setting the pin
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = editablePin.coordinate;
        pointAnnotation.title = editablePin.associatedReminderName;
        
        //Incrementing the counter
        self.numberOfAnnotationsOnMap += 1;
        //Showing
        [self.mapView addAnnotation:pointAnnotation];
    }
    
}

- (IBAction)longPressGesture:(UILongPressGestureRecognizer *)sender {
    //If gesture ain't recognized
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    //Now I need to check wheter there's already an annotation on the map ora not
    //If there's none
    if (self.numberOfAnnotationsOnMap == 0) {
        //I can put one on the map
        CGPoint touchedPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D touchedLocation = [self.mapView convertPoint:touchedPoint toCoordinateFromView:self.mapView];
        
        //Passing the coordinates and the name of the touched point to the pin
        editablePin.coordinate = touchedLocation;
        editablePin.associatedReminderName = editableReminder.reminderName;
        //I nedd also to update the reminder params
        editableReminder.reminerLongitude = editablePin.coordinate.longitude;
        editableReminder.reminderLatitude = editablePin.coordinate.latitude;
        
        //Adding the annotaion
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = editablePin.coordinate;
        pointAnnotation.title = editablePin.associatedReminderName;
        [self.mapView addAnnotation:pointAnnotation];
        //Incrementing the counter
        self.numberOfAnnotationsOnMap += 1;
        NSLog(@"ANNOTATION FROM SCRATCH");
    //Else, if one already exists
    } else {
        //Removing the preious one and adding the new one
        [self removeMapAnnotation];
        CGPoint touchedPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D touchedLocation = [self.mapView convertPoint:touchedPoint toCoordinateFromView:self.mapView];
        
        //Passing the coordinates and the name of the touched point to the pin
        editablePin.coordinate = touchedLocation;
        editablePin.associatedReminderName = editableReminder.reminderName;
        //I nedd also to update the reminder params
        editableReminder.reminerLongitude = editablePin.coordinate.longitude;
        editableReminder.reminderLatitude = editablePin.coordinate.latitude;
        
        //Adding the annotaion
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = editablePin.coordinate;
        pointAnnotation.title = editablePin.associatedReminderName;
        [self.mapView addAnnotation:pointAnnotation];
        NSLog(@"ANNOTATION MOVED");
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
@end
