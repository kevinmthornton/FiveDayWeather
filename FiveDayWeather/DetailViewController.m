//
//  DetailViewController.m
//  FiveDayWeather
//
//  Created by kevin thornton on 2/20/14.
//  Copyright (c) 2014 kevin thornton. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

@synthesize weatherForToday = _weatherForToday;


#pragma mark - Managing the detail item


- (void)configureView {
    if (self.weatherForToday) {
        // set up all the labels
        // date of weather
        [self.dateLabel setText:[self.weatherForToday objectForKey:@"date"]];
        // now the image
        NSArray *imageArray = [self.weatherForToday objectForKey:@"weatherIconUrl"];
        NSDictionary *imageDict = imageArray[0];
        NSString *urlString = [NSString stringWithFormat:@"%@",[imageDict objectForKey:@"value"]];
        [self.weatherImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]]];
        
        // all the rest of the info
        NSArray *weatherDescArray = [self.weatherForToday objectForKey:@"weatherDesc"];
        NSDictionary *weatherDescDict = weatherDescArray[0];
        [self.weatherDesc setText:[weatherDescDict objectForKey:@"value"]];
        [self.highTemp setText:[self.weatherForToday objectForKey:@"tempMaxF"]];
        [self.lowTemp setText:[self.weatherForToday objectForKey:@"tempMinF"]];
        [self.windDirection setText:[self.weatherForToday objectForKey:@"winddirection"]];
        [self.windSpeed setText:[self.weatherForToday objectForKey:@"windspeedMiles"]];
    } else {
       [self.dateLabel setText:@"No data found"];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
