//
//  EditReminderTableViewController.m
//  GeoNotifier
//
//  Created by Mattia Bernardi on 02/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import "EditReminderTableViewController.h"
#import "RemindersTableViewController.h"
#import "EditableReminderNameTableViewCell.h"
#import "EditableReminderEnterMessageTableViewCell.h"
#import "EditablReminderExitMessageTableViewCell.h"
#import "EditableReminderRangeInMeterTableViewCell.h"
#import "SearchLocationViewController.h"
#import "SearchLocationViewController.h"



@interface EditReminderTableViewController ()

@end

@implementation EditReminderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%f | %f", pinTV.coordinate.latitude, pinTV.coordinate.longitude);
    
    numberOfSections = @[@"Reminder Name", @"Enter Message", @"Exit Message", @"Range in Meters", @"Location"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) setEditableReminder:(Reminder *)setEditableReminder {
    //Storing the reference
    editableReminder = setEditableReminder;
}

- (void) setEditablePinTV:(PinOnMap *)setEditablePin {
    //Storing the reference
    pinTV = setEditablePin;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numberOfSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Creating a generic adaptive cell
    UITableViewCell *adaptiveCell;
    
    switch (indexPath.section) {
        case 0: //REMINDER NAME
            //Setting the cell to be the reminder name
            adaptiveCell = [tableView dequeueReusableCellWithIdentifier:@"reminderNameCell" forIndexPath:indexPath];
            //Passing the reference
            [(EditableReminderNameTableViewCell *)adaptiveCell setEditableReminder:editableReminder];
            [(EditableReminderNameTableViewCell *)adaptiveCell setEdibalePin:pinTV];
            break;
        case 1: //ENTER MESSAGE
            //Setting the cell to be the reminder enter message
            adaptiveCell = [tableView dequeueReusableCellWithIdentifier:@"reminderEnterMessageCell" forIndexPath:indexPath];
            //Passing the reference
            [(EditableReminderEnterMessageTableViewCell *)adaptiveCell setEditableReminder:editableReminder];
            break;
        case 2: //EXIT MESSAGE
            //Setting the cell to be the reminder exit message
            adaptiveCell = [tableView dequeueReusableCellWithIdentifier:@"reminderExitMessageCell" forIndexPath:indexPath];
            //Passing the reference
            [(EditablReminderExitMessageTableViewCell *)adaptiveCell setEditableReminder:editableReminder];
            break;
        case 3: //RANGE IN METERS
            //Setting the cell to be the reminder range in meters
            adaptiveCell = [tableView dequeueReusableCellWithIdentifier:@"rangeInMeterCell" forIndexPath:indexPath];
            //Passing the reference
            [(EditableReminderRangeInMeterTableViewCell *)adaptiveCell setEditableReminder:editableReminder];
            break;
        case 4: //SEARCH LOCATION
            //Setting the cell to be the button to search the reminder location
            adaptiveCell = [tableView dequeueReusableCellWithIdentifier:@"setReminderLocation" forIndexPath:indexPath];
        default:
            break;
    }
    
    return adaptiveCell;
}

//Edit section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:numberOfSections[section], section];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass:[UITableViewCell class]]){
        //Towards search
        if ([segue.destinationViewController isKindOfClass:[SearchLocationViewController class]]) {
            //Passing both reminder and pin
            [(EditReminderTableViewController *)[segue destinationViewController] setEditableReminder:editableReminder];
            [(SearchLocationViewController *)[segue destinationViewController] setEditablePin:pinTV];
        }
    }
}


@end
