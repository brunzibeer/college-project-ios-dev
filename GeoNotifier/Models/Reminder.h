//
//  Reminder.h
//  GeoNotifier
//
//  Created by Mattia Bernardi on 02/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Reminder : NSObject

//PROPERTIES
@property (nonatomic, strong) NSString *reminderName;
@property (nonatomic, strong) NSString *enterMessage;
@property (nonatomic, strong) NSString *exitMessage;
@property (nonatomic) int rangeInMeters;
@property (nonatomic) float reminderLatitude;
@property (nonatomic) float reminerLongitude;

//Initializer
- (instancetype)initWithName:(NSString *)reminderName
             andEnterMessage:(NSString *)enterMessage
              andExitMessage:(NSString *)exitMessage
            andRangeInMeters:(int)rangeInMeters
         andReminderLatitude:(float)reminderLatitude
        andReminderLongitude:(float)reminderLongitude;

- (NSDictionary *)toJson;

@end

NS_ASSUME_NONNULL_END
