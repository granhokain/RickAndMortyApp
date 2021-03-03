//
//  CharacterImageView.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 03/03/21.
//

import UIKit

class CharacterImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }

}
