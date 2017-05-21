//
//  ViewController.swift
//  Understanding Touch Gestures
//
//  Created by Rey Cerio on 2017-05-16.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let numberViewPerRow = 15
    
    var cells = [String: UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.frame.width / CGFloat(numberViewPerRow)

        
        for j in 0...30 {
            for i in 0...numberViewPerRow {
                let cellView = UIView()
                cellView.backgroundColor = randomColor()
                cellView.layer.borderWidth = 0.5
                cellView.layer.borderColor = UIColor.black.cgColor
                //i * 100 is the position of the x in the box. 100 so the it lands where the last box ended
                cellView.frame = CGRect(x: CGFloat(i) * width, y: CGFloat(j) * width, width: width, height: width)
                view.addSubview(cellView)
                
                //assigning a key or tag to the cells
                let key = "\(i)|\(j)"
                cells[key] = cellView
                
            }

        }
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
    }
    
    var selectedCell: UIView?

    
    func handlePan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        print(location)
        
        
        //this is a better solution but apparently, using an array instead because we already have a numberViewPerRow that we can assign as the tag is more memory efficient because were building another set of variable when something already exists...
        let width = view.frame.width / CGFloat(numberViewPerRow)
        
        let i = Int(location.x / width)
        let j = Int(location.y / width)
        
        let key = "\(i)|\(j)"
        guard let cellView = cells[key] else {return}
        
        //shrink the selectedCell when youre not touching it with animation
        if selectedCell != cellView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                self.selectedCell?.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
        
        //selected cell = touched cell
        selectedCell = cellView
        
        //bring the touched view to the front
        view.bringSubview(toFront: cellView)
        
        //zoom in cell when youre touching it. with animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            //changes the size to 3x
            cellView.layer.transform = CATransform3DMakeScale(3, 3, 3)
        }, completion: nil)
        
        //shrinking cell when touch ended
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.selectedCell?.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
        
        //not the effecient way because each touch will fire the loop as many times as the area of the square ie. the lowest part of a 30x30 will fire the loop 900times per touch. too heavy on the cpu. So to solve this we figure out the location in regards to x and y location base on width.
        
//        var loopCount = 0
//        for subView in view.subviews {
//            
//            if subView.frame.contains(location) {
//                subView.backgroundColor = .black
////                print(loopCount)
//                
//                print(i, j)
//            }
//            loopCount += 1
        
        
//        }
        
        
    }

    fileprivate func randomColor() -> UIColor {
        
        //drand48 generates a random double between 0-1 so needs to be converted to type CGFloat
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())

        
        //returns a UIColor constructor with random float numbers between 0-1
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}

