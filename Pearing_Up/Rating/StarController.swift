//
//  StarController.swift
//  Pearing_Up
//
//  Created by Grace Kim on 2018-07-21.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//
import UIKit

class StarController: UIStackView {
    var starRating = 0
    var starEmpty = "emptyStar"
    var starFilled = "filledStar"
    override func draw(_ rect: CGRect) {
        let starButtons = self.subviews.filter{$0 is UIButton}
        var starTag = 1
        for button in starButtons {
            if let button = button as? UIButton{
                button.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                button.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
                button.tag = starTag
                starTag = starTag + 1
            }
        }
        setStarRating(rating:starRating)
    }
    func setStarRating(rating:Int){
        self.starRating = rating
        let stackSubViews = self.subviews.filter{$0 is UIButton}
        for subView in stackSubViews {
            if let button = subView as? UIButton{
                if button.tag > starsRating {
                    button.setImage(UIImage(named: starEmpty), for: .normal)
                }else{
                    button.setImage(UIImage(named: starFilled), for: .normal)
                }
            }
        }
    }
    @objc func pressed(sender: UIButton) {
        setStarRating(rating: sender.tag)
    }
}
