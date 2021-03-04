//
//  LocationViewController.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 04/03/21.
//

import UIKit

class LocationViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var paginationHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var paginationStackView: UIStackView!
    @IBOutlet weak var locationTitle: UILabel! {
        didSet {
            locationTitle.font = UIFont(name: "Get Schwifty", size: UIScreen.main.bounds.size.width > 375 ? 40.0: 25.0)
        }
    }


    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var locations = [Location]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
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

    private let viewModel = LocationViewModel()

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.getLocation(name: "", page: "")
        view.backgroundColor = .mainColor
        tableView.separatorStyle = .none
        tableView.backgroundColor = .mainBackgroundColor
    }

    //MARK: Actions
    @IBAction func previousButtonPressed(_ sender: Any) {
        guard let previous = info?.previousPage() else {
            return
        }

        if previous != "" {
            viewModel.getLocation(name: "", page: previous)
        }
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        guard let next = info?.nextPage() else {
            return
        }

        if next != "" {
            viewModel.getLocation(name: "", page: next)
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

        viewModel.showLocation = { [unowned self] locations, info in
            self.locations = locations
            self.info = info
        }
    }
}

extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: LocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as? LocationTableViewCell else {
            return UITableViewCell()
        }
        let location = locations[indexPath.row]
        cell.setUpWith(locationModel: location)
        return cell
    }
}

extension LocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        paginationHeightContraint.constant = text == "" ? 30.0 : 0.0
        paginationStackView.isHidden = text == "" ? false : true
    }
}
