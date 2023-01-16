//
//  EditableReminderEnterMessageTableViewCell.m
//  GeoNotifier
//
//  Created by Mattia Bernardi on 03/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import "EditableReminderEnterMessageTableViewCell.h"

@implementation EditableReminderEnterMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setEditableReminder:(Reminder *)setEditableReminder{
    //Getting the reference
    editableReminder = setEditableReminder;
    //TextField configuration
    textField.text = editableReminder.enterMessage;
    //Calling TextField did change on text change
    [textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void) textFieldDidChange {
    //Updating the name with the new text in the textfield
    editableReminder.enterMessage = textField.text;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
