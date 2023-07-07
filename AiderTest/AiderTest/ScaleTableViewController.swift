import UIKit
import AcaiaSDK

class ScaleTableViewController: UITableViewController {
    
    var scales: [AcaiaScale] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scales"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        startScanning()
    }
    
    func startScanning() {
        AcaiaManager.shared().startScan(10)
        NotificationCenter.default.addObserver(self, selector: #selector(scaleListChanged), name: NSNotification.Name.AcaiaScaleListChangedNotification, object: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scales.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let scale = scales[indexPath.row]
        cell.textLabel?.text = scale.name
        return cell
    }
    
    
    func startScanning() {
        AcaiaManager.shared().startScan(10)
        NotificationCenter.default.addObserver(self, selector: #selector(scaleListChanged), name: NSNotification.Name.AcaiaScaleListChangedNotification, object: nil)
    }
    
    
    @objc func scaleListChanged() {
        scales = AcaiaManager.shared().scaleList as? [AcaiaScale] ?? []
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scale = scales[indexPath.row]
        AcaiaManager.shared().connectScale(scale)
    }
}

