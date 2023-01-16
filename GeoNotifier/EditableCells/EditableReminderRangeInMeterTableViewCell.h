//
//  EditableReminderRangeInMeterTableViewCell.h
//  GeoNotifier
//
//  Created by Mattia Bernardi on 03/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditableReminderRangeInMeterTableViewCell : UITableViewCell <UITextFieldDelegate> {
    
    Reminder *editableReminder;
    IBOutlet UITextField *textField;
}

- (void) setEditableReminder:(Reminder *)setEditableReminder;

@end

NS_ASSUME_NONNULL_END
