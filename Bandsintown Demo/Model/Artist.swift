//
//  ArtistDataModel.swift
//  Bandsintown Demo
//
//  Created by Michael Tadeo on 1/15/20.
//  Copyright © 2020 Tadeo Man. All rights reserved.
//

import Foundation

class Artist {
    
    var artistImage: String
    var artistName: String
    var artistId: String
    var trackerCount: String
    var favoriteSelected : Bool = false
    
    init(artistImage: String, artistName: String, artistId: String, trackerCount: String) {
        self.artistImage = artistImage
        self.artistName = artistName
        self.artistId = artistId
        self.trackerCount = trackerCount
    }
}

