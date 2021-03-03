//
//  CharacterView.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 03/03/21.
//

import UIKit

class CharacterView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10

        layer.shadowColor = UIColor.rickAndMortyTitleGreen.cgColor
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.9
        layer.shadowOffset = CGSize.zero
        //        layer.borderColor = UIColor.black.cgColor
        //        layer.borderWidth = 0.5
        layer.masksToBounds = false
    }
}
