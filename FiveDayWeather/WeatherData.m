//
//  WeatherData.m
//  FiveDayWeather
//
//  Created by kevin thornton on 2/20/14.
//  Copyright (c) 2014 kevin thornton. All rights reserved.
//

#import "WeatherData.h"

// category for adding to the NSDictionary class
@interface NSDictionary(JSONCategories)

+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;

@end

@implementation NSDictionary(JSONCategories)

// gets an NSString with a web address
// does all the downloading, fetching, parsing and whatnot then returns an instance of a dictionary
+(NSDictionary*)dictionaryWithContentsOfJSONURLString: (NSString*)urlAddress {
    
    /* check status
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]];
    NSURLResponse *response = nil;
    __autoreleasing NSError* error = nil;
    NSData *data=[[NSData alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]];
    NSString* retVal = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // you can use retVal , ignore if you don't need.
    NSInteger httpStatus = [((NSHTTPURLResponse *)response) statusCode];
    NSLog(@"responsecode:%d", httpStatus);
    NSString *stringJSON = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlAddress] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"stringJSON: %@", stringJSON);
     */
    
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: urlAddress] ];
    
    if (data) {
        __autoreleasing NSError* error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error != nil) return nil;
        return result;
    } else {
        NSLog(@"NO DATA");
        return nil;
    }
}

// to use this, you would
// NSDictionary *myInfo = [NSDictionary dictionaryWithContentsOfJSONURLString:YOUR_URL];
// now myInfo is a parsed dicitonary of JSON data

@end

@implementation WeatherData

// class method to return the array of from the zip code passed in
+(NSArray *)fetchWeatherData:(NSString *)zipCode {
    NSDictionary *allWeatherData = [[NSDictionary alloc] init];
    NSArray *returnedWeatherArray = [[NSArray alloc] init];
    
    // build up the URL with paramaters
    // EX: http://api.worldweatheronline.com/free/v1/weather.ashx?format=json&num_of_days=5&key=hrzmceph6pvt2yfupey6y9ef&q=97035
    NSString *format = @"json";
    NSString *numDays = @"5"; // this will only work with 5, not 7 days
    NSString *myAPIKey = @"hrzmceph6pvt2yfupey6y9ef";
    NSString *urlString = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?format=%@&num_of_days=%@&key=%@&q=%@", format, numDays, myAPIKey, zipCode];
    
    // this grabs everything but, we want to parse data > weather
    allWeatherData = [NSDictionary dictionaryWithContentsOfJSONURLString:urlString];
    allWeatherData = [allWeatherData objectForKey:@"data"];
    // we just want the weather portion
    returnedWeatherArray = [allWeatherData objectForKey:@"weather"];

    return returnedWeatherArray;
}

@end





























