//
//  FacialExpression.swift
//  FaceIt_Standford
//
//  Created by 辛忠翰 on 2016/9/30.
//  Copyright © 2016年 辛忠翰. All rights reserved.
//

import Foundation

struct FacialExpression: NSObject {
    enum Eyes: Int{
        case Open
        case Close
        case Squinting
    }
    
    enum EyeBrowse: Int {
        case Relaxed
        case Normal
        case Furrowed
        
        func moreRelaxedBrowse() -> EyeBrowse {
            return EyeBrowse(rawValue: rawValue - 1) ?? .Relaxed
        }
        
        func moreFurrowedBrowse() -> EyeBrowse {
            return EyeBrowse(rawValue: rawValue + 1) ?? .Furrowed
        }
    }
    
    enum Mouth: Int {
        case Frown
        case Smirk
        case Neutral
        case Grin
        case Smile
        
        func sadderMouth() -> Mouth{
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        
        func happierMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
    
    var eyes: Eyes
    var eyeBrowes: EyeBrowse
    var mouth: Mouth
}
