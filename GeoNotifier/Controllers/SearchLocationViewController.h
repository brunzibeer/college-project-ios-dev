//
//  SearchLocationViewController.h
//  GeoNotifier
//
//  Created by Mattia Bernardi on 04/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Reminder.h"
#import "PinOnMap.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchLocationViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MKLocalSearchCompleterDelegate> {
    
    PinOnMap *editablePin;
    Reminder *editableReminder;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *locationTable;

- (void) setEditableReminder:(Reminder *)setEditableReminder;
- (void) setEditablePin:(PinOnMap *)setEditablePin;

@end

NS_ASSUME_NONNULL_END
