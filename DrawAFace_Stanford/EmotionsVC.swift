//
//  EmotionsVC.swift
//  DrawAFace_Stanford
//
//  Created by 辛忠翰 on 2016/10/1.
//  Copyright © 2016年 辛忠翰. All rights reserved.
//

import UIKit

class EmotionsVC: UIViewController {

    fileprivate let emotionFace: [String : FacialExpression] = [
        "angry": FacialExpression(eyes: .Close, eyeBrowes: .Furrowed, mouth: .Frown),
        "happy": FacialExpression(eyes: .Open, eyeBrowes: .Normal, mouth: .Smile),
        "worried": FacialExpression(eyes: .Open, eyeBrowes: .Relaxed, mouth: .Smirk),
        "mischievious": FacialExpression(eyes: .Open, eyeBrowes: .Furrowed, mouth: .Grin)
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destVC = segue.destination
        //if I am preparing to segue to something, and it's a navigation controller then instead look inside the navigation controller, and segue to instead they prepare that instead
        if let navigationVC = destVC as? UINavigationController{
            destVC = navigationVC.visibleViewController ?? destVC
        }
        if let faceVC = destVC as? FaceItVC{
            if let identifer = segue.identifier{
                if let expression = emotionFace[identifer]{
                    faceVC.facialExpression = expression
                    if let segueButton = sender as? UIButton{
                        faceVC.navigationItem.title = segueButton.currentTitle
                    }
                }
            }
        }
    }
}
