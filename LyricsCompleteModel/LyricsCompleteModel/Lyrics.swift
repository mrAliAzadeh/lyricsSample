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
        mainTimer = Timer.scheduledTimer(withTimeInterval: self.configuration!.timerRateCheckingJSON, repeats: true, block: { (timer) in
            self.counter += 1
            self.timerLoop()
        })
    }
    
    @objc func timerLoop(){
      
        let filterdArray =   content?.subTitleArray.filter { (model) -> Bool in
       
            return ( model.startTime! / 1000 <= counter * self.configuration!.timerRateCheckingJSON &&  model.endTime! / 1000 >= counter * self.configuration!.timerRateCheckingJSON )
        }
        
        if filterdArray != nil ,  filterdArray!.count >= 1 && filterdArray!.first!.startTime! >= Double(1000) {
         
        }
        
        
        
        if filterdArray!.count >= 1 /*, filterdArray!.first!.index! != self.lastShowBlockIndex */ {
            // what is second condition ?!
            
            // this part has subtitle
            
            var currentLyricsLocation : LyricsLocation = .bottom
            
            if self.configuration!.status.lastLocation != nil {
                currentLyricsLocation = self.configuration!.status.lastLocation!
            }
            
            
             let sentenceIndex = filterdArray!.first!.index!
            
          
            
            
         
            
            
            
            let insideFilerArray =   self.content!.subTitleArray[sentenceIndex].detail.filter { (item) -> Bool in
                
                let c1 = item.startTime! / 1000 <= counter * self.configuration!.timerRateCheckingJSON
                let c2 = (item.startTime! / 1000 + item.duration! / 1000) >= counter * self.configuration!.timerRateCheckingJSON
                
                if c1 == true , c2 == true {
                    return true
                }else{
                    return false
                }
            }
            
            let wordIndex = insideFilerArray.first?.index
     
            var isLastWordInSentence = false
            
            if wordIndex != nil , self.content!.subTitleArray[sentenceIndex].detail.count-1 == wordIndex! {
                isLastWordInSentence = true
            }
            
            
            if sentenceIndex == 1 {
                print("index is : \(wordIndex!)")
            }
           
            if self.configuration!.status.lastLocation == nil {
                print("B position")
                // this is first time to write block of lyrics in lable
                self.setTextForBottomLabel(text : filterdArray!.first!.title!)
                if wordIndex! == 0 {
                    print("K position")
                    currentLyricsLocation = .bottom
                }
                
            }else{
                // this is not first time to write block of lyrics in label
                print("C position")
                if self.configuration!.status.lastLocation! == .top {
                    self.setTextForBottomLabel(text: filterdArray!.first!.title!)
                    if wordIndex != nil ,  wordIndex! == 0 {
                        print("sx position")
                        currentLyricsLocation = .bottom}
                    
                    
                }else{
                    print("D position")
                    self.setTextForTopLabel(text: filterdArray!.first!.title!)
                    if wordIndex != nil ,  wordIndex! == 0 {
                        print("FX position")
                        currentLyricsLocation = .top}
                    
                    
                }
                
            }
            // <><><><>
            if !self.content!.subTitleArray[sentenceIndex].isShown {
                
                self.content!.subTitleArray[sentenceIndex].isShown = true
                print("A position")
                // this is first time
               //-> self.lastShowBlockIndex = filterdArray!.first!.index!
    
                // -> -> ->
                /*
                if !self.configuration!.status.isToFilled , !self.configuration!.status.isBottomFilled {
                    // top and bottom is not fill
                    self.setTextForBottomLabel(text : filterdArray!.first!.title!)
                    self.configuration!.status.currentLocation = .bottom
                    if filterdArray!.count >= 2 {
                        
                        self.setTextForTopLabel(text : filterdArray!.last!.title!)
                        self.configuration!.status.currentLocation = .top
                    }
                }else if !self.configuration!.status.isToFilled{
                    // bottem filled and now we sould inser in top
                    self.setTextForTopLabel(text: filterdArray!.first!.title!)
                     self.configuration!.status.currentLocation = .top

                }else if !self.configuration!.status.isBottomFilled{
                    // top has filled and now we should insert in bottom
                    self.setTextForBottomLabel(text: filterdArray!.first!.title!)
                     self.configuration!.status.currentLocation = .bottom
                }else{
                    // top label and bottom label has filled
                    // now we shoudl check wich one is last
                    
                    if self.configuration!.status.lastLocation == .top {
                        // current is bottom
                        self.setTextForBottomLabel(text: filterdArray!.first!.title!)
                        self.configuration!.status.currentLocation = .bottom
                    }else{
                        // current is top
                        self.setTextForTopLabel(text: filterdArray!.first!.title!)
                        self.configuration!.status.currentLocation = .top
                    }
                    
                }
                 */
                // <><><><>
                // <- <- <-
              //  setTextForBottomLabel(text: filterdArray!.first!.title!)
             //   setTextForTopLabel(text: filterdArray!.first!.title!)
//                self.configuration!.topLabel.isHidden = true
//                self.configuration?.topLabel.text = filterdArray?.first!.title!
//                self.configuration!.topLabel.sizeToFit()
//                self.configuration!.topLabel.frame.origin.x = (self.configuration!.topView.bounds.size.width - configuration!.topLabel.frame.size.width) / 2
//                self.configuration?.topLabel.frame.size.height = self.configuration!.topView.bounds.size.height
//                self.configuration!.topLabel.isHidden = false
                
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
                
                
                var isFirstWord = false
                if wordIndex! == 0 {
                    isFirstWord = true
                }
                
                
              
                
              play(thisWordShownigWord: thisWord, sentenceIndex: sentenceIndex, isLastWordInSentec: isLastWordInSentence, isFirstWordInSentence: isFirstWord, durationAnimation: animationTime, direction: direction, lyricsLocation: currentLyricsLocation)
                
           
            }else{
                // this is second or more than to show
            }

        }
    }
    
    func play(thisWordShownigWord : String , sentenceIndex sentencID : Int , isLastWordInSentec : Bool  , isFirstWordInSentence : Bool , durationAnimation : TimeInterval , direction : LyricsLanguageType , lyricsLocation : LyricsLocation){
        
        
        
        let thisLable = UILabel.init()
        
        let contentString = thisWordShownigWord
   
        thisLable.text = contentString
        
        if lyricsLocation == .top {
              thisLable.font = self.configuration!.topLabel.font
        }else{
              thisLable.font = self.configuration!.bottomLabel.font
        }
        
      
        // inja should check better
         setAtrebuteForLyrics(sender: thisLable, text: contentString)
         thisLable.sizeToFit()
       setDirectionForThisLabel(sender: thisLable, direction: direction)
        
        
        if lyricsLocation == .top {
            thisLable.frame.size.height = self.configuration!.topLabel.frame.size.height
            thisLable.frame.origin.y = self.configuration!.topLabel.frame.origin.y
        }else{
            thisLable.frame.size.height = self.configuration!.bottomLabel.frame.size.height
            thisLable.frame.origin.y = self.configuration!.bottomLabel.frame.origin.y
        }
     
        var allSubTitleViewsInTopView = [UIView]()
        var allSubTitleViewsInBottomView = [UIView]()
        
        for view in self.configuration!.topView.subviews where view.tag != 999 {
            // for each view in top view insted of topLabel in configuration
            // 999 tag is for lblTop in viewController (main label)
            allSubTitleViewsInTopView.append(view)
        }
        
        for view in self.configuration!.bottomView.subviews where view.tag != 888 {
            // for each view in top view insted of topLabel in configuration
            // 888 tag is for lblBottom in viewcontroller (main label)
            allSubTitleViewsInBottomView.append(view)
        }
  
        allSubTitleViewsInTopView.sort { (view1, view2) -> Bool in
            return view1.frame.origin.x > view2.frame.origin.x
        }
        allSubTitleViewsInBottomView.sort { (view1, view2) -> Bool in
            return view1.frame.origin.x > view2.frame.origin.x
        }
        
        var destinationWidth = CGFloat(0)
        var destinationOriginX = CGFloat(0)
        
        if direction == .rtl {
            
            // right to left
            
            if lyricsLocation == .top {
                // in top
                if allSubTitleViewsInTopView.count >= 1  {
                    
                    thisLable.frame.origin.x = allSubTitleViewsInTopView.last!.frame.origin.x
                    destinationOriginX = allSubTitleViewsInTopView.last!.frame.origin.x - thisLable.frame.size.width
                }else{
                    thisLable.frame.origin.x =    self.configuration!.topLabel.frame.origin.x + self.configuration!.topLabel.frame.size.width
                    
                    destinationOriginX = self.configuration!.topLabel.frame.origin.x + self.configuration!.topLabel.frame.size.width - thisLable.frame.size.width
                }
                
            }else{
                // in bottom
                if allSubTitleViewsInBottomView.count >= 1  {
                    
                    thisLable.frame.origin.x = allSubTitleViewsInBottomView.last!.frame.origin.x
                    destinationOriginX = allSubTitleViewsInBottomView.last!.frame.origin.x - thisLable.frame.size.width
                }else{
                    thisLable.frame.origin.x =    self.configuration!.bottomLabel.frame.origin.x + self.configuration!.bottomLabel.frame.size.width
                    
                    destinationOriginX = self.configuration!.bottomLabel.frame.origin.x + self.configuration!.bottomLabel.frame.size.width - thisLable.frame.size.width
                }
            }
            
           
            
        }else{
            // leftr to right
            
            if lyricsLocation == .top {
                // top
                if allSubTitleViewsInTopView.count >= 1  {
                    
                    thisLable.frame.origin.x = allSubTitleViewsInTopView.first!.frame.origin.x + allSubTitleViewsInTopView.first!.frame.size.width
                   
                    destinationOriginX = thisLable.frame.origin.x
                    
                }else{
                    thisLable.frame.origin.x =    self.configuration!.topLabel.frame.origin.x
                    
                    destinationOriginX = thisLable.frame.origin.x
                }
            }else{
                // bottom
                if allSubTitleViewsInBottomView.count >= 1  {
                    
                    thisLable.frame.origin.x = allSubTitleViewsInBottomView.first!.frame.origin.x + allSubTitleViewsInBottomView.first!.frame.size.width
                  
                    destinationOriginX = thisLable.frame.origin.x
                    
                }else{
                    thisLable.frame.origin.x =    self.configuration!.bottomLabel.frame.origin.x
                    
                    destinationOriginX = thisLable.frame.origin.x
                }
            }
            
           
        }

        destinationWidth =  thisLable.frame.size.width
        thisLable.frame.size.width = 0
        thisLable.backgroundColor = UIColor.white
       thisLable.numberOfLines
         = 0
        thisLable.lineBreakMode = .byCharWrapping

        if lyricsLocation == .top {
            self.configuration!.topView.addSubview(thisLable)
            if isFirstWordInSentence {self.configuration!.status.lastLocation = .top}
        }else{
            self.configuration!.bottomView.addSubview(thisLable)
            if isFirstWordInSentence {self.configuration!.status.lastLocation = .bottom}
        }
        
        
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
   private func removeFromWordSubTitleViewArray(currentIndex : Int){
        
        if let labelArray = self.wordSubTitleViewArray[currentIndex-1] {
            for item in labelArray {
                item.removeFromSuperview()
            }
        }

         self.wordSubTitleViewArray[currentIndex-1]?.removeAll()
    }
 
   private func setAtrebuteForLyrics(sender : UILabel , text : String){
        let strokeTextAttributes = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.orange,
            NSAttributedStringKey.strokeWidth : -3.0,
            NSAttributedStringKey.font : UIFont.init(name: "BYekan", size: 18)!
            ] as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any]
        sender.attributedText = NSAttributedString(string: text , attributes: strokeTextAttributes)
        
    }
    
   private func setDirectionForThisLabel(sender : UILabel , direction : LyricsLanguageType ){
       
        
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
   private func expandViewWithAnimation(sender : UIView , animationTime : TimeInterval , destinationWidth : CGFloat , destinationOriginX : CGFloat){
  
        UIView.animate(withDuration: animationTime) {
            sender.frame.origin.x = destinationOriginX
            sender.frame.size.width =  destinationWidth
        }
       
    }
    private func setTextForTopLabel(text : String){
        
        
//        self.configuration?.topLabel.text = text
//        self.configuration!.topLabel.sizeToFit()
//        self.configuration!.topLabel.frame.origin.x = (self.configuration!.topView.bounds.size.width - configuration!.topLabel.frame.size.width) / 2
//        self.configuration?.topLabel.frame.size.height = self.configuration!.topView.bounds.size.height
//
        
        self.configuration!.topLabel.isHidden = true
        self.configuration?.topLabel.text = text
        self.configuration!.topLabel.sizeToFit()
        self.configuration!.topLabel.frame.origin.x = (self.configuration!.topView.bounds.size.width - configuration!.topLabel.frame.size.width) / 2
        self.configuration?.topLabel.frame.size.height = self.configuration!.topView.bounds.size.height
        self.configuration!.topLabel.isHidden = false
        
    }
    private func setTextForBottomLabel(text : String){
        
        
        self.configuration!.bottomLabel.isHidden = true
        self.configuration?.bottomLabel.text = text
        self.configuration!.bottomLabel.sizeToFit()
        self.configuration!.bottomLabel.frame.origin.x = (self.configuration!.bottomView.bounds.size.width - configuration!.bottomLabel.frame.size.width) / 2
        self.configuration?.bottomLabel.frame.size.height = self.configuration!.bottomView.bounds.size.height
        self.configuration!.bottomLabel.isHidden = false
        
//        self.configuration?.bottomLabel.text = text
//        self.configuration!.bottomLabel.sizeToFit()
//        self.configuration!.bottomLabel.frame.origin.x = (self.configuration!.bottomView.bounds.size.width - configuration!.bottomLabel.frame.size.width) / 2
//        self.configuration?.bottomLabel.frame.size.height = self.configuration!.bottomView.bounds.size.height
    }
    
}
