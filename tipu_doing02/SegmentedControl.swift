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

    func setupFonts(){
        
        //속성
        let normalTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: CGFloat(156/255.0), green: CGFloat(156/255.0), blue: CGFloat(156/255.0), alpha: CGFloat(1.0))]
        let selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: CGFloat(45/255.0), green: CGFloat(45/255.0), blue: CGFloat(50/255.0), alpha: CGFloat(1.0))]

        //설정
        self.setTitleTextAttributes(normalTitleTextAttributes, for: .normal)
        self.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
    }
    
}

