//
//  LyricsStatus.swift
//  LyricsCompleteModel
//
//  Created by MonkeySolution on 11/7/17.
//  Copyright © 2017 MonkeySolution. All rights reserved.
//

import Foundation
enum LyricsLocation {
    case top
    case bottom
}
class LyricsStatus {
    var lastSentenceLocation : LyricsLocation?
   // var lastLyrics : (sentenceID : Int , direction : LyricsLocation) = (sentenceID : -1 , direction : .top)
    
}
