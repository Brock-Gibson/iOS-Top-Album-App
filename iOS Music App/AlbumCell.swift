//
//  AlbumCell.swift
//  iOS Music App
//
//  Created by Brock Gibson on 10/7/18.
//  Copyright © 2018 Brock Gibson. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
    @IBOutlet weak var AlbumImage: UIImageView!
    @IBOutlet weak var AlbumName: UILabel!
    @IBOutlet weak var ArtistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
