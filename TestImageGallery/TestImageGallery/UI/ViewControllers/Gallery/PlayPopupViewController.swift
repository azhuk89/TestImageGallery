//
//  PlayPopupViewController.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/23/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import SDWebImage

class PlayPopupViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var gifImageView: FLAnimatedImageView!

    var gifUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.addBorder()
        self.showAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func playGIF() {
        if let urlStr = self.gifUrl {
            let url = URL(string: urlStr)!
            let data = NSData(contentsOf: url)!
            let image = FLAnimatedImage(animatedGIFData: data as Data!)
            self.gifImageView.animatedImage = image
        }
    }

    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion:{(finished : Bool)  in
            if (finished) {
                self.playGIF()
            }
        })
    }

    func removeAnimate() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }



    @IBAction func closeTapped(_ sender: Any) {
        self.removeAnimate()
    }
}
