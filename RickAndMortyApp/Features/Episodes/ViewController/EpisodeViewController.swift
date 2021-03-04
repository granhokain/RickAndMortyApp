//
//  EpisodeViewController.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 04/03/21.
//

import UIKit

class EpisodeViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var paginationHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var paginationStackView: UIStackView!
    @IBOutlet weak var episodeTitle: UILabel! {
        didSet {
            episodeTitle.font = UIFont(name: "Get Schwifty", size: UIScreen.main.bounds.size.width > 375 ? 40.0: 25.0)
        }
    }


    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    var episodes = [Episode]() {
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

    private let viewModel = EpisodeViewModel()

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.getEpisode(name: "", page: "")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toEpisodeDetailVC" {
            if let episodeDetailVC = segue.destination as? EpisodeDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    episodeDetailVC.episode = episodes[indexPath.row]
                }
            }
        }
    }
    //MARK: Actions
    @IBAction func previousButtonPressed(_ sender: Any) {
        guard let previous = info?.previousPage() else {
            return
        }

        if previous != "" {
            viewModel.getEpisode(name: "", page: previous)
        }
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        guard let next = info?.nextPage() else {
            return
        }

        if next != "" {
            viewModel.getEpisode(name: "", page: next)
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

        viewModel.showEpisode = { [unowned self] episodes, info in
            self.episodes = episodes
            self.info = info
        }
    }
}

extension EpisodeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEpisodeDetailVC", sender: self)
    }
}

extension EpisodeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: EpisodeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as? EpisodeTableViewCell else {
            return UITableViewCell()
        }
        let episode = episodes[indexPath.row]
        cell.setUpWith(episodeModel: episode)
        return cell
    }
}
