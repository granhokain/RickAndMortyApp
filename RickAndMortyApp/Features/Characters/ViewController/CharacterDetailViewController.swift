//
//  CharacterDetailViewController.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 03/03/21.
//

import UIKit
import SDWebImage

class CharacterDetailViewController: UIViewController {

    //MARK:Outlet
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    var character: Character?

    override func viewDidLoad() {
        super.viewDidLoad()

        characterImageView.sd_setImage(with: URL(string: (character?.image)!), completed: nil)
        title = character?.name
        statusLabel.text = character?.status
        speciesLabel.text = character?.species
        typeLabel.text = character?.type == "" ? "Not Available" : character?.type
        originLabel.text = character?.origin.name
        locationLabel.text = character?.location.name

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
