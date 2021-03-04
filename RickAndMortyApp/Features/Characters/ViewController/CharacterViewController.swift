//
//  CharacterViewController.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 03/03/21.
//

import UIKit

class CharacterViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var paginationHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var paginationStackView: UIStackView!
    @IBOutlet weak var characterTitle: UILabel! {
        didSet {
            characterTitle.font = UIFont(name: "Get Schwifty", size: UIScreen.main.bounds.size.width > 375 ? 40.0: 25.0)
        }
    }

    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var characters = [Character]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var info: Info? {
        didSet {
            DispatchQueue.main.async {
                self.currentPageLabel.text = self.info?.currentPage()
            }
        }
    }

    private let viewModel = CharacterViewModel()

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.view.backgroundColor = .mainBackgroundColor
        bindViewModel()
        viewModel.getCharacter(name: "", page: "")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toCharacterDetailVC" {
            if let characterDetailVC = segue.destination as? CharacterDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    characterDetailVC.character = characters[indexPath.row]
                }
            }
        }
    }

    //MARK: Actions
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        guard let previous = info?.previousPage() else {
            return
        }

        if previous != "" {
            viewModel.getCharacter(name: "", page: previous)
        }
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        guard let next = info?.nextPage() else {
            return
        }

        if next != "" {
            viewModel.getCharacter(name: "", page: next)

        }
    }

    //MARK: Bind ViewModel
    private func bindViewModel() {
        viewModel.startLoading = { [unowned self] in
            self.loadingView.startLoading(inView: self.view)
        }

        viewModel.endLoading = { [unowned self] in
            self.loadingView.stopLoading()
        }

        viewModel.showCharacters = { [unowned self] characters, info in
            self.characters = characters
            self.info = info
        }
    }
}

extension CharacterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CharacterTableViewCell = tableView.dequeueReusableCell(withIdentifier: "characterCell") as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        let character = characters[indexPath.row]
        cell.setUpWith(characterModel: character)
        return cell
    }
}

extension CharacterViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toCharacterDetailVC", sender: self)
    }
}

extension CharacterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        viewModel.getCharacter(name: text, page: "")
        paginationHeightContraint.constant = text == "" ? 30.0 : 0.0
        paginationStackView.isHidden = text == "" ? false : true
    }
}
