import UIKit
import AcaiaSDK

class PreShotDataViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var Dose: Double = 0.0 {
        didSet {
            doseLabel.text = "Dose: \(Dose)"
        }
    }
    var doseSet: Bool = false
    var Grind: Double = 17.0 {
        didSet {
            grindLabel.text = "Grind: \(Grind)"
        }
    }
    var RPM: Double = 700.0 {
        didSet {
            rpmLabel.text = "RPM: \(RPM)"
        }
    }
    var PreWet: Bool = false {
        didSet {
            preWetLabel.text = "PreWet: \(PreWet ? "On" : "Off")"
        }
    }
    let doseLabel = UILabel()
    let grindLabel = UILabel()
    let rpmLabel = UILabel()
    let preWetLabel = UILabel()
    
    
    let doseButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doseButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let grindPicker = UIPickerView()
    let rpmPicker = UIPickerView()
    let preWetSwitch = UISwitch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup UI elements here
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(onWeightUpdate(_:)), name: NSNotification.Name(rawValue: AcaiaScaleWeight), object: nil)
        
        // Set default picker values
        grindPicker.selectRow(Int(Grind * 2), inComponent: 0, animated: false)
        rpmPicker.selectRow(Int((RPM - 600) / 100), inComponent: 0, animated: false)
        
        // Add target to preWetSwitch
        preWetSwitch.addTarget(self, action: #selector(preWetSwitchChanged), for: .valueChanged)
    }
    
    func setupUI() {
        
        // Add UI elements to the view
        self.view.addSubview(doseLabel)
        self.view.addSubview(doseButton)
        self.view.addSubview(grindLabel)
        self.view.addSubview(grindPicker)
        self.view.addSubview(rpmLabel)
        self.view.addSubview(rpmPicker)
        self.view.addSubview(preWetLabel)
        self.view.addSubview(preWetSwitch)
        self.view.addSubview(nextButton)
        
        // Set the data source and delegate of the pickers
        grindPicker.dataSource = self
        grindPicker.delegate = self
        grindPicker.backgroundColor = .tertiarySystemBackground
        rpmPicker.dataSource = self
        rpmPicker.delegate = self
        rpmPicker.backgroundColor = .tertiarySystemBackground
        
        // Set properties of UI elements
        doseLabel.text = "Dose: \(Dose)"
        grindLabel.text = "Grind: \(Grind)"
        grindLabel.textColor = .white
        rpmLabel.text = "RPM: \(RPM)"
        preWetLabel.text = "PreWet: \(PreWet ? "On" : "Off")"
        doseButton.setTitle("Set", for: .normal)
        nextButton.setTitle("Next", for: .normal)
        
        // Set up constraints
        doseLabel.translatesAutoresizingMaskIntoConstraints = false
        doseButton.translatesAutoresizingMaskIntoConstraints = false
        grindLabel.translatesAutoresizingMaskIntoConstraints = false
        grindPicker.translatesAutoresizingMaskIntoConstraints = false
        rpmLabel.translatesAutoresizingMaskIntoConstraints = false
        rpmPicker.translatesAutoresizingMaskIntoConstraints = false
        preWetLabel.translatesAutoresizingMaskIntoConstraints = false
        preWetSwitch.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            grindPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            grindPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            grindLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:  -80),
            grindLabel.centerXAnchor.constraint(equalTo: grindPicker.centerXAnchor),
            
            rpmPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rpmPicker.leadingAnchor.constraint(equalTo: grindPicker.trailingAnchor),
            rpmLabel.centerXAnchor.constraint(equalTo: rpmPicker.centerXAnchor),
            rpmLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:  -80),
            
            doseButton.trailingAnchor.constraint(equalTo: grindPicker.leadingAnchor, constant:  -40),
            doseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            doseLabel.centerXAnchor.constraint(equalTo: doseButton.centerXAnchor),
            doseLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:  -80),
            
            preWetLabel.centerYAnchor.constraint(equalTo: preWetSwitch.centerYAnchor),
            preWetLabel.trailingAnchor.constraint(equalTo: preWetSwitch.leadingAnchor, constant: -20),
            preWetSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            preWetSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ])
        
        
        
        // Set the width of the pickers
        grindPicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        grindPicker.heightAnchor.constraint(equalToConstant: 100).isActive = true
        rpmPicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        rpmPicker.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        doseButton.widthAnchor.constraint(equalToConstant: doseButton.frame.size.width + 100).isActive = true
        doseButton.heightAnchor.constraint(equalToConstant: doseButton.frame.size.height + 50).isActive = true
    }
}



extension PreShotDataViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == grindPicker {
            // Grind ranges from 0 to 30 in 0.5 intervals, so there are 61 values
            return 61
        } else if pickerView == rpmPicker {
            // RPM ranges from 100 to 1800 in 100 intervals, so there are 18 values
            return 13
        } else {
            return 0
        }
    }
    
    @objc func doseButtonPressed() {
        doseSet = !doseSet
        print(doseSet)
    }
    
    @objc func nextButtonPressed() {
    }
    
    @objc func preWetSwitchChanged(_ sender: UISwitch) {
    PreWet = sender.isOn
}
    
    @objc func onWeightUpdate(_ notification: NSNotification) {
        guard let weight = notification.userInfo?[AcaiaScaleUserInfoKeyWeight] as? Double else { return }
        let truncatedWeight = round(weight * 1000) / 1000
        if !doseSet {
            Dose = truncatedWeight
        }
    }
    
  
    
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title: String
        if pickerView == grindPicker {
            // Grind ranges from 0 to 30 in 0.5 intervals
            title = String(format: "%.1f", Double(row) * 0.5)
        } else if pickerView == rpmPicker {
            // RPM ranges from 600 to 1800 in 100 intervals
            title = String(row * 100 + 600)
        } else {
            return nil
        }
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == grindPicker {
            // Grind ranges from 0 to 30 in 0.5 intervals
            Grind = Double(row) * 0.5
            grindLabel.text = "Grind: \(Grind)"
        } else  if pickerView == rpmPicker {
            // RPM ranges from 600 to 1800 in 100 intervals
            RPM = Double(row * 100 + 600)
            rpmLabel.text = "RPM: \(RPM)"
        }
    }
}
