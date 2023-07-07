import UIKit
import DGCharts // or the chart library you're using

class ChartViewController: UIViewController {
    var startButton: UIButton!
    var weightChart: LineChartView!
    var flowChart: LineChartView!
    var isLogging: Bool = false
    var weightData: [ChartDataEntry] = []
    var flowData: [ChartDataEntry] = []

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

    var timer: Timer?

    func startLogging() {
        // Reset the chart data
        weightData = []
        flowData = []

        // Start a timer that fires every 0.1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(logData), userInfo: nil, repeats: true)
    }

    func stopLogging() {
        // Invalidate the timer to stop logging data
        timer?.invalidate()
        timer = nil
    }

    @objc func logData() {
        // Get the current time, weight, and flow
        let time = Date().timeIntervalSince(startLoggingTime)
        let weight = getWeight() // You need to implement this method to get the current weight
        let flow = getFlow() // You need to implement this method to get the current flow

        // Append the new data to the chart data
        weightData.append(ChartDataEntry(x: time, y: weight))
        flowData.append(ChartDataEntry(x: time, y: flow))

        // Update the charts
        updateCharts()
    }

    func updateCharts() {
        // Update the weight chart
        let weightDataSet = LineChartDataSet(entries: weightData, label: "Weight")
        weightDataSet.colors = [NSUIColor.blue]
        weightChart.data = LineChartData(dataSet: weightDataSet)

        // Update the flow chart
        let flowDataSet = LineChartDataSet(entries: flowData, label: "Flow")
        flowDataSet.colors = [NSUIColor.red]
        flowChart.data = LineChartData(dataSet: flowDataSet)
    }

   
}
