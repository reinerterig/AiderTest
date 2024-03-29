import UIKit
import DGCharts
import AcaiaSDK

class ChartViewController: UIViewController, UIContextMenuInteractionDelegate,UITableViewDelegate,UITableViewDataSource {
    static let shared = ChartViewController()
    var startButton: UIButton!
    var chart: LineChartView!
    var isLogging: Bool = false
    var startTime: Date?
    var weightData: [ChartDataEntry] = []
    var flowData: [ChartDataEntry] = []
    var isDisplayingWeightData: Bool = true
    var preData = false
    
    var menuOptions = ["Toggle"] // Add more options as needed
    var tapRecognizer: UITapGestureRecognizer?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
  
    @objc func startButtonTapped() {
        if AcaiaManager.shared().connectedScale == nil {
            let scaleTableViewController = ScaleTableViewController()
            navigationController?.pushViewController(scaleTableViewController, animated: true)
        } else {
            switch preData {
            case true:
                if isLogging {
                    isLogging = false
                    startButton.setTitle("Start", for: .normal)
                    stopLogging()
                } else {
                    isLogging = true
                    startButton.setTitle("Stop", for: .normal)
                    startLogging()
                }
                preData = !preData
            case false:
                let preShotDataViewController = PreShotDataViewController()
                navigationController?.pushViewController(preShotDataViewController, animated: true)
                preData = !preData
                
            }
        }
    }
}

//MARK: Setup UI
extension ChartViewController {
    func setupUI() {
        // Create and setup the chart
        chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chart)
        
        // Create and setup the start button
        startButton = UIButton(type: .system)
        startButton.setTitle("Start", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            chart.topAnchor.constraint(equalTo: view.topAnchor),
            chart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chart.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
}
//MARK: Observers
extension ChartViewController{
   func setUpObservers(){
       
       let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
       longPressRecognizer.minimumPressDuration = 0.3
       view.addGestureRecognizer(longPressRecognizer)
       
        NotificationCenter.default.addObserver(self, selector: #selector(onDisconnect(_:)), name: NSNotification.Name(rawValue: AcaiaScaleDidDisconnected), object: nil)
    }
}
//MARK: Chart
extension ChartViewController {
    @objc func toggleChartDisplay() {
        isDisplayingWeightData = !isDisplayingWeightData
        updateChart()
    }
    
    @objc func startLogging() {
        weightData = []
        flowData = []
        startTime = Date()
    }
    
    func stopLogging() {
        startTime = nil
    }
    
    func logData(time: TimeInterval, weight: Float, flow: Float) {
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
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        chart.data = LineChartData(dataSet: dataSet)
        chart.notifyDataSetChanged()
    }
    
    func displayChart(_ data: [ChartDataEntry], for chart: LineChartView, with label: String, color: NSUIColor) {
        let dataSet = LineChartDataSet(entries: data, label: label)
        dataSet.colors = [color]
        dataSet.drawCirclesEnabled = false // Disable dots
        dataSet.mode = .cubicBezier // Enable cubic bezier curve
        chart.data = LineChartData(dataSet: dataSet)
    }
}

extension ChartViewController {
    @objc func onDisconnect(_ notification: NSNotification) {
        if !AcaiaManager.shared().scaleList.isEmpty, let scale = AcaiaManager.shared().scaleList.first {
            scale.connect()
        }
    }
    
}
// MARK: long press
extension ChartViewController {
    
    // Handle long press
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // Dismiss any existing menu
            for subview in view.subviews {
                if subview is UITableView {
                    subview.removeFromSuperview()
                }
            }
            // Show a new menu where the gesture was performed
            let location = gesture.location(in: view)
            createTableView(at: location)
        }
    }

    func createTableView(at location: CGPoint) {
        let rowHeight: CGFloat = 44 // Default row height
        let tableViewHeight = CGFloat(menuOptions.count) * rowHeight
        let tableView = UITableView(frame: CGRect(x: location.x, y: location.y, width: 200, height: tableViewHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        chart.addGestureRecognizer(tapRecognizer!)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        for subview in view.subviews {
            if subview is UITableView {
                subview.removeFromSuperview()
            }
        }
        if let recognizer = tapRecognizer {
            chart.removeGestureRecognizer(recognizer)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = menuOptions[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuOptions[indexPath.row] == "Toggle" {
            toggleChartDisplay()
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.removeFromSuperview()
    }
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let toggleAction = UIAction(title: "Toggle", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off) { _ in
            self.toggleChartDisplay()
        }
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [toggleAction])
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in return menu })
    }
    
}
