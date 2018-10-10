//
//  AlbumDetailViewController.swift
//  iOS Music App
//
//  Created by Brock Gibson on 10/7/18.
//  Copyright © 2018 Brock Gibson. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {

    @IBOutlet weak var DetailTitle: UINavigationItem!
    @IBOutlet weak var DescLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var Explicit: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    var getAlbumName: String?
    var getArtistName: String?
    var getAlbumArtwork: UIImage?
    var getExplicit: String?
    var getDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        DetailTitle.title = "Album Info"
        DescLabel.text = getAlbumName! + "  " + getExplicit!
        artistLabel.text = getArtistName
        albumArtwork.image = getAlbumArtwork
        releaseDate.text = "Release Date: " + getDate!
    }
}
