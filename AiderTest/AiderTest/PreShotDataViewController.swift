import UIKit

class PreShotDataViewController: UIViewController {
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
    }
}
