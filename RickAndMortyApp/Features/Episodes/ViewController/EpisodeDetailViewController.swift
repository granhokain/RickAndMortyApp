//
//  EpisodeDetailViewController.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 04/03/21.
//

import UIKit

class EpisodeDetailViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!

    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var episode: Episode?
    var characters = [Character]() {
        didSet {
            tableView.reloadData()
        }
    }

    private let viewModel = EpisodeViewModel()

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        getCharacters()
        title = episode?.name
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .mainBackgroundColor
    }

    func getCharacters() {
        if let characterIds = episode?.characterIds() {
            viewModel.getCharactersWith(ids: characterIds)
        }
    }

    func characterNamesAsString() -> String {
        var characterNames = ""
        for character in characters {
            characterNames.append(character.name + " \n")
        }
        return characterNames
    }

    //MARK: Bind ViewModel
    private func bindViewModel() {
        viewModel.startLoading = { [unowned self] in
            self.loadingView.startLoading(inView: self.view)
        }

        viewModel.endLoading = { [unowned self] in
            self.loadingView.stopLoading()
        }

        viewModel.showEpisodeCharacter = { [unowned self] characters in
            self.characters = characters
        }
    }
}

extension EpisodeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension EpisodeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as? EpisodeDetailTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.detailTypeLabel.text = "Air Date:"
            cell.detailInfoLabel.text = episode?.airDate
        case 1:
            cell.detailTypeLabel.text = "Episode:"
            cell.detailInfoLabel.text = episode?.episode
        case 2:
            cell.detailTypeLabel.text = "Characters:"
            cell.detailInfoLabel.text = characterNamesAsString()
        default:
            return UITableViewCell()
        }
        return cell
    }
}
