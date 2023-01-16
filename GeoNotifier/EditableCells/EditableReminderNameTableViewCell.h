//
//  EditableReminderNameTableViewCell.h
//  GeoNotifier
//
//  Created by Mattia Bernardi on 03/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"
#import "PinOnMap.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditableReminderNameTableViewCell : UITableViewCell <UITextFieldDelegate> {
    
    Reminder *editableReminder;
    PinOnMap *editablePin;
    IBOutlet UITextField *textField;
    
}

- (void) setEditableReminder:(Reminder *)setEditableReminder;
- (void) setEdibalePin:(PinOnMap *)setEditablePin;

@end

NS_ASSUME_NONNULL_END
