//
//  GalleryCollectionViewCell.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/23/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import SDWebImage

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addBorder()
    }

    func setup(with item: GalleryItemModel) {
        if let urlStr = item.smallImageUrl {
            let url = URL(string: urlStr)!
            let placeholder = UIImage(named: "image-placeholder")
            self.imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [])
        }
        self.weatherLabel.text = item.weather ?? ""
        self.locationLabel.text = item.address ?? ""
    }
}
