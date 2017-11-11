//
//  LyricsModel.swift
//  LyricsCompleteModel
//
//  Created by MonkeySolution on 11/1/17.
//  Copyright © 2017 MonkeySolution. All rights reserved.
//

import Foundation
import  UIKit
enum LyricsLanguageType{
    case rtl
    case ltr
}


class LyricsModel {
    var subTitleArray = [LyricsSubtitleModel]()
}
class LyricsSubtitleModel{
    
    var title : String?
    var startTime : Double?
    var endTime : Double?
    var detail = [LyricsSubtitleDetailModelModel]()
    var index : Int?
    var direction : LyricsLanguageType = .rtl
   var isShown = false
    var location : LyricsLocation = .bottom
   
}
class LyricsSubtitleDetailModelModel{
    var startTime : Double?
    var duration : Double?
    var biginnerCharIndex : Int?
    var endCharIndex : Int?
    var index : Int?
    var isShown : Bool = false
}
