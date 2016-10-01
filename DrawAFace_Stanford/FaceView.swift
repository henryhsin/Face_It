//
//  FaceView.swift
//  FaceIt_Standford
//
//  Created by 辛忠翰 on 2016/9/28.
//  Copyright © 2016年 辛忠翰. All rights reserved.
//

//frame:當前視圖在其父視圖的位置與大小
//bounds:描述當前視圖在其座標系統中的位置與大小
//{ didSet{ setNeedsDisplay()} }當你在其他地方更改這些property並不會有所改變，因為這個view會去call draw function,所以又會被改回原default值，所以必須加入setNeedsDisplay來更改property
import UIKit

@IBDesignable
class FaceView: UIView
{
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet{ setNeedsDisplay()} }
    
    @IBInspectable
    var mouthCurvature: Double = -1.0 { didSet{ setNeedsDisplay()} }//1 is full laugh, -1 is full down
    
    @IBInspectable
    var eyeOpen:Bool = true { didSet{ setNeedsDisplay()} }
    
    @IBInspectable
    var eyeBrowTilt: Double = 0.6 { didSet{ setNeedsDisplay()} }//-1 is full follow, 1 is full relax
    
    @IBInspectable
    var strokeCollor: UIColor = UIColor.blue { didSet{ setNeedsDisplay()} }
    
    @IBInspectable
    var fillColor: UIColor = UIColor.yellow { didSet{ setNeedsDisplay()} }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet{ setNeedsDisplay()} }
    
   
    
    
    fileprivate var skullRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height) / 2 * scale

    }
    
   
    fileprivate var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)

    }
    
    //        var skullCenter = convert(center, from: superview)
    //        center的意思是當前視圖的中心點在其父視圖的位置，這邊我們希望把center的point轉成以當前視圖為基準的center，上述兩種方法都可以達到這個目的

    
    
    fileprivate struct Ratios
    {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRedius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        
    }
    
    
    fileprivate enum Eye
    {
        case Left
        case Right
    }
    
    fileprivate func pathForCircleCenterdAtPoint(midPoint point: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: point,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2.0 * M_PI),
            clockwise: true
        )
        path.lineWidth = lineWidth
        return path
    }
    
    fileprivate func getEyeCenter(eye: Eye) -> CGPoint
    {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    fileprivate func pathEye(eye: Eye) -> UIBezierPath
    {
        let eyeRadius = self.skullRadius / Ratios.SkullRadiusToEyeRedius
        let eyeCenter = self.getEyeCenter(eye: eye)
        
        if self.eyeOpen{
            return self.pathForCircleCenterdAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
        }
        let closeEyePath = UIBezierPath()
        closeEyePath.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
        closeEyePath.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        closeEyePath.lineWidth = lineWidth
        return closeEyePath
        
    }
    
    fileprivate func pathBrow(eye: Eye) -> UIBezierPath{
        var tilt = eyeBrowTilt
        switch eye
        {
        case .Left: tilt *= -1.0
        case .Right: break
        }
        
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToEyeOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRedius
        let tiltOffset = CGFloat(max(min(tilt,1), -1)) * eyeRadius / 2
        
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        
        return path
    }
    
    fileprivate func pathMouth() -> UIBezierPath
    {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        let mouthRect = CGRect(x: self.skullCenter.x - mouthWidth/2, y: self.skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        let smileOffset = CGFloat(min(max(mouthCurvature, -1),1)) * mouthRect.height
        
        let startPoint = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let endPoint = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let controlPoint1 = CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.minY + smileOffset)
        let controlPoint2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        path.lineWidth = lineWidth
        return path
    }
    
    
    override func draw(_ rect: CGRect)
    {
        let skull = self.pathForCircleCenterdAtPoint(midPoint: skullCenter, withRadius: skullRadius)
        self.fillColor.setFill()
        self.strokeCollor.setStroke()
        skull.stroke()
        skull.fill()
        
        self.pathEye(eye: .Left).stroke()
        self.pathEye(eye: .Right).stroke()
        self.pathBrow(eye: .Left).stroke()
        self.pathBrow(eye: .Right).stroke()
        self.pathMouth().stroke()
    }
    

}
