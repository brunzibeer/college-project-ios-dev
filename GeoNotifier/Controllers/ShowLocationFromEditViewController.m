//
//  ShowLocationFromEditViewController.m
//  GeoNotifier
//
//  Created by Mattia Bernardi on 06/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import "ShowLocationFromEditViewController.h"
#import "SearchLocationViewController.h"

@interface ShowLocationFromEditViewController ()

@end

@implementation ShowLocationFromEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Setting the pin number to 0 to keep track (I could have used a BOOL var)
    self.numberOfAnnotationsOnMap = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Placing a point on the map
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = editablePin.coordinate;
    pointAnnotation.title = editablePin.associatedReminderName;
    [self.mapV addAnnotation:pointAnnotation];
    
    //Centering the map on the pin region
    CLLocationCoordinate2D location;
    location.latitude = pointAnnotation.coordinate.latitude;
    location.longitude = pointAnnotation.coordinate.longitude;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    region.span = span;
    region.center = location;
    [self.mapV setRegion:region animated:YES];
    
    //Incrementing the pin number
    self.numberOfAnnotationsOnMap += 1;
}

- (void) setEditablePin:(PinOnMap *)setEditablePin {
    editablePin = setEditablePin;
}

- (void) setEditableReminder:(Reminder *)setEditableReminder {
    editableReminder = setEditableReminder;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
