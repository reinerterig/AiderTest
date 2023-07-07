import UIKit
import DGCharts // or the chart library you're using

class ChartViewController: UIViewController {
    var startButton: UIButton!
    var weightChart: LineChartView!
    var flowChart: LineChartView!
    var isLogging: Bool = false
    var startTime: Date?
    var weightData: [ChartDataEntry] = []
    var flowData: [ChartDataEntry] = []
    var weight: ChartType = .weight // Modify 'weight' member to be of type 'ChartType'

    // Modify 'displayChart' method to take an argument and implement chart displaying logic
    func displayChart(_ type: ChartType) {
        switch type {
        case .weight:
            let weightDataSet = LineChartDataSet(entries: weightData, label: "Weight")
            weightDataSet.colors = [NSUIColor.blue]
            weightDataSet.drawCirclesEnabled = false // Disable dots
            weightDataSet.mode = .cubicBezier // Enable cubic bezier curve
            weightChart.data = LineChartData(dataSet: weightDataSet)
        case .flow:
            let flowDataSet = LineChartDataSet(entries: flowData, label: "Flow")
            flowDataSet.colors = [NSUIColor.red]
            flowDataSet.drawCirclesEnabled = false // Disable dots
            flowDataSet.mode = .cubicBezier // Enable cubic bezier curve
            flowChart.data = LineChartData(dataSet: flowDataSet)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        // Create and setup the start button
        startButton = UIButton(type: .system)
        startButton.setTitle("Start", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)

        // Create and setup the weight chart
        weightChart = LineChartView()
        weightChart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weightChart)

        // Create and setup the flow chart
        flowChart = LineChartView()
        flowChart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flowChart)

        // Setup constraints
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            weightChart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            weightChart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            weightChart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            weightChart.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5, constant: -20),
            flowChart.topAnchor.constraint(equalTo: weightChart.bottomAnchor, constant: 20),
            flowChart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            flowChart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            flowChart.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20)
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
        }
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

        // Update the charts
        DispatchQueue.main.async {
            self.updateCharts()
        }
    }

    func updateCharts() {
        // Update the weight chart
        let weightDataSet = LineChartDataSet(entries: weightData, label: "Weight")
        weightDataSet.colors = [NSUIColor.blue]
        weightDataSet.drawCirclesEnabled = false // Disable dots
        weightDataSet.mode = .cubicBezier // Enable cubic bezier curve
        weightChart.data = LineChartData(dataSet: weightDataSet)

        // Update the flow chart
        let flowDataSet = LineChartDataSet(entries: flowData, label: "Flow")
        flowDataSet.colors = [NSUIColor.red]
        flowDataSet.drawCirclesEnabled = false // Disable dots
        flowDataSet.mode = .cubicBezier // Enable cubic bezier curve
        flowChart.data = LineChartData(dataSet: flowDataSet)
    }

   
}
