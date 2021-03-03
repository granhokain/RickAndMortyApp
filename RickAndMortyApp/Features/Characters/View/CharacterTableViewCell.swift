//
//  CharacterTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 03/03/21.
//

import UIKit
import SDWebImage

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setUpWith(characterModel character: Character) {
        nameLabel.text = character.name
        statusLabel.text = character.status
        avatarImageView.sd_setImage(with: URL(string: character.image), completed: nil)
    }

}
