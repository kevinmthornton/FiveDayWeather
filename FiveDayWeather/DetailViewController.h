//
//  DetailViewController.h
//  FiveDayWeather
//
//  Created by kevin thornton on 2/20/14.
//  Copyright (c) 2014 kevin thornton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
