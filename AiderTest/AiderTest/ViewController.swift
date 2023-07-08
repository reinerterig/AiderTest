//
//  ViewController.swift
//  AiderTest
//
//  Created by reinert wasserman on 7/7/2023.
//

import UIKit
import AcaiaSDK

    class ViewController: UIViewController, ScaleTableViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
        var weightLabel: UILabel!
        var connectButton: UIButton!
        var disconnectButton: UIButton!
        var flowLabel: UILabel!
        var previousWeight: Float = 0
        var previousTime: Date = Date()
        var flowRates: [Float] = []
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    var menuTableView: UITableView!
    var menuOptions: [String] = ["Toggle"]
    var isShowingWeightChart = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(onWeightUpdate(_:)), name: NSNotification.Name(rawValue: AcaiaScaleWeight), object: nil)
        
        let chartViewController = ChartViewController()
        navigationController?.pushViewController(chartViewController, animated: true)
    }
    

    func setupMenuTableView() {
        menuTableView = UITableView()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.isHidden = true
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuOptionCell")
        view.addSubview(menuTableView)
    }



    func showMenuTableView(at location: CGPoint) {
        menuTableView.frame = CGRect(x: location.x, y: location.y, width: 200, height: CGFloat(menuOptions.count * 44))
        menuTableView.isHidden = false
    }

    var chartButton: UIButton!
    
    func setupUI() {
    }
        
    @objc func connectButtonTapped() {
        let scaleTableViewController = ScaleTableViewController()
        scaleTableViewController.delegate = self
        navigationController?.pushViewController(scaleTableViewController, animated: true)
    }

    @objc func disconnectButtonTapped() {
        // Disconnect the scale
        AcaiaManager.shared().connectedScale?.disconnect()

        // If the scale is not disconnected by the user, reconnect it
        if AcaiaManager.shared().connectedScale == nil {
            AcaiaManager.shared().startScan(5)
        }
    }

    @objc func chartButtonTapped() {
        let chartViewController = ChartViewController()
        navigationController?.pushViewController(chartViewController, animated: true)
    }
    

    @objc func onWeightUpdate(_ notification: NSNotification) {
        guard let weight = notification.userInfo?[AcaiaScaleUserInfoKeyWeight] as? Float else { return }
       
        
        let currentTime = Date()
        let timeDifference = currentTime.timeIntervalSince(previousTime)
        if timeDifference > 0 {
            let weightDifference = weight - previousWeight
            let flowRate = weightDifference / Float(timeDifference)
            flowRates.append(flowRate)
            if flowRates.count > 10 {
                flowRates.removeFirst()
            }
            let averageFlowRate = flowRates.reduce(0, +) / Float(flowRates.count)
           

            // If logging is enabled, update the chart data
            if let chartViewController = navigationController?.viewControllers.first(where: { $0 is ChartViewController }) as? ChartViewController, chartViewController.isLogging {
                let loggingTime = currentTime.timeIntervalSince(chartViewController.startTime ?? currentTime)
                chartViewController.logData(time: loggingTime, weight: weight, flow: flowRate)
            }
        }
        
        previousWeight = weight
        previousTime = currentTime
    }
    
    func scaleTableViewController(_ controller: ScaleTableViewController, didSelect scale: AcaiaScale) {
        // Implement this method as required by the protocol
    }

    // MARK: - UITableViewDelegate and UITableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuOptionCell", for: indexPath)
        cell.textLabel?.text = menuOptions[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuOptions[indexPath.row] == "Toggle" {
//            toggleChartDisplay()
        }
        tableView.isHidden = true
    }
}



