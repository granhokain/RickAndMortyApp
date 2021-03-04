//
//  EpisodeTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 04/03/21.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setUpWith(episodeModel episode: Episode) {
        nameLabel.text = episode.name
        episodeLabel.text = episode.episode
    }
}
