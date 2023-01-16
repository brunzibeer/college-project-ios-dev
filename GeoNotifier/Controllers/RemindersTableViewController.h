//
//  RemindersTableViewController.h
//  GeoNotifier
//
//  Created by Mattia Bernardi on 02/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"
#import "PinOnMap.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemindersTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *reminderTable;
    NSMutableArray<Reminder *> *reminderList;
    NSMutableArray<PinOnMap *> *pinList;
    NSString *filePath;
    
}

//METHODS
- (void)getReminderList:(NSMutableArray *)list;
- (void)getPinList:(NSMutableArray *)list;

@end

NS_ASSUME_NONNULL_END
