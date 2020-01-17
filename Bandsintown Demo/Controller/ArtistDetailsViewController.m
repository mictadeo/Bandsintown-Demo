//
//  ArtistDetailsViewController.m
//  Bandsintown Demo
//
//  Created by Michael Tadeo on 1/16/20.
//  Copyright © 2020 Tadeo Man. All rights reserved.
//

#import "ArtistDetailsViewController.h"

@interface ArtistDetailsViewController ()

@end

@implementation ArtistDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.artistImage.image = self.passImage;
    self.artistName.text = self.passName;
    self.trackerCount.text = self.passTrackerCount;
    self.upcomingEvent.text = self.passUpcomingEvent;
         
}

@end
