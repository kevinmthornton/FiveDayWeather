//
//  MasterViewController.h
//  FiveDayWeather
//
//  Created by kevin thornton on 2/20/14.
//  Copyright (c) 2014 kevin thornton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherData;

@interface MasterViewController : UITableViewController <UITextFieldDelegate>

@property(nonatomic, strong) NSArray *weatherArray;
@property(nonatomic, strong) UITextField *zipCodeField;

// method for upper right button
-(void)retrieveWeatherData;

@end
