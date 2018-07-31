//
//  StarRating.swift
//  Pearing_Up
//
//  Created by Grace Kim on 2018-07-21.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import UIKit

class StarRating: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
    }
    
    private func setUpButtons() {
        
        let button = UIButton()
        button.backgroundColor = .green
        button.translatesAutoresizingMaskingIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        addArrangedSubview(button)
    }


}
