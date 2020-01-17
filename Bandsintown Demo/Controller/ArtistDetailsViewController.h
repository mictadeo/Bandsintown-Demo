//
//  ArtistDetailsViewController.h
//  Bandsintown Demo
//
//  Created by Michael Tadeo on 1/16/20.
//  Copyright © 2020 Tadeo Man. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArtistDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *trackerCount;
@property (weak, nonatomic) IBOutlet UILabel *upcomingEvent;

@property (strong, nonatomic) NSString* passName;
@property (strong, nonatomic) NSString* passTrackerCount;
@property (strong, nonatomic) NSString* passUpcomingEvent;
@property (strong, nonatomic) UIImage* passImage;


@end

NS_ASSUME_NONNULL_END
