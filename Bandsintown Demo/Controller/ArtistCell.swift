//
//  ArtistCell.swift
//  Bandsintown Demo
//
//  Created by Michael Tadeo on 1/15/20.
//  Copyright © 2020 Tadeo Man. All rights reserved.
//

import UIKit

class ArtistCell: UITableViewCell {
  
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
  
    var delegate: ArtistCellDelegate?
    
    @IBAction func handleTappedFavoriteButton(_ sender: Any) {
        delegate?.favoriteButtonTapped(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//Encircle artist image
        artistImage.layer.cornerRadius = artistImage.frame.size.width / 2;
        artistImage.clipsToBounds = true;
    }
}

protocol ArtistCellDelegate {

//Add functions for the view controller
    func favoriteButtonTapped(cell: UITableViewCell)
}
