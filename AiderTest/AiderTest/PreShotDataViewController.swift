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
        // Add UI elements to the view and setup constraints
    }
}
