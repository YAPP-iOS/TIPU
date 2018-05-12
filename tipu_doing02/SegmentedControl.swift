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
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        self.setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
}


