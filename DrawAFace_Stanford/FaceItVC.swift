//
//  ViewController.swift
//  DrawAFace_Stanford
//
//  Created by 辛忠翰 on 2016/9/30.
//  Copyright © 2016年 辛忠翰. All rights reserved.
//

import UIKit

class FaceItVC: UIViewController {
    
    // MARK: Modle
    //When you initiallize the FacialExpression(), it wont call the didSet(), and the didSet() only be called if you set  later, so we can put the updateUI() to when the faceView outlet has been setted by system.
    //it called when modle change
    var facialExpression = FacialExpression(eyes: .Open, eyeBrowes: .Normal, mouth: .Frown){didSet{self.updateUI()}}
    
    
    
    //this didset() is called, when ios comes along show the after if MVC is created, and it hook up the outlet
    //so it will call when first time the faceView is hooked up
    
    // MARK: View
    
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            self.updateUI()
            //the target is faceView, because the pinch recognizer only change the faceView not change the model. If change the model, the target will set to self(ViewController)
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView,
                action: #selector(FaceView.changeScale(recognizer:))
            ))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(self.increaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(self.increaseSadness)
            )
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)

            
        }
    }
    
    
    // MARK: Gesture Handlers
    @objc  fileprivate func increaseHappiness(){
        facialExpression.mouth = facialExpression.mouth.happierMouth()
    }
    
    @objc fileprivate func increaseSadness(){
        facialExpression.mouth = facialExpression.mouth.sadderMouth()
    }
    
    
    @IBAction func tapTheEyes(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended{
            switch facialExpression.eyes {
            case .Open: facialExpression.eyes = .Close
            case .Close: facialExpression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    
        
    
    
    
    //use ViewController to communicate FaceView and FacialExpression
    fileprivate var mouthCurvatures: [FacialExpression.Mouth: Double] = [
            .Frown : -1.0,
            .Grin : 0.5,
            .Smile : 1.0,
            .Smirk : -0.5,
            .Neutral : 0.0
    ]
    
    fileprivate var eyeBrowseTilt : [FacialExpression.EyeBrowse: Double] = [
        .Relaxed : 1.0,
        .Normal : 0.0,
        .Furrowed : -1.0
    ]
    
    fileprivate func updateUI(){
        if self.faceView != nil{
            switch facialExpression.eyes {
            case .Open:faceView.eyeOpen = true
            case .Close: faceView.eyeOpen = false
            case .Squinting: faceView.eyeOpen = false
            }
            
            faceView.mouthCurvature = self.mouthCurvatures[facialExpression.mouth] ?? 0.0
            
            faceView.eyeBrowTilt = self.eyeBrowseTilt[facialExpression.eyeBrowes] ?? 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

