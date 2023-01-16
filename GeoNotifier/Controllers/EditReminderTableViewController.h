//
//  EditReminderTableViewController.h
//  GeoNotifier
//
//  Created by Mattia Bernardi on 02/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"
#import "MapAnnotation.h"
#import "PinOnMap.h"


NS_ASSUME_NONNULL_BEGIN

@interface EditReminderTableViewController : UITableViewController {
    
    Reminder *editableReminder;
    PinOnMap *pinTV;
    PinOnMap *pin;
    NSMutableArray<PinOnMap *> *editablePin;
    IBOutlet UITableView *editReminderTable;
    NSArray *numberOfSections;
}

@property (nonatomic, strong) MapAnnotation *mapAnnotationTableView;

- (void) setEditableReminder:(Reminder *)setEditableReminder;
- (void) setEditablePinTV:(PinOnMap *)setEditablePin;

@end

NS_ASSUME_NONNULL_END
