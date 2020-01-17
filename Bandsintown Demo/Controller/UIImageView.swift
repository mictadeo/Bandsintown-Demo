//
//  UIImageView.swift
//  Bandsintown Demo
//
//  Created by Michael Tadeo on 1/15/20.
//  Copyright © 2020 Tadeo Man. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()


@objc extension UIImageView {

    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if URLString == ""{
            DispatchQueue.main.async {
                self.image = placeHolder
            }
            return
        }

        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("Error loading images")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
