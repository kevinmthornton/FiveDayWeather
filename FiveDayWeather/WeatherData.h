//
//  WeatherData.h
//  FiveDayWeather
//
//  Created by kevin thornton on 2/20/14.
//  Copyright (c) 2014 kevin thornton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject

// go our and get weather data with passed zip code and return array
+(NSArray *)fetchWeatherData:(NSString *)zipCode;


@end
