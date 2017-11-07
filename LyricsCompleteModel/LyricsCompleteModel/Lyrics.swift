//
//  Lyrics.swift
//  LyricsCompleteModel
//
//  Created by MonkeySolution on 11/1/17.
//  Copyright © 2017 MonkeySolution. All rights reserved.
//

import Foundation
import UIKit
class Lyrics {
    
    var mainTimer : Timer? // timer that execute
    var  counter: Double = -1 // timer counter per time called
    var configuration : LyricsConfig?
    var content : LyricsModel?
     var lastShowSentenceBlockIndex : Int = -1
     var wordSubTitleViewArray = [Int: [UILabel]]() // key is sentec index value is a subtitle word view
    
    func setLyrics(from url : URL)  {
        
        let jsonData = try! Data.init(contentsOf: url)
        
        let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String : Any]]
        content =  LyricsParser.parse(input: jsonResult)
    }
    func resetLyrics(){
        
    }

    func startShowing(){
        mainTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (timer) in
            self.counter += 1
            self.timerLoop()
        })
    }
    
    @objc func timerLoop(){
      
        
      
        let filterdArray =   content?.subTitleArray.filter { (model) -> Bool in
       
            return ( model.startTime! / 1000 <= counter * 0.2 &&  model.endTime! / 1000 >= counter * 0.2 )
        }
        
        if filterdArray != nil ,  filterdArray!.count >= 1 && filterdArray!.first!.startTime! >= Double(30000) {
            print("aknoon")
        }
        
        
        if filterdArray!.count >= 1 /*, filterdArray!.first!.index! != self.lastShowBlockIndex */ {
            // what is second condition ?!
            
            // this part has subtitle
            
             let sentenceIndex = filterdArray!.first!.index!
            let insideFilerArray =   self.content!.subTitleArray[sentenceIndex].detail.filter { (item) -> Bool in
                
                let c1 = item.startTime! / 1000 <= counter * 0.2
                let c2 = (item.startTime! / 1000 + item.duration! / 1000) >= counter * 0.2
                
                if c1 == true , c2 == true {
                    return true
                }else{
                    return false
                }
            }
            
            let wordIndex = insideFilerArray.first?.index
           
            if !self.content!.subTitleArray[sentenceIndex].isShown {
                // this is first time
               //-> self.lastShowBlockIndex = filterdArray!.first!.index!
                
                
                //self.configuration!.topLabel.isHidden = true
                self.configuration?.topLabel.text = filterdArray?.first!.title!
                self.configuration!.topLabel.sizeToFit()
                self.configuration!.topLabel.frame.origin.x = (self.configuration!.topView.bounds.size.width - configuration!.topLabel.frame.size.width) / 2
                self.configuration?.topLabel.frame.size.height = self.configuration!.topView.bounds.size.height
                //self.configuration!.topLabel.isHidden = false
                
            }else{
             // this is second or more time that show this label
            }
           
            if wordIndex != nil ,  !self.content!.subTitleArray[sentenceIndex].detail[wordIndex!].isShown {
                // this is first time for show word
               
                removeFromWordSubTitleViewArray(currentIndex: sentenceIndex)
                self.content!.subTitleArray[sentenceIndex].detail[wordIndex!].isShown = true
              let thisSentence = self.content!.subTitleArray[sentenceIndex].title!
              
                let allContrentArray = thisSentence.components(separatedBy: " ")
                var thisWord = allContrentArray[wordIndex!]
                
                if self.content!.subTitleArray[sentenceIndex].direction == .rtl {
                    // persian
                    if wordIndex != 0 {thisWord.append(" ")}
                }else{
                    // english
                    if wordIndex! != self.content!.subTitleArray[sentenceIndex].detail.count - 1 {
                        thisWord.append(" ")
                    }
                }
         
                let direction = self.content!.subTitleArray[sentenceIndex].direction
                
                let animationTime = self.content!.subTitleArray[sentenceIndex].detail[wordIndex!].duration! / 1000
                
                if self.content!.subTitleArray[sentenceIndex].detail.count-1 == wordIndex! {
                    // last word
                    play(thisWordShownigWord: thisWord, sentenceIndex: sentenceIndex, isLastWordInSentec: true, durationAnimation: animationTime, direction: direction)
                }else{
                    play(thisWordShownigWord: thisWord, sentenceIndex: sentenceIndex, isLastWordInSentec: false, durationAnimation: animationTime, direction: direction)
                }
           
            }else{
                // this is second or more than to show
            }

        }
    }
    
    func play(thisWordShownigWord : String , sentenceIndex sentencID : Int , isLastWordInSentec : Bool , durationAnimation : TimeInterval , direction : LyricsLanguageType){
        
        let thisLable = UILabel.init()
        
        let contentString = thisWordShownigWord

        
        
        thisLable.text = contentString
        thisLable.font = self.configuration!.topLabel.font
         setAtrebuteForLyrics(sender: thisLable, text: contentString)
         thisLable.sizeToFit()
        
       setDirectionForThisLabel(sender: thisLable, direction: direction)
        
        thisLable.frame.size.height = self.configuration!.topLabel.frame.size.height
        thisLable.frame.origin.y = self.configuration!.topLabel.frame.origin.y 
        var allSubTitleViews = [UIView]()
        thisLable.textColor = UIColor.orange
        for view in self.configuration!.topView.subviews where view.tag != 999 {
            // for each view in top view insted of topLabel in configuration
   
            allSubTitleViews.append(view)
        }
  
        allSubTitleViews.sort { (view1, view2) -> Bool in
            return view1.frame.origin.x > view2.frame.origin.x
        }
        
        var destinationWidth = CGFloat(0)
        var destinationOriginX = CGFloat(0)
        
        if direction == .rtl {
            // right to left
            if allSubTitleViews.count >= 1  {
                
                thisLable.frame.origin.x = allSubTitleViews.last!.frame.origin.x
                destinationOriginX = allSubTitleViews.last!.frame.origin.x - thisLable.frame.size.width
            }else{
                thisLable.frame.origin.x =    self.configuration!.topLabel.frame.origin.x + self.configuration!.topLabel.frame.size.width
                
                destinationOriginX = self.configuration!.topLabel.frame.origin.x + self.configuration!.topLabel.frame.size.width - thisLable.frame.size.width
            }
            
        }else{
            // leftr to right
            
            if allSubTitleViews.count >= 1  {
                
                thisLable.frame.origin.x = allSubTitleViews.first!.frame.origin.x + allSubTitleViews.first!.frame.size.width
                print("last orig x is : \(thisLable.frame.origin.x)")
                destinationOriginX = thisLable.frame.origin.x
                
                
                
            }else{
                thisLable.frame.origin.x =    self.configuration!.topLabel.frame.origin.x
                
                destinationOriginX = thisLable.frame.origin.x
            }
        }
        
       
    
        destinationWidth =  thisLable.frame.size.width
        thisLable.frame.size.width = 0
        thisLable.backgroundColor = UIColor.white
       
        
       thisLable.numberOfLines
         = 0
        thisLable.lineBreakMode = .byCharWrapping
        
        self.configuration!.topView.addSubview(thisLable)
        
        
        expandViewWithAnimation(sender: thisLable, animationTime: durationAnimation,  destinationWidth: destinationWidth, destinationOriginX: destinationOriginX)
        
        
        self.insertToWordSubTitleViewArray(key: sentencID, view: thisLable)
        


    }

    
    func insertToWordSubTitleViewArray(key : Int , view : UILabel){
        
        if self.wordSubTitleViewArray[key] != nil {
            
            self.wordSubTitleViewArray[key]?.append(view)
            
        }else{
            
            let thisView = [view]
            
            self.wordSubTitleViewArray[key] = thisView
            
        }
        
    }
    func removeFromWordSubTitleViewArray(currentIndex : Int){
        
        if let labelArray = self.wordSubTitleViewArray[currentIndex-1] {
            for item in labelArray {
                item.removeFromSuperview()
            }
        }

         self.wordSubTitleViewArray[currentIndex-1]?.removeAll()
    }
 
    func setAtrebuteForLyrics(sender : UILabel , text : String){
        let strokeTextAttributes = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.strokeWidth : -3.0,
            NSAttributedStringKey.font : UIFont.init(name: "BYekan", size: 18)!
            ] as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any]
        sender.attributedText = NSAttributedString(string: text , attributes: strokeTextAttributes)
        
    }
    
    func setDirectionForThisLabel(sender : UILabel , direction : LyricsLanguageType ){
       
        
        if direction == .rtl {
            // rtl
            sender.contentMode = .right
            sender.semanticContentAttribute = .forceRightToLeft
            self.configuration!.topView.contentMode = .right
             self.configuration!.topView.semanticContentAttribute = .forceRightToLeft
            
        }else{
            // ltr
            sender.contentMode = .left
            sender.semanticContentAttribute = .forceLeftToRight
            self.configuration!.topView.contentMode = .left
            self.configuration!.topView.semanticContentAttribute = .forceLeftToRight
        }
        
    }
    func expandViewWithAnimation(sender : UIView , animationTime : TimeInterval , destinationWidth : CGFloat , destinationOriginX : CGFloat){
  
        UIView.animate(withDuration: animationTime) {
            sender.frame.origin.x = destinationOriginX
            sender.frame.size.width =  destinationWidth
        }
       
    }
    
}
