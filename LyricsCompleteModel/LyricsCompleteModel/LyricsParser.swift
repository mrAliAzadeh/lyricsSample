//
//  LyricsParser.swift
//  LyricsCompleteModel
//
//  Created by MonkeySolution on 11/1/17.
//  Copyright © 2017 MonkeySolution. All rights reserved.
//

import Foundation
class LyricsParser {
 // LyricsModel
    
    static func parse(input : [[String:Any]])->LyricsModel{
        print(input)
        let result = LyricsModel()
        
        for item in input {
            let thisItem = LyricsSubtitleModel()
            
            for (key,value) in item {
                switch key {
                case "title" :
                    thisItem.title = value as? String
                    break
                    
                case "index" :
                    thisItem.index = value as? Int
                    break
                    
                case "DisplayStartTime" :
                    thisItem.startTime = value as? Double
                    break
                case "DisplayEndTime" :
                    thisItem.endTime = value as? Double
                    break
                case "direction" :
                    let val = value as? String
                    
                    if val != nil {
                        if val == "LTR" {
                            thisItem.direction = .ltr
                        }
                    }
                    
                    break
                    
                case "HighlighOffsetsTiming" :
                    let infoArray = value as! [[String : Any]]
                    
                    for insideItem in infoArray {
                        let thisValue = LyricsSubtitleDetailModelModel()
                        for (insideKey , insideValue) in insideItem {
                            
                            switch insideKey{
                            case "startTime" :
                                thisValue.startTime = insideValue as? Double
                                break
                            case "rate" :
                                thisValue.duration = insideValue as? Double
                                break
                                
                            case "index" :
                                thisValue.index = insideValue as? Int
                                break
                                
                            case "biginnerCharIndex" :
                                thisValue.biginnerCharIndex = insideValue as? Int
                                break
                                
                            case "endCharIndex" :
                                thisValue.endCharIndex = insideValue as? Int
                                break
                                
                                
                            default :
                                break
                            }
                            
                        }
                        thisItem.detail.append(thisValue)
                    }
                    
                    break
                    
                default :
                    break
                }
                
            }
            result.subTitleArray.append(thisItem)
        }
        
        
        return  result
    }

   
    
    
}
