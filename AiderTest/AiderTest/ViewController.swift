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
        setupMenuTableView()
//        addLongTapGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(onWeightUpdate(_:)), name: NSNotification.Name(rawValue: AcaiaScaleWeight), object: nil)
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
        // Create and setup the weight label
        weightLabel = UILabel()
        weightLabel.text = "weight: "
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weightLabel)

        // Create and setup the flow label
        flowLabel = UILabel()
        flowLabel.text = "flow: "
        flowLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flowLabel)
   
        // Create and setup the connect button
        connectButton = UIButton(type: .system)
        connectButton.setTitle("Connect", for: .normal)
        connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectButton)

        // Create and setup the disconnect button
        disconnectButton = UIButton(type: .system)
        disconnectButton.setTitle("Disconnect", for: .normal)
        disconnectButton.addTarget(self, action: #selector(disconnectButtonTapped), for: .touchUpInside)
        disconnectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(disconnectButton)
    
       
        // Create and setup the chart button
        chartButton = UIButton(type: .system)
        chartButton.setTitle("Chart", for: .normal)
        chartButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        chartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartButton)

        // Setup constraints
        NSLayoutConstraint.activate([
            connectButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            connectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            disconnectButton.topAnchor.constraint(equalTo: connectButton.bottomAnchor, constant: 40),
            disconnectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            weightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            flowLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flowLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 20),
            connectButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            connectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
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
        weightLabel.text = "weight: \(weight)"
        
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
            flowLabel.text = "flow: " + String(format: "%.2f g/s", averageFlowRate)

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



