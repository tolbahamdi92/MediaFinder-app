//
//  MediaVC.swift
//  MediaFinder
//
//  Created by Tolba on 04/06/1444 AH.
//

import AVKit

enum MediaType: String {
    case movie
    case tvShow
    case music
    case all
}

class MediaVC: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mediaSegment: UISegmentedControl!
    
    // MARK:- Properties
    private var mediaArr: [Media] = []
    private var mediaType: MediaType = .all
    private var mediaKind: String = MediaType.all.rawValue
    private var indicator = UIActivityIndicatorView()
    private var email = UserDefaults.standard.string(forKey: UserDefaultsKeys.email)
    
    // MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn)
        email = UserDefaults.standard.string(forKey: UserDefaultsKeys.email)
        getTempData()
    }
    
    // MARK:- IBAction
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        segmentedChangedAction(sender)
    }
}

// MARK:- TableView DataSource and Delegate
extension MediaVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setNumberOfRowsTableView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.media, for: indexPath) as! MediaTVC
        cell.setupCell(type: mediaType, media: mediaArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = mediaArr[indexPath.row].previewUrl {
            playMedia(mediaUrl: url)
        }
    }
}

// MARK:- UISearchBarDelegate
extension MediaVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchButtonAction()
    }
}

// MARK:- Private SetupUI Methods
extension MediaVC {
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Cells.media, bundle: nil), forCellReuseIdentifier: Cells.media)
        tableView.backgroundColor = .none
    }
    
    private func setupNavigationBar() {
        self.title = ViewControllerTitle.media
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: ButtonsTitle.profile, style: .plain, target: self, action: #selector(self.gotoProfile))
    }
}

// MARK:- Private Data Methods
extension MediaVC {
    private func getTempData() {
        let (type, data) = UserDBSQLiteManager.shared.fetchSearchData(email: email ?? "")
        if let type = type , let data = data {
            mediaArr = data
            mediaKind = type
            setSegmented()
            tableView.reloadData()
        }
    }
    
    private func setTempData() {
        UserDBSQLiteManager.shared.saveSearchData(email: email ?? "", type: mediaKind, media: mediaArr)
    }
    
    private func getData(term: String, type: String) {
        self.view.showLoader(indicator: &indicator)
        MediaAPIManagera.fetchMedia(term: term, type: type) { [weak self] error, data in
            guard error == nil else {
                switch error! {
                case .responseError(let errorDesc):
                    self?.showAlert(title: Alerts.sorryTitle, message: errorDesc)
                case .noDataError:
                    self?.showAlert(title: Alerts.sorryTitle, message: Alerts.noFoundData)
                case .decodeError:
                    self?.showAlert(title: Alerts.sorryTitle, message: Alerts.tryAgain)
                }
                self?.view.hideLoader(indicator: self!.indicator)
                return
            }
            guard let data = data else {
                self?.showAlert(title: Alerts.sorryTitle, message: Alerts.tryAgain)
                return
            }
            self?.mediaArr = data
            self?.view.hideLoader(indicator: self!.indicator)
            self?.tableView.reloadData()
            self?.setTempData()
        }
    }
    
    private func setNumberOfRowsTableView() -> Int {
        let backgroundImage = UIImage(named: PlaceholderImage.search)
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFit
        tableView.backgroundView = imageView
        if mediaArr.count > 0 {
            imageView.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            imageView.isHidden = false
            tableView.separatorStyle = .none
        }
        return mediaArr.count
    }
}

// MARK:- Private Action Methods
extension MediaVC {
    private func searchButtonAction() {
        if (searchBar.text?.count ?? 0) >= 3 {
            getData(term: searchBar.text!, type: mediaType.rawValue)
        } else if (searchBar.text?.count ?? 0) == 0{
            self.showAlert(title: Alerts.sorryTitle, message: Alerts.noSearchData)
        } else {
            self.showAlert(title: Alerts.sorryTitle, message: Alerts.moreCharacterSearch)
        }
    }
    
    @objc func gotoProfile() {
        let profileVC = UIStoryboard(name: StoryBoard.main, bundle: nil).instantiateViewController(identifier: ViewController.profileVC)
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func playMedia(mediaUrl: String) {
        guard let url = URL(string: mediaUrl) else { return }
        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true) {
            playerVC.player?.play()
        }
    }
    
    private func segmentedChangedAction(_ sender: UISegmentedControl) {
        if isAllowedChangedSegmented() {
            let index = sender.selectedSegmentIndex
            switch index {
            case 1:
                mediaType = .tvShow
            case 2:
                mediaType = .music
            case 3:
                mediaType = .movie
            default :
                mediaType = .all
            }
            mediaKind = mediaType.rawValue
            searchButtonAction()
        }
    }
    
    private func setSegmented() {
        switch mediaKind {
        case MediaType.tvShow.rawValue:
            mediaType = .tvShow
            mediaSegment.selectedSegmentIndex = 1
        case MediaType.music.rawValue:
            mediaType = .music
            mediaSegment.selectedSegmentIndex = 2
        case MediaType.movie.rawValue:
            mediaType = .movie
            mediaSegment.selectedSegmentIndex = 3
        default:
            mediaType = .all
            mediaSegment.selectedSegmentIndex = 0
        }
    }
    
    func isAllowedChangedSegmented() -> Bool {
        var selected = 0
        switch mediaType {
        case .all:
            selected = 0
        case .tvShow:
            selected = 1
        case .music:
            selected = 2
        case .movie:
            selected = 3
        }
        if (searchBar.text?.count ?? 0) == 0 {
            mediaSegment.selectedSegmentIndex = selected
            self.showAlert(title: Alerts.sorryTitle, message: Alerts.noSearchData)
            return false
        } else if (searchBar.text?.count ?? 0) < 3 {
            mediaSegment.selectedSegmentIndex = selected
            self.showAlert(title: Alerts.sorryTitle, message: Alerts.moreCharacterSearch)
            return false
        } else {
            return true
        }
    }
}
