//
//  ViewController.m
//  GeoNotifier
//
//  Created by Mattia Bernardi on 29/02/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import "ViewController.h"
#import "RemindersTableViewController.h"
#import "PinOnMap.h"
@import UserNotifications;


@interface ViewController ()

@end

//Flag to know is I have access to notification or not
BOOL notificationAccess;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Showing user location
    self -> _objMapView.showsUserLocation = YES;
    
    //MapView delegate
    self -> _objMapView.delegate = self;
    
    //Location alloc init
    self -> location = [[CLLocation alloc] init];
    
    //Reminders alloc init
    self -> reminderList = [[NSMutableArray alloc] init];
    
    //Pin alloc init
    self -> pinList = [[NSMutableArray alloc] init];
    
    //Geofencing Manager alloc init and setup
    self -> geofenceManager = [[CLLocationManager alloc] init];
    geofenceManager.delegate = self;
    geofenceManager.desiredAccuracy = kCLLocationAccuracyBest;
    geofenceManager.distanceFilter = 100;
    [geofenceManager requestAlwaysAuthorization];
    [geofenceManager startUpdatingLocation];
    
    //Asking for user notifications
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        //Setting the flag
        notificationAccess = granted;
    }];
    
#pragma mark - LOADING FROM FILE IF THERE'S ONE
    //Reading file and deserializing Json
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"reminderList.json"];
    NSString *readString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    //From here if there's something i load all infos
    if (readString.length != 0) {
        //Starting deserializing Json
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *error;
        NSArray *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        //If there's no error
        if (!error) {
            for (id obj in dictionary) {
                //Retrieving objs, creating reminders with those properties
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    //Creating the reminder
                    NSDictionary *pDict = (NSDictionary *)obj;
                    Reminder *reminder = [[Reminder alloc] init];
                    //Assigning values
                    reminder.reminderName = pDict[@"name"];
                    reminder.enterMessage = pDict[@"enter_message"];
                    reminder.exitMessage = pDict[@"exit_message"];
                    reminder.rangeInMeters = [pDict[@"range"] floatValue];
                    reminder.reminderLatitude = [pDict[@"latitude"] floatValue];
                    reminder.reminerLongitude = [pDict[@"longitude"] floatValue];
                    //Creating the pin associated to the reminder
                    PinOnMap *pin = [[PinOnMap alloc] init];
                    CLLocationCoordinate2D location;
                    location.latitude = [pDict[@"latitude"] floatValue];
                    location.longitude = [pDict[@"longitude"] floatValue];
                    pin.coordinate = location;
                    pin.associatedReminderName = pDict[@"name"];
                    
                    //Adding new objects to the arrays
                    [self -> reminderList addObject:reminder];
                    [self -> pinList addObject:pin];
                }
            }
        }
        //Updating pin on maps
        [self removeMapAnnotation];
        [self insertMapAnnotation];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Removing previous annotations
    [self removeMapAnnotation];
    //Placing existing annotations
    [self insertMapAnnotation];
    
    //Temporarly stopping region monitoring to allow updates
    for (CLCircularRegion    *monitored in [geofenceManager monitoredRegions]) {
        [locationManager stopMonitoringForRegion:monitored];
    }
    
    //Remove old overlay
    for (id overlay in self -> _objMapView.overlays) {
        if ([overlay isKindOfClass:[MKCircle class]]) {
            //Removing past overlays
            [self -> _objMapView removeOverlay:(MKCircle *)overlay];
        }
    }
    
    //Drawing circles and start monitoring regions
    for (Reminder *geoReminder in reminderList) {
        CLLocationCoordinate2D centerLocation;
        centerLocation.latitude = geoReminder.reminderLatitude;
        centerLocation.longitude = geoReminder.reminerLongitude;
        NSLog(@"%f | %f", centerLocation.latitude, centerLocation.longitude);
        CLCircularRegion *regionToMonitor = [[CLCircularRegion alloc] initWithCenter:centerLocation radius:geoReminder.rangeInMeters identifier:geoReminder.reminderName];
        
        [geofenceManager startMonitoringForRegion:regionToMonitor];
        //Drawing circle
        MKCircle *mapCircle = [MKCircle circleWithCenterCoordinate:centerLocation radius:regionToMonitor.radius];
        [_objMapView addOverlay:mapCircle];
    }
}

- (void)removeMapAnnotation {
    //Remove added annotations
    [self.objMapView removeAnnotations:self.objMapView.annotations];
    //Showing user location
    [self.objMapView setShowsUserLocation:YES];
}

- (void)insertMapAnnotation {
    //Going through pinList and getting the info
    for (PinOnMap *pin in pinList) {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = pin.coordinate;
        point.title = pin.associatedReminderName;
        //Adding the annotation
        [self.objMapView addAnnotation:point];
    }
}

//Simply calling the method to show user's current location
- (IBAction)locateUser:(id)sender {
    [self loadUserLocation];
}

//Loading the user current location
- (void) loadUserLocation {
    locationManager = [[CLLocationManager alloc] init]; //Initializing
    locationManager.delegate = self; //Setting the delegate
    locationManager.distanceFilter = kCLDistanceFilterNone; //Distance filter
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; //Distance accuracy
    //Checking if the app can respond to the new selector and reqeust the authorization
    if([self -> locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self -> locationManager requestAlwaysAuthorization]; //Asking for authorization
    }
    //Then I start updating the location
    [self -> locationManager startUpdatingLocation];
}

//Each time the location recives an update, this method is triggered
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //Getting the last location of the array in where all previous location are stored
    self -> location = locations.lastObject;
    NSLog(@"%@", self -> location.description);
    self -> userLatitude = location.coordinate.latitude; //Saving the new lati
    self -> userLongitude = location.coordinate.longitude; //Saving the new longi
    
    //Stopping the locating process and update mapView
    [locationManager stopUpdatingLocation];
    [self loadMapView];
    
}

//Method to load the updated mapView
- (void) loadMapView {
    //New user coordinates
    CLLocationCoordinate2D coordinate2D;
    coordinate2D.latitude = self -> userLatitude;
    coordinate2D.longitude = self -> userLongitude;
    
    //New span and region
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    region.span = span;
    region.center = coordinate2D;
    
    //Updating the new region
    [_objMapView setRegion:region];
}

#pragma mark - Overlay Render Delegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circleRender = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleRender.strokeColor = [UIColor blueColor];
        circleRender.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
        circleRender.lineWidth = 1.0f;
        return circleRender;
    }
    return nil;
}

#pragma mark - GEOFENCING Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLCircularRegion *)region {
    if ([region isKindOfClass:[CLCircularRegion class]] && state == CLRegionStateInside ) {
        [self locationManager:manager didEnterRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLCircularRegion *)region {
    NSLog(@"STARTED MONITORING: %@", region.identifier);
    [manager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLCircularRegion *)region {
    NSLog(@"ENTERING REGION: %@", region.identifier);
    //For each reminder
    for (Reminder *rem in self -> reminderList) {
        //Checking wich is the correct region
        if (rem.reminerLongitude == region.center.longitude && rem.reminderLatitude == region.center.latitude) {
            //If enter message is not null
            if (![rem.enterMessage isEqualToString:@""]) {
                //And if I have access to notification
                if (notificationAccess) {
                    //Setting the notification
                    UNUserNotificationCenter *notiCenter = [UNUserNotificationCenter currentNotificationCenter];
                    UNMutableNotificationContent *notiContent = [[UNMutableNotificationContent alloc] init];
                    notiContent.title = [NSString localizedUserNotificationStringForKey:[NSString stringWithFormat:@"Entering %@", region.identifier] arguments:nil];
                    notiContent.body = [NSString localizedUserNotificationStringForKey:[NSString stringWithFormat:@"Message: %@", rem.enterMessage] arguments:nil];
                    notiContent.sound = [UNNotificationSound defaultSound];
                    
                    //Notification trigger
                    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
                    //Notification request
                    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:region.identifier content:notiContent trigger:trigger];
                    //Adding the notification
                    [notiCenter addNotificationRequest:request withCompletionHandler:nil];
                }
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLCircularRegion *)region {
    NSLog(@"EXITING REGION: %@", region.identifier);
    //For each reminder
    for (Reminder *rem in self -> reminderList) {
        //Checking wich is the correct region
        if (rem.reminerLongitude == region.center.longitude && rem.reminderLatitude == region.center.latitude) {
            //If exit message is not null
            if (![rem.exitMessage isEqualToString:@""]) {
                //And if I have access to notification
                if (notificationAccess) {
                    //Setting the notification
                    UNUserNotificationCenter *notiCenter = [UNUserNotificationCenter currentNotificationCenter];
                    UNMutableNotificationContent *notiContent = [[UNMutableNotificationContent alloc] init];
                    notiContent.title = [@"GeoNotifier: Entering " stringByAppendingString:region.identifier];
                    notiContent.body = [@"Message: " stringByAppendingString:rem.exitMessage];
                    notiContent.sound = [UNNotificationSound defaultSound];
                    
                    //Notification trigger
                    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.2 repeats:NO];
                    //Notification request
                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:region.identifier content:notiContent trigger:trigger];
                    //Adding the notification
                    [notiCenter addNotificationRequest:request withCompletionHandler:nil];
                }
            }
        }
    }
}

#pragma mark - Notifications Delegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
}


#pragma mark - Prepare for segue
//Prepare for segue, passing the existing reminder list
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"reminderListSegue"]){
        //Passing reminders
        [(RemindersTableViewController *)[segue destinationViewController]
         getReminderList:reminderList];
        //Passing pin
        [(RemindersTableViewController *)[segue destinationViewController] getPinList:pinList];
    }
}


@end
