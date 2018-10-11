//
//  Album.swift
//  iOS Music App
//
//  Created by Brock Gibson on 10/9/18.
//  Copyright © 2018 Brock Gibson. All rights reserved.
//

import UIKit

struct Album {
    var id: Int
    var name: String
    var artist: String
    var artwork: URL
    var explicit: Bool
    var date: String
    var favorite: Bool
}

func setAlbumImage(artwork: URL, imageView: UIImageView) {
    DispatchQueue.global(qos: .background).async {
        let imageData = try! Data(contentsOf: artwork)
        DispatchQueue.main.async {
            let image: UIImage = UIImage(data: imageData)!
            
            // how to update that specific cell?
            imageView.image = image
        }
    }
}
