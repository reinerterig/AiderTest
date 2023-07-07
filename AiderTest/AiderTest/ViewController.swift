//
//  ViewController.swift
//  AiderTest
//
//  Created by reinert wasserman on 7/7/2023.
//

import UIKit
import AcaiaSDK

    class ViewController: UIViewController, ScaleTableViewControllerDelegate {
        var weightLabel: UILabel!
        var connectButton: UIButton!
        var flowLabel: UILabel!
        var previousWeight: Float = 0
        var previousTime: Date = Date()
        var flowRates: [Float] = []
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(onWeightUpdate(_:)), name: NSNotification.Name(rawValue: AcaiaScaleWeight), object: nil)
    }

    var chartButton: UIButton!
    
    func setupUI() {
        // Create and setup the weight label
        weightLabel = UILabel()
        weightLabel.text = "weight: "
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weightLabel)

        // Create and setup the chart button
        chartButton = UIButton(type: .system)
        chartButton.setTitle("Chart", for: .normal)
        chartButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        chartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartButton)

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

        // Create and setup the chart button
        chartButton = UIButton(type: .system)
        chartButton.setTitle("Chart", for: .normal)
        chartButton.addTarget(self, action: #selector(chartButtonTapped), for: .touchUpInside)
        chartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartButton)

        // Setup constraints
        NSLayoutConstraint.activate([
            weightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            flowLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flowLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 20),
            connectButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            connectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            chartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    @objc func connectButtonTapped() {
        let scaleTableViewController = ScaleTableViewController()
        scaleTableViewController.delegate = self
        navigationController?.pushViewController(scaleTableViewController, animated: true)
    }

    @objc func chartButtonTapped() {
        let chartViewController = ChartViewController()
        navigationController?.pushViewController(chartViewController, animated: true)
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
        }
        
        previousWeight = weight
        previousTime = currentTime
    }
    
    func scaleTableViewController(_ controller: ScaleTableViewController, didSelect scale: AcaiaScale) {
        // Implement this method as required by the protocol
    }
}



