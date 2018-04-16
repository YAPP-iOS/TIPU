//
//  SegmentedControl.swift
//  tipu_doing02
//
//  Created by JunHee on 01/04/2018.
//  Copyright © 2018 JunHee. All rights reserved.
//

import UIKit

@IBDesignable
class SegmentedControl: UISegmentedControl {
    
    
    func initUI(){
//        setupBackground()
                setupFonts()
    }
    
    func setupBackground(){
        let backgroundImage = UIImage(named: "no")
        let dividerImage = UIImage(named: "segmented_separator_bg")
        let backgroundImageSelected = UIImage(named: "segmented_selected_bg")
        
        
        self.setBackgroundImage(backgroundImage, for: UIControlState(), barMetrics: .default)
        self.setBackgroundImage(backgroundImageSelected, for: .highlighted, barMetrics: .default)
        self.setBackgroundImage(backgroundImageSelected, for: .selected, barMetrics: .default)
        
        self.setDividerImage(dividerImage, forLeftSegmentState: UIControlState(), rightSegmentState: .selected, barMetrics: .default)
        self.setDividerImage(dividerImage, forLeftSegmentState: .selected, rightSegmentState: UIControlState(), barMetrics: .default)
        self.setDividerImage(dividerImage, forLeftSegmentState: UIControlState(), rightSegmentState: UIControlState(), barMetrics: .default)
    }
    
    func setupFonts(){
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        self.setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
}


