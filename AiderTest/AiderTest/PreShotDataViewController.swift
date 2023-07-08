import UIKit

class PreShotDataViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var Dose: Double = 0.0
    var Grind: Double = 17.0
    var RPM: Double = 100.0
    var PreWet: Bool = false

    let doseLabel = UILabel()
    let grindLabel = UILabel()
    let rpmLabel = UILabel()
    let preWetLabel = UILabel()

    let doseButton = UIButton()
    let grindPicker = UIPickerView()
    let rpmPicker = UIPickerView()
    let preWetSwitch = UISwitch()

    let nextButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup UI elements here
        setupUI()
    }

    func setupUI() {
        // Add UI elements to the view
        view.addSubview(doseLabel)
        view.addSubview(grindLabel)
        view.addSubview(rpmLabel)
        view.addSubview(preWetLabel)
        view.addSubview(doseButton)
        view.addSubview(grindPicker)
        view.addSubview(rpmPicker)
        view.addSubview(preWetSwitch)
        view.addSubview(nextButton)

        // Set the data source and delegate of the pickers
        grindPicker.dataSource = self
        grindPicker.delegate = self
        rpmPicker.dataSource = self
        rpmPicker.delegate = self
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == grindPicker {
            // Grind ranges from 0 to 30 in 0.5 intervals, so there are 61 values
            return 61
        } else if pickerView == rpmPicker {
            // RPM ranges from 100 to 1800 in 100 intervals, so there are 18 values
            return 18
        } else {
            return 0
        }
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == grindPicker {
            // Grind ranges from 0 to 30 in 0.5 intervals
            return String(format: "%.1f", Double(row) * 0.5)
        } else if pickerView == rpmPicker {
            // RPM ranges from 100 to 1800 in 100 intervals
            return String(row * 100 + 100)
        } else {
            return nil
        }
    }

        // Set properties of UI elements
        doseLabel.text = "Dose: \(Dose)"
        grindLabel.text = "Grind: \(Grind)"
        rpmLabel.text = "RPM: \(RPM)"
        preWetLabel.text = "PreWet: \(PreWet ? "On" : "Off")"
        doseButton.setTitle("Set", for: .normal)
        nextButton.setTitle("Next", for: .normal)

        // Set up constraints
        // Note: You'll need to replace these placeholder constraints with the actual constraints you want
        doseLabel.translatesAutoresizingMaskIntoConstraints = false
        grindLabel.translatesAutoresizingMaskIntoConstraints = false
        rpmLabel.translatesAutoresizingMaskIntoConstraints = false
        preWetLabel.translatesAutoresizingMaskIntoConstraints = false
        doseButton.translatesAutoresizingMaskIntoConstraints = false
        grindPicker.translatesAutoresizingMaskIntoConstraints = false
        rpmPicker.translatesAutoresizingMaskIntoConstraints = false
        preWetSwitch.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        // Add constraints here
       
            
        NSLayoutConstraint.activate([
            // Dose button is 20 points from the Grind picker's leading edge
            doseButton.leadingAnchor.constraint(equalTo: grindPicker.leadingAnchor, constant: -20),
            // RPM picker is 20 points from the Grind picker's trailing edge
            rpmPicker.leadingAnchor.constraint(equalTo: grindPicker.trailingAnchor, constant: 20),
            // All labels are 20 points above their corresponding buttons or pickers
            doseLabel.bottomAnchor.constraint(equalTo: doseButton.topAnchor, constant: -20),
            grindLabel.bottomAnchor.constraint(equalTo: grindPicker.topAnchor, constant: -20),
            rpmLabel.bottomAnchor.constraint(equalTo: rpmPicker.topAnchor, constant: -20),
            preWetLabel.bottomAnchor.constraint(equalTo: preWetSwitch.topAnchor, constant: -20),
            // PreWet switch is 20 points below the Grind picker and centered in the screen
            preWetSwitch.topAnchor.constraint(equalTo: grindPicker.bottomAnchor, constant: 20),
            preWetSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // PreWet label is 20 points to the PreWet switch's leading edge
            preWetLabel.trailingAnchor.constraint(equalTo: preWetSwitch.leadingAnchor, constant: -20),
            // Next button is in the bottom right corner of the screen
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            // centered horizontally in the screen
            grindPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rpmPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Grind picker is centered vertically in the screen
            grindPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
