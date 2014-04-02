//
//  MasterViewController.m
//  FiveDayWeather
//
//  Created by kevin thornton on 2/20/14.
//  Copyright (c) 2014 kevin thornton. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "WeatherData.h"


@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize zipCodeField = _zipCodeField;
@synthesize weatherArray = _weatherArray;

-(void) retrieveWeatherData {
    
    // hide the keyboard
    [self.zipCodeField resignFirstResponder];
    
    // grab the zip code from the text field
    NSString *zipCode = self.zipCodeField.text;
    
    // is the zip code valid?
    NSString *zipcodeExpression = @"^[0-9]{5}?$"; //U.S Zip ONLY!!!
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:zipcodeExpression options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:zipCode options:0 range:NSMakeRange(0, [zipCode length])];
    
    if (match) {
        // check to see if we have this zip code cached if so, load from cache file. if not, write to the cache file this zip and data
        NSString *jsonFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",zipCode]];
    
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSDictionary* attrs = [fileManager attributesOfItemAtPath:jsonFilePath error:nil];
    
        if (attrs != nil) {
            // this file is present so, check date against current time to see if it is over 1/2 hour old
            NSDate *fileDate = (NSDate*)[attrs objectForKey: NSFileCreationDate];
            
            NSDate * now = [NSDate date];
            NSTimeInterval halfHourFromNow = 30 * 60;
            NSDate *fileDateHalfHourAdded = [fileDate dateByAddingTimeInterval:halfHourFromNow];
            
            // compare two dates
            NSComparisonResult result;
            result = [now compare:fileDateHalfHourAdded];
            
            if(result==NSOrderedDescending) {
                // file is old, get data again
                self.weatherArray = [WeatherData fetchWeatherData:zipCode];
                // delete the file and start again
                __autoreleasing NSError* error = nil;
                BOOL success = [fileManager removeItemAtPath:jsonFilePath error:&error];
                if (success) {
                    [self.weatherArray writeToFile:jsonFilePath atomically: NO];
                } else {
                    NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                }
            
            } else if(result==NSOrderedAscending) {
                // file is less than half hour old, use it for weather data
                self.weatherArray = [NSArray arrayWithContentsOfFile:jsonFilePath];
            }
        } else {
            // 404 so write to file
            self.weatherArray = [WeatherData fetchWeatherData:zipCode];
            [self.weatherArray writeToFile:jsonFilePath atomically: NO];
        }
    
        // fill the table with data
        [self.tableView reloadData];
        
    } else {
        // zip code was not valid
        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Error:" message:@"Please enter a valid zip code" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removeSuccessFulAlert show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // assign the vars to defaults
    self.weatherArray = [[NSArray alloc] init];
    
    // set up my zip code field at the top
    self.zipCodeField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 150, 30)];
    [self.zipCodeField setText:@"Enter Zip"];
    [self.zipCodeField setBackgroundColor:[UIColor grayColor]];
    [self.zipCodeField setDelegate:self]; // so we can clear out "Enter Zip"
    
    [self.navigationController setTitle:@""];
    UIBarButtonItem *getWeatherButton = [[UIBarButtonItem alloc] initWithTitle:@"Get Weather" style:UIBarButtonItemStylePlain target:self action:@selector(retrieveWeatherData)];
    [self.navigationItem setRightBarButtonItem:getWeatherButton];
}

// this is taken out in prepare for segue so that the back button can be shown;
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar addSubview:self.zipCodeField];
}

// clear out the text field's default text
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = nil;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weatherArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // self.weatherArray is an array of dictionary values; this is the current one
    NSDictionary *currentDict = self.weatherArray[indexPath.row];
    
    // turn the date string into a date so we can format it
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *arrayDate = [theDateFormatter dateFromString:[currentDict objectForKey:@"date"]];
    
    // get the day of the week from the date passed in
    NSDateFormatter* theDayFormatter = [[NSDateFormatter alloc] init];
    [theDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDayFormatter setDateFormat:@"EEEE"];
    NSString *weekDay =  [theDayFormatter stringFromDate:arrayDate];
    cell.textLabel.text = weekDay;
    
    // now the image
    NSArray *imageArray = [currentDict objectForKey:@"weatherIconUrl"];
    NSDictionary *imageDict = imageArray[0];
    
    NSString *urlString = [NSString stringWithFormat:@"%@",[imageDict objectForKey:@"value"]];
    
    // OK, I know I am supposed to run this asyncronously with some caching but, this is a small bit of data and I am pressed for time :)
    [cell.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]]];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// since we have a storyboard, we are using this segue instead of didSelectRow...
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.zipCodeField removeFromSuperview];
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *currentDict = self.weatherArray[indexPath.row];
        [[segue destinationViewController] setWeatherForToday:currentDict];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
