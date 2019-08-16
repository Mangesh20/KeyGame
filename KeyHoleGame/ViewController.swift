//
//  ViewController.swift
//  KeyHoleGame
//
//  Created by Mangesh Tekale on 6/14/19.
//  Copyright © 2019 Mangesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblGameOn: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var viewContainer: CraneKeyView!
    @IBOutlet weak var collectionViewForGame: UICollectionView!
    var stopTheKeyView = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionViewForGame.register(UINib(nibName: "GameProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GameProductCollectionViewCell")
        viewContainer.timerUpdatesBlock = { (seconds) in
            self.lblTimer.text = "\(seconds)"
        }
        
        viewContainer.keyStoppedRectBlock = { [weak self] (rect) in
            var status = false
            let heightForCV = (self?.collectionViewForGame.frame.size.height ?? 0) - 30
            let actualHeight = heightForCV / 4 + 5
            for idx in 0...3 {
                let yMinForKey = (actualHeight * CGFloat(idx)) + 15
                let yMaxForKey = yMinForKey + 20
                print("Min y", yMinForKey,"key y", rect.origin.y,"Max y", yMaxForKey)
                if rect.origin.y >= yMinForKey && (rect.origin.y + rect.size.height) <= yMaxForKey {
                    status = true
                    break
                }
            }
            return status
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        if self.viewContainer.positionOfCrane > 0 {
            self.viewContainer.positionOfCrane -= 1
        }
        UIView.animate(withDuration: 1) {
            self.viewContainer.moveTheCrane()
        }
    }
    
    @IBAction func btnForwardTapped(_ sender: Any) {
        if self.viewContainer.positionOfCrane < 2 {
            self.viewContainer.positionOfCrane += 1
        }
        UIView.animate(withDuration: 1) {
            self.viewContainer.moveTheCrane()
        }
    }

    @IBAction func btnPlayTapped(_ sender: Any) {
        if stopTheKeyView == false {
            return
        }
        viewContainer.playButtonTapped()
    }
    
    @IBAction func btnStopTapped(_ sender: Any) {
          viewContainer.stopTheViewKey()
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameProductCollectionViewCell", for: indexPath) as? GameProductCollectionViewCell
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightForCV = collectionViewForGame.frame.size.height - 30
        let widhtForCV = collectionViewForGame.frame.size.width - 20
        let actualHeight = heightForCV / 4
        let actualWidth = widhtForCV / 3
        return CGSize(width: actualWidth, height: actualHeight )
    }
}
