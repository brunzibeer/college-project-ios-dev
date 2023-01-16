//
//  EditableReminderNameTableViewCell.m
//  GeoNotifier
//
//  Created by Mattia Bernardi on 03/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import "EditableReminderNameTableViewCell.h"

@implementation EditableReminderNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setEdibalePin:(PinOnMap *)setEditablePin {
    editablePin = setEditablePin;
}

- (void) setEditableReminder:(Reminder *)setEditableReminder {
    //Getting the reference
    editableReminder = setEditableReminder;
    //TextField configuration
    textField.text = editableReminder.reminderName;
    editablePin.associatedReminderName = editableReminder.reminderName;
    //Calling TextField did change on text change
    [textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void) textFieldDidChange {
    //Updating the name with the new text in the textfield
    editableReminder.reminderName = textField.text;
    editablePin.associatedReminderName = editableReminder.reminderName;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
