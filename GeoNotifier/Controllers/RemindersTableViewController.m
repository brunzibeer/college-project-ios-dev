//
//  RemindersTableViewController.m
//  GeoNotifier
//
//  Created by Mattia Bernardi on 02/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import "RemindersTableViewController.h"
#import "Reminder.h"
#import "EditReminderTableViewController.h"

@interface RemindersTableViewController ()

@end

@implementation RemindersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Deselecting the row
    [reminderTable deselectRowAtIndexPath:[reminderTable indexPathForSelectedRow] animated:YES];
    //Reload the table data
    [reminderTable reloadData];
}

//Getting the reminder list
- (void) getReminderList:(NSMutableArray *)list {
    reminderList = list;
}

//Gettinf the pin list
- (void) getPinList:(NSMutableArray *)list {
    pinList = list;
}

//Creating a new reminder
- (Reminder *) createNewReminder {
    //Using the custom initializer
    return [[Reminder alloc] initWithName:@"" andEnterMessage:@"" andExitMessage:@"" andRangeInMeters:0 andReminderLatitude:0 andReminderLongitude:0];
}

//Creating a new pin
- (PinOnMap *) createNewPin {
    return [[PinOnMap alloc] init];
}

//Adding the new reminder to the list
- (IBAction)addReminder:(id)sender {
    //Calling the method to create a new reminder
    Reminder *newReminder = [self createNewReminder];
    PinOnMap *newPin = [self createNewPin];
    //Adding the reminder to the list
    [reminderList addObject:newReminder];
    [pinList addObject:newPin];
    NSLog(@"Number of Reminders: %lu", reminderList.count);
    //Refreshing the list
    [reminderTable reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return reminderList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //Getting the object at index
    Reminder *reminder = [reminderList objectAtIndex:indexPath.row];
    //If the object is brand new
    if ([reminder.reminderName isEqualToString:@""]) {
        cell.textLabel.text = @"Edit me!";
    //If the object is alredy edited
    } else {
        cell.textLabel.text = reminder.reminderName;
    }
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [reminderList removeObjectAtIndex:indexPath.row];
        [pinList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Working with JSON and Files
- (NSString *)convertToJson {
    //SOURCE: https://stackoverflow.com/questions/51224184/ios-objective-c-convert-nsarray-of-custom-objects-to-json
    //First of all I need to check that both messages field are not empty at the same time, otherwise i delete the reminder
    for (int i = 0; i < reminderList.count; i++) {
        Reminder *temp = [reminderList objectAtIndex:i];
        if ([temp.enterMessage isEqualToString:@""] && [temp.exitMessage isEqualToString:@""]) {
            [reminderList removeObjectAtIndex:i];
            [pinList removeObjectAtIndex:i];
            //Decrementing i because I'll have one less object
            i--;
        }
    }
    //After I need to: Dictionary -> Json -> File
    NSMutableArray<NSDictionary *> *jsonReminders = [NSMutableArray array];
    for (Reminder *reminder in reminderList) {
        [jsonReminders addObject:[reminder toJson]];
    }
    //Catching error and result
    NSError *error;
    NSString *result;
    
    if ([NSJSONSerialization isValidJSONObject:jsonReminders]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:jsonReminders options:0 error:&error];
        //Decoding in UTF-8
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    //Passing the string to be written on the file
    [self writeStringToFile:result];
    return result;
}

- (void)writeStringToFile:(NSString *)stringToWrite {
    //Retrieving file
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"reminderList.json"];
    //Writing
    [stringToWrite writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
}

#pragma mark - Saving to File
- (IBAction)saveToFile:(id)sender {
    //Calling the method to export as JSON
    [self convertToJson];
    [self showSaveAlert];
}

#pragma mark - Alerts
- (void)showSaveAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SAVED!" message:@"Reminder list has been saved to file" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showExportAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"EXPORTED!" message:@"Reminder list has been exported to CSV file" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showImportAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"IMPORTED!" message:@"Reminder list has been imported from CSV file" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showFileNotExistsAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"FILE NOT FOUND!" message:@"No CSV file to be imported" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Import/Export in CSV
- (IBAction)exportToCSV:(id)sender {
    //Retrieving the file
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"reminders.csv"];
    //Checking if the file already exists, if not, create it
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    //String with the data to write (Initialli 0 but it will expand)
    NSMutableString *stringToWrite = [NSMutableString stringWithCapacity:0];
    //Appending info to the string
    for (int i = 0; i < [reminderList count]; i++) {
        //Getting values
        NSString *name = [reminderList objectAtIndex:i].reminderName;
        NSString *enterMessage = [reminderList objectAtIndex:i].enterMessage;
        NSString *exitMessage = [reminderList objectAtIndex:i].exitMessage;
        int range = [reminderList objectAtIndex:i].rangeInMeters;
        float latitute = [reminderList objectAtIndex:i].reminderLatitude;
        float longitude = [reminderList objectAtIndex:i].reminerLongitude;
        //Appending
        [stringToWrite appendString:[NSString stringWithFormat:@"%@,%@,%@,%d,%f,%f\n", name, enterMessage, exitMessage, range, latitute, longitude]];
    }
    //Writing the string
    [stringToWrite writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
    //Showing alert
    [self showExportAlert];
}

- (IBAction)importFromCSV:(id)sender {
    //Retrieving the file
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"reminders.csv"];
    //Need to check if the file exists or not
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //Reading the string
        NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        //Retrieve # of rows -> # of reminders
        NSArray *row = [str componentsSeparatedByString:@"\n"];
        
        //Clearing the reminder and pin list so I can fill it back up again
        [reminderList removeAllObjects];
        [pinList removeAllObjects];
        
        //Starting recreating both lists
        for (int i = 0; i < [row count] - 1; i++) {
            //Identifing the row
            NSString *currentRow = [row objectAtIndex:i];
            //Getting values
            NSArray *rowValues = [currentRow componentsSeparatedByString:@","];
            
            //Creating the reminder
            Reminder *newReminder = [[Reminder alloc] initWithName:[rowValues objectAtIndex:0] andEnterMessage:[rowValues objectAtIndex:1] andExitMessage:[rowValues objectAtIndex:2] andRangeInMeters:[[rowValues objectAtIndex:3] intValue] andReminderLatitude:[[rowValues objectAtIndex:4] floatValue] andReminderLongitude:[[rowValues objectAtIndex:5] floatValue]];
            
            //Creating the Pin
            PinOnMap *newPin = [[PinOnMap alloc] init];
            CLLocationCoordinate2D newLocation;
            newPin.associatedReminderName = newReminder.reminderName;
            newLocation.latitude = newReminder.reminderLatitude;
            newLocation.longitude = newReminder.reminerLongitude;
            newPin.coordinate = newLocation;
            
            //Adding both the the list
            [reminderList addObject:newReminder];
            [pinList addObject:newPin];
        }
        //Reload tableView
        [reminderTable reloadData];
        //Showing Alert
        [self showImportAlert];
    }
    else {
        //Showing filenotfoundalert
        [self showFileNotExistsAlert];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Checking that the transition is towards edit reminder
    if ([segue.identifier isEqualToString:@"editReminderSegue"]) {
        Reminder *selectedReminder = [reminderList objectAtIndex:[reminderTable indexPathForSelectedRow].row];
        PinOnMap *selectedPin = [pinList objectAtIndex:[reminderTable indexPathForSelectedRow].row];
        
        [(EditReminderTableViewController *)[segue destinationViewController] setEditableReminder:selectedReminder];
        [(EditReminderTableViewController *)[segue destinationViewController] setEditablePinTV:selectedPin];
    }
}

@end
