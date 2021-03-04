//
//  EpisodeDetailTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 04/03/21.
//

import UIKit

class EpisodeDetailTableViewCell: UITableViewCell {


    @IBOutlet weak var detailTypeLabel: UILabel!

    @IBOutlet weak var detailInfoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .mainBackgroundColor
    }
}
