import UIKit
import AcaiaSDK

protocol ScaleTableViewControllerDelegate: AnyObject {
    func scaleTableViewController(_ controller: ScaleTableViewController, didSelect scale: AcaiaScale)
}

class ScaleTableViewController: UITableViewController {
    weak var delegate: ScaleTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScaleCell")
        
        _setRefreshControl()
        _addAcaiaEventsObserver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AcaiaManager.shared().startScan(0.5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _activityIndicatorView.stopAnimating()
        _timerForConnectTimeOut?.invalidate()
        _timerForConnectTimeOut = nil
        _removeScaleEventObservers()
    }

    
    // MARK: Private
    
    private var _timerForConnectTimeOut: Timer? = nil
    
    lazy private var _activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
        
        view.addSubview(indicator)
        indicator.center = view.center
        
        return indicator
    }()
    
    private func _setRefreshControl() {
        tableView.refreshControl = .init()
        tableView.refreshControl?.attributedTitle = .init(string: "Scanning")
        tableView.refreshControl?.addAction(
            UIAction { _ in AcaiaManager.shared().startScan(0.5) },
            for: .valueChanged
        )
    }
}

//MARK: Observers
extension ScaleTableViewController {
    private func _addAcaiaEventsObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_didConnected),
                                               name: .init(rawValue: AcaiaScaleDidConnected),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_didFinishScan),
                                               name: .init(rawValue: AcaiaScaleDidFinishScan),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_didDisconnected),
                                               name: .init(rawValue: AcaiaScaleDidDisconnected),
                                               object: nil)
    }
    
    private func _removeScaleEventObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
//MARK: func
extension ScaleTableViewController{
    @objc private func _didConnected(notification: NSNotification) {
        _activityIndicatorView.stopAnimating()
        
        _timerForConnectTimeOut?.invalidate()
        _timerForConnectTimeOut = nil
        
        if let scale = AcaiaManager.shared().connectedScale {
            delegate?.scaleTableViewController(self, didSelect: scale)
        }
        
        let chartViewController = ChartViewController.shared
        chartViewController.isLogging = true
        if !(navigationController?.viewControllers.contains(chartViewController) ?? false) {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func _didFinishScan(notification: NSNotification) {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
        
        // Automatically connect to the first scale found
        if !AcaiaManager.shared().scaleList.isEmpty, let scale = AcaiaManager.shared().scaleList.first {
            scale.connect()
        }
    }
    @objc private func _didDisconnected(notification: NSNotification) {
        if let scale = AcaiaManager.shared().connectedScale {
            scale.connect()
        }
    }
    @objc private func _connectTimeOut(_ timer: Timer) {
        _activityIndicatorView.stopAnimating()
        
        _timerForConnectTimeOut?.invalidate()
        _timerForConnectTimeOut = nil
        
        AcaiaManager.shared().startScan(0.1)
        
        let alert = UIAlertController(title: nil,
                                      message: "Connect timeout",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alert, animated: true)
    }
}

//MARK: Tableview
extension ScaleTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AcaiaManager.shared().scaleList.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScaleCell", for: indexPath)

        let scale = AcaiaManager.shared().scaleList[indexPath.row]

        cell.textLabel?.text = scale.name
        cell.detailTextLabel?.text = scale.modelName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _activityIndicatorView.isHidden = false
        _activityIndicatorView.startAnimating()
        
        let scale = AcaiaManager.shared().scaleList[indexPath.row]
        if scale.name == "YourScaleName" {
            scale.connect()
        
            _timerForConnectTimeOut = Timer.scheduledTimer(timeInterval: 10.0,
                                                           target: self,
                                                           selector: #selector(_connectTimeOut(_:)),
                                                           userInfo: nil,
                                                           repeats: false)
        }
    }
    
}
