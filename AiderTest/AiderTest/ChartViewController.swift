import UIKit
import DGCharts // or the chart library you're using

class ChartViewController: UIViewController, UIContextMenuInteractionDelegate {
    var startButton: UIButton!
    var chart: LineChartView!
    var isLogging: Bool = false
    var startTime: Date?
    var weightData: [ChartDataEntry] = []
    var flowData: [ChartDataEntry] = []
    var isDisplayingWeightData: Bool = true
    // Remove 'weight' member

    // Modify 'displayChart' method to take 'weightData' or 'flowData' as an argument and implement chart displaying logic
    func displayChart(_ data: [ChartDataEntry], for chart: LineChartView, with label: String, color: NSUIColor) {
        let dataSet = LineChartDataSet(entries: data, label: label)
        dataSet.colors = [color]
        dataSet.drawCirclesEnabled = false // Disable dots
        dataSet.mode = .cubicBezier // Enable cubic bezier curve
        chart.data = LineChartData(dataSet: dataSet)
    }

    // Add 'toggleChartDisplay' method and make it visible to Objective-C
//
    // Add long press gesture recognizer to the view with minimum press duration of 0.3 seconds
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressRecognizer.minimumPressDuration = 0.3
        view.addGestureRecognizer(longPressRecognizer)
    }

    // Handle long press
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // Show a menu where the gesture was performed
            let location = gesture.location(in: view)
            let interaction = UIContextMenuInteraction(delegate: self)
            view.addInteraction(interaction)
        }
    }
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let toggleAction = UIAction(title: "Toggle", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off) { _ in
            self.toggleChartDisplay()
        }
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [toggleAction])
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in return menu })
    }
    


    func setupUI() {
        // Create and setup the start button
        startButton = UIButton(type: .system)
        startButton.setTitle("Start", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)

    // Create and setup the chart
    chart = LineChartView()
    chart.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(chart)

        // Setup constraints
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
    // Setup constraints
    NSLayoutConstraint.activate([
        chart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        chart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        chart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        chart.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20)
    ])
    }

       
    

    @objc func startButtonTapped() {
        if isLogging {
            isLogging = false
            startButton.setTitle("Start", for: .normal)
            stopLogging()
        } else {
            isLogging = true
            startButton.setTitle("Stop", for: .normal)
            startLogging()
            var chart: LineChartView!
            var isLogging: Bool = false
            var startTime: Date?
            var weightData: [ChartDataEntry] = []
            var flowData: [ChartDataEntry] = []
            var isDisplayingWeightData: Bool = true
        }
    }
        
        @objc func toggleChartDisplay() {
            isDisplayingWeightData = !isDisplayingWeightData
            updateChart()
        }
        
        func startLogging() {
            // Reset the chart data
            weightData = []
            flowData = []
            // Store the start time
            startTime = Date()
        }
        
        func stopLogging() {
            // Reset the start time
            startTime = nil
        }
        
        func logData(time: TimeInterval, weight: Float, flow: Float) {
            // Append the new data to the chart data
            weightData.append(ChartDataEntry(x: time, y: Double(weight)))
            flowData.append(ChartDataEntry(x: time, y: Double(flow)))
            
            // Update the chart
            DispatchQueue.main.async {
                self.updateChart()
            }
        }
        
        func updateChart() {
            let data: [ChartDataEntry]
            let label: String
            let color: NSUIColor
            if isDisplayingWeightData {
                data = weightData
                label = "Weight"
                color = NSUIColor.blue
            } else {
                data = flowData
                label = "Flow"
                color = NSUIColor.red
            }
            
            let dataSet = LineChartDataSet(entries: data, label: label)
            dataSet.colors = [color]
            dataSet.drawCirclesEnabled = false // Disable dots
            dataSet.mode = .cubicBezier // Enable cubic bezier curve
            chart.data = LineChartData(dataSet: dataSet)
        }
    }
