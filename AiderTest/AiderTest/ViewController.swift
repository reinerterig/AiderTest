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
        
    }
        override func viewWillAppear(_ animated: Bool) {
         
            NotificationCenter.default.addObserver(self, selector: #selector(onWeightUpdate(_:)), name: NSNotification.Name(rawValue: AcaiaScaleWeight), object: nil)
            
            let chartViewController = ChartViewController()
            navigationController?.pushViewController(chartViewController, animated: true)
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
}



