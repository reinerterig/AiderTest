//
//  ViewController.swift
//  AiderTest
//
//  Created by reinert wasserman on 7/7/2023.
//

import UIKit
import AcaiaSDK

class ViewController: UIViewController {

    var weightLabel: UILabel!
    var connectButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        // Create and setup the label
        weightLabel = UILabel()
        weightLabel.text = "Hello World"
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weightLabel)

        // Create and setup the button
        connectButton = UIButton(type: .system)
        connectButton.setTitle("Connect", for: .normal)
        connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectButton)

        // Setup constraints
        NSLayoutConstraint.activate([
            weightLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            connectButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            connectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func connectButtonTapped() {
        let scaleTableViewController = ScaleTableViewController()
        navigationController?.pushViewController(scaleTableViewController, animated: true)
    }
}



