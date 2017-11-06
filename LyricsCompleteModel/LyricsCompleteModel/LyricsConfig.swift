//
//  LyricsConfig.swift
//  LyricsCompleteModel
//
//  Created by MonkeySolution on 11/1/17.
//  Copyright © 2017 MonkeySolution. All rights reserved.
//

import Foundation
import UIKit
class LyricsConfig {
    
    private init(){}
    var topView : UIView!
    var bottomView : UIView!
    var controller : UIViewController?
    var topLabel : UILabel!{
        didSet{
            self.topLabel.sizeToFit()
            topView.tag = 999
        }
    }
    var bottomLabel : UILabel!
    var lastShowInsideBlockIndex = -1
    
    static let shared = LyricsConfig()
    var isTopFilled : Bool = false // just control that is it first time to set value or not , if false mean this is first time
    var isBottomFilled : Bool = false // just control that is it first time to set value or not , if false mean this is first time
    var defaultSubTitleTextAttributes : NSMutableAttributedString?
    var showSubTitleTextAttributes : NSMutableAttributedString?
    var defaultSubtitleTextColor : UIColor?
    var showSubtitleTextColor : UIColor?
}
