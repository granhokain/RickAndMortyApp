//
//  EpisodeDetailViewController.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 04/03/21.
//

import UIKit
import WebKit
import AVKit
import AVFoundation

class EpisodeDetailViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: WKWebView!

    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var episode: Episode?
    var season: Int?
    var characters = [Character]() {
        didSet {
            tableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        }
    }

    private let viewModel = EpisodeViewModel()

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        getCharacters()
        getSeasonTrailer()
        self.view.backgroundColor = .mainColor
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .mainBackgroundColor
    }

    func getCharacters() {
        if let characterIds = episode?.characterIds() {
            viewModel.getCharactersWith(ids: characterIds)
        }
    }

    func getSeasonTrailer() {
        guard let episodeName = episode?.episode else {
            return
        }
        let index = episodeName.index(episodeName.startIndex, offsetBy: 2)
        let season = episodeName[index]
        self.season = season.wholeNumberValue
        if season.wholeNumberValue == 1 {
            loadVideo(url: "https://www.youtube.com/watch?v=BFTSrbB2wII")
        } else if season.wholeNumberValue == 2 {
            loadVideo(url: "https://www.youtube.com/watch?v=_IZfO_LfK5Q")
        } else if season.wholeNumberValue == 3 {
            loadVideo(url: "https://www.youtube.com/watch?v=vnIG6LzMnk0")
        } else if season.wholeNumberValue == 4 {
            loadVideo(url: "https://www.youtube.com/watch?v=0kDgFKTJHAQ")
        }
    }

    func loadVideo(url: String) {
        let id = url.youtubeID
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(id!)") else {
            return
        }
        webView.load(URLRequest(url: youtubeURL))
    }

    func characterNamesAsString() -> String {
        var characterNames = ""
        for character in characters {
            characterNames.append("\(character.name), ")
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
        switch indexPath.row {
        case 0:
            return 50
        case 1:
            return 70
        case 2:
            return 50
        case 3:
            return 130
        default:
            return 70
        }

    }
}

extension EpisodeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as? EpisodeDetailTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.detailTypeLabel.text = "Trailer:"
            cell.detailInfoLabel.text = "Season \(self.season ?? 0)"
        case 1:
            cell.detailTypeLabel.text = "Air Date:"
            cell.detailInfoLabel.text = episode?.airDate
        case 2:
            cell.detailTypeLabel.text = "Episode:"
            cell.detailInfoLabel.text = episode?.episode
        case 3:
            cell.detailTypeLabel.text = "Characters:"
            cell.detailInfoLabel.text = characterNamesAsString()
        default:
            return UITableViewCell()
        }
        return cell
    }
}

extension String {
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"

        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)

        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }

        return (self as NSString).substring(with: result.range)
    }

}
