//
//  GalleryViewController.swift
//  TestImageGallery
//
//  Created by Alexandr on 5/21/18.
//  Copyright © 2018 Alexandr Zhuk. All rights reserved.
//

import UIKit
import KRProgressHUD

class GalleryViewController: BaseViewController {

    @IBOutlet weak var itemsCollectioView: UICollectionView!
    
    let kAddImageSegue = "AddImageSegue"
    let kItemOffset: CGFloat = 20.0
    let kItemHeight: CGFloat = 150.0

    var items: [GalleryItemModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRightBarButtons(buttons: [self.createLogoutButton(), self.createAddButton(), self.createPlayButton()])
        let nib: UINib = UINib(nibName: GalleryCollectionViewCell.nibName, bundle: Bundle.main)
        self.itemsCollectioView.register(nib, forCellWithReuseIdentifier: GalleryCollectionViewCell.nibName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.doLoadImages()
    }

    func doLoadImages() {
        KRProgressHUD.show()
        APIManager.sharedManager.loadImages(completion: { [weak self] (results: Any?, error: NSError?) in
            KRProgressHUD.dismiss()
            if error != nil {
                self?.showError(msg: error?.localizedDescription)
                return
            }
            self?.items = results as! [GalleryItemModel]
            self?.itemsCollectioView.reloadData()
        })
    }

    func doLoadGIF() {
        KRProgressHUD.show()
        APIManager.sharedManager.loadGIF(params: [:], completion: { [weak self] (results: Any?, error: NSError?) in
            KRProgressHUD.dismiss()
            if error != nil {
                self?.showError(msg: error?.localizedDescription)
                return
            }
            self?.showPlayView(gifUrl: results as? String)
        })
    }

    func showPlayView(gifUrl: String?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playVC = storyboard.instantiateViewController(withIdentifier: "PlayPopupViewController") as! PlayPopupViewController
        playVC.gifUrl = gifUrl
        self.addChildViewController(playVC)
        playVC.view.frame = self.view.frame
        self.view.addSubview(playVC.view)
        playVC.didMove(toParentViewController: self)
    }

    override func logoutTapped(_ sender: UIButton) {
        APIManager.sharedManager.logout()
    }

    override func addTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: kAddImageSegue, sender: self)
    }

    override func playTapped(_ sender: UIButton) {
        self.doLoadGIF()
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.nibName, for: indexPath) as! GalleryCollectionViewCell
        cell.setup(with: self.items[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = (collectionView.bounds.size.width - kItemOffset * 3)/2
        return CGSize(width: itemWidth, height: kItemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kItemOffset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(kItemOffset, kItemOffset, kItemOffset, kItemOffset)
    }
}
