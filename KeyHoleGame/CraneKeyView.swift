//
//  CraneKeyView.swift
//  KeyHoleGame
//
//  Created by Mangesh Tekale on 6/25/19.
//  Copyright © 2019 Mangesh. All rights reserved.
//

import UIKit

class CraneKeyView: UIView {

    @IBOutlet weak var viewKey: UIImageView!
    @IBOutlet weak var imgHandleHook: UIImageView!
    @IBOutlet weak var viewKeyHandle: UIView!
    @IBOutlet weak var viewCraneRod: UIView!
    
    var positionOfCrane = 0
    var orginalFrameOfkey : CGRect!
    var secondsCount = 0
    var stopTheKeyView = true
    var timer: Timer?
    var keyTimer: Timer?
    var currentYKeyPosition: CGFloat = 0
    var isKeyGoingUp = false
    let viewKeyHeight: CGFloat = 17
    
    let initialHandleWidth: CGFloat = 30
    let extendedHandleWidth: CGFloat = 60
    let extended: CGFloat = 60

    var timerUpdatesBlock: ((Int)->())?
    var keyStoppedRectBlock: ((CGRect)->(Bool))?

    override func awakeFromNib() {
        super.awakeFromNib()
        moveTheCrane()
        orginalFrameOfkey = viewKey.frame
    }
    
    @objc func timerUpdates()  {
        secondsCount += 1
        timerUpdatesBlock?(secondsCount)
        if secondsCount >= 10 {
            stopTheKeyView = true
           // lblGameOn.text = "Game Over!!"
            timer?.invalidate()
            timer = nil
            
            stopTheViewKey()
        }
    }
    
    
    func playButtonTapped()  {
        viewKey.frame = orginalFrameOfkey
        secondsCount = 0
        stopTheKeyView = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdates), userInfo: nil, repeats: true)
        viewKeyHandle.frame = CGRect(x: viewKeyHandle.frame.origin.x, y: viewKeyHandle.frame.origin.y, width: initialHandleWidth, height: 2)

        moveTheKeyView()

    }
    
    func moveTheKeyView()  {
        if stopTheKeyView == false {
            keyTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] (timer) in
                self?.currentYKeyPosition = self?.viewKeyHandle.frame.origin.y ?? 0
                if let newFrame = self?.getNextFrame() {
                    self?.viewKeyHandle.frame = newFrame
                }
            })
        }
    }

    func getNextFrame() -> CGRect {
        let y = calculateYForKey()
        let frame = CGRect(x: viewKeyHandle.frame.origin.x, y: y, width: viewKeyHandle.frame.size.width, height: viewKeyHandle.frame.size.height)
        print(frame)
        return frame
    }
    
    func calculateYForKey() -> CGFloat {
        let bottomMargin: CGFloat =  frame.height - 25
        let topMargin: CGFloat = 10
        if isKeyGoingUp {
            currentYKeyPosition -= 2
            if currentYKeyPosition < topMargin {
                isKeyGoingUp = false
                currentYKeyPosition += 2
            }
        } else {
            currentYKeyPosition += 2
            if currentYKeyPosition > bottomMargin {
                currentYKeyPosition -= 2
                isKeyGoingUp = true
            }
        }
        print(currentYKeyPosition)
        return currentYKeyPosition
    }
    

    
    func checkWinStatusFor(view: UIView) -> Bool {
        //added 5 to take midpoint of image
        if (currentYKeyPosition + 5) > view.frame.origin.y {
            if currentYKeyPosition < (view.frame.origin.y +  (view.frame.size.height / 2)) {
                return true
            } else {
                return false
            }
        }
        return false
    }

    func stopTheViewKey()  {
        stopTheKeyView = true
        timer?.invalidate()
        keyTimer?.invalidate()
        let xForKeyView = viewKey.frame.origin.x + viewKeyHandle.frame.origin.x + viewCraneRod.frame.origin.x
        let yForKeyView =  viewKey.frame.origin.y + viewKeyHandle.frame.origin.y + viewCraneRod.frame.origin.y
        let status = keyStoppedRectBlock?(CGRect(x: xForKeyView, y: yForKeyView, width: viewKey.frame.size.width, height: viewKey.frame.size.height))
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.animateTheKey(xPosition: (self?.viewKey.frame.origin.x ?? 0) + 33)
        }

        if status ?? false {
            handleViewForWin()
        } else {
            print("You are lost!")
        }
    }

    func handleViewForWin()  {
        self.perform(#selector(rotateTheDown), with: nil, afterDelay: 0.5)
    }
    
    func animateTheKey(xPosition: CGFloat)  {
        viewKey.frame = CGRect(x: xPosition, y: viewKey.frame.origin.y, width:  viewKey.frame.size.width, height:  viewKey .frame.size.height)
        viewKeyHandle.frame = CGRect(x: -5, y: viewKeyHandle.frame.origin.y, width: extendedHandleWidth, height: 2)
    }

    var rotateCount = 0
    @objc func rotateTheUp()  {
        UIView.transition(with: viewKey, duration: 0.2, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: nil) { (success) in
            if self.rotateCount < 5 {
                self.rotateCount += 1
                self.rotateTheDown()
            } else {
                self.rotateCount = 0
            }
        }
    }
    
    @objc func rotateTheDown()  {
        UIView.transition(with: viewKey, duration: 0.2, options: UIView.AnimationOptions.transitionFlipFromRight, animations: nil) { (success) in
            if self.rotateCount < 5 {
                self.rotateCount += 1
                self.rotateTheUp()
            } else {
                self.rotateCount = 0
            }
        }
    }
    
    
    let viewKeyWidth: CGFloat = 9


    func moveTheCrane()  {
        let widhtForCV = frame.size.width - 20
        let actualWidth = widhtForCV / 3
        let heightForCrane = self.bounds.height - 15

        let xForCrane = (CGFloat(positionOfCrane) * actualWidth) + (10 * CGFloat(positionOfCrane))
        viewCraneRod.frame = CGRect(x: xForCrane, y: 0, width: 5, height: heightForCrane)
        imgHandleHook.frame = CGRect(x: 5, y: -3, width: 5, height: 5)
        viewCraneRod.clipsToBounds = false
        viewKeyHandle.frame = CGRect(x: -5, y: 50, width: initialHandleWidth, height: 2)
        viewKeyHandle.backgroundColor = UIColor(red:1, green: 102.0/255.0, blue: 0, alpha: 1)
        viewKeyHandle.clipsToBounds = false
        viewKey.frame = CGRect(x: 30, y: -13, width: viewKeyWidth, height: viewKeyHeight)

    }
    
}
