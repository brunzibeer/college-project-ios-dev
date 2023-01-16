//
//  SearchLocationViewController.m
//  GeoNotifier
//
//  Created by Mattia Bernardi on 04/03/2020.
//  Copyright © 2020 Mattia Bernardi. All rights reserved.
//

#import "SearchLocationViewController.h"
#import "EditReminderTableViewController.h"
#import "ShowLocationOnMapViewController.h"


@interface SearchLocationViewController () <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, MKLocalSearchCompleterDelegate> {
    MKLocalSearchCompleter *searchCompleter;
}

@end

@implementation SearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Setting up the delegates
    searchCompleter = [[MKLocalSearchCompleter alloc] init];
    searchCompleter.delegate = self;
    self.searchBar.delegate = self;
    self.locationTable.delegate = self;
}

//Getting the references
- (void) setEditablePin:(PinOnMap *)setEditablePin {
    editablePin = setEditablePin;
}

- (void) setEditableReminder:(Reminder *)setEditableReminder {
    editableReminder = setEditableReminder;
}
#pragma mark - SearchBar Delegate Methods
//Search bar delegate method
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchCompleter.queryFragment = searchText;
}

//Method extension
- (void) completerDidUpdateResults:(MKLocalSearchCompleter *)completer {
    for (MKLocalSearchCompletion *completion in completer.results) {
        NSLog(@"----- %@", completion.subtitle);
    }
    [self.locationTable reloadData];
}

//Error method
- (void) completer:(MKLocalSearchCompleter *)completer didFailWithError:(NSError *)error {
    NSLog(@"----- %@", error);
}

#pragma mark - TableView Delegate Methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchCompleter.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *IDENTIFIER = @"searchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
    }
    
    //Addres
    cell.textLabel.text = searchCompleter.results[indexPath.row].title;
    cell.detailTextLabel.text = searchCompleter.results[indexPath.row].subtitle;

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Getting the address with MKLocalSearchCompleter, MKLocalSearchRequest for the coordinates
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] initWithCompletion:searchCompleter.results[indexPath.row]];
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count > 0) {
            for (MKMapItem *item in [response mapItems]) {
                CLLocationCoordinate2D mapCoordinate;
                mapCoordinate.latitude = item.placemark.coordinate.latitude;
                mapCoordinate.longitude = item.placemark.coordinate.longitude;
                self->editablePin.coordinate = mapCoordinate;
                NSLog(@"%f | %f", self->editablePin.coordinate.latitude, self->editablePin.coordinate.longitude);
                
                [self performSegueWithIdentifier:@"showLocationOnMapSegue" sender:self];
                
                
            }
        }
    }];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showLocationOnMapSegue"]) {
        //Passing both reminder and pin
        [(EditReminderTableViewController *)[segue destinationViewController] setEditableReminder:editableReminder];
        [(ShowLocationOnMapViewController *)[segue destinationViewController] setEditablePin:editablePin];
    }
}

@end
