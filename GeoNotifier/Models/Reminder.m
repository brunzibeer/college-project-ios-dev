//
//  Reminder.m
//  GeoNotifier
//
//  Created by Mattia Bernardi on 02/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

//Initializer
- (instancetype) initWithName:(NSString *)reminderName andEnterMessage:(NSString *)enterMessage andExitMessage:(NSString *)exitMessage andRangeInMeters:(int)rangeInMeters andReminderLatitude:(float)reminderLatitude andReminderLongitude:(float)reminderLongitude {
    
    //Initializing a new reminder
    self = [super init];
    //If so
    if (self) {
        self.reminderName = reminderName;
        self.enterMessage = enterMessage;
        self.exitMessage = exitMessage;
        self.rangeInMeters = rangeInMeters;
        self.reminderLatitude = reminderLatitude;
        self.reminerLongitude = reminderLongitude;
    }
    
    return self;
}

//Converter
- (NSDictionary *)toJson {
    return @{
            @"name": self.reminderName,
            @"enter_message": self.enterMessage,
            @"exit_message": self.exitMessage,
            @"range": [NSNumber numberWithInt:self.rangeInMeters],
            @"latitude": [NSNumber numberWithFloat:self.reminderLatitude],
            @"longitude": [NSNumber numberWithFloat:self.reminerLongitude]
            };
}


@end
