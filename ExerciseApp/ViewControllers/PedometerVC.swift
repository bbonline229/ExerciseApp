//
//  PedometerVC.swift
//  ExerciseApp
//
//  Created by Jack on 6/28/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import Charts

class PedometerVC: UIViewController {
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var chartView: BarChartView!
    
    private var pedometerInfo: PedometerInfo = PedometerInfo() {
        didSet {
            stepLabel.text = pedometerInfo.stepDescription
            calorieLabel.text = pedometerInfo.calorieDiscription
            distanceLabel.text = pedometerInfo.distanceDiscription
        }
    }
    
    private var pedometerService = PedometerService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setChartView()
        setupPedometer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        pedometerService.stopUpdatePedoMeter()
    }
    
    private func setupPedometer() {
        pedometerService.startUpdatePedoMeterStep { status in
            switch status {
            case let .success(step, distance), let .unknown(step, distance):
                DispatchQueue.main.async {
                    self.queryPedometer()
                    self.pedometerInfo = PedometerInfo(step: step, distance: distance)
                }
            case .noAuthorize:
                print("No Authorize")
            }
        }
    }
    
    private func queryPedometer() {
        pedometerService.queryPedoMeterResult(withDayBefore: 6) { (pedometerInfos) in
            print(pedometerInfos)
            let doubleStep = pedometerInfos.map({
                Double($0.step)
            })
            
            let daysName = PedometerInfo.requestRangeDaysName()
            
            DispatchQueue.main.async {
                self.setChart(with: doubleStep, xValues: daysName)
            }
        }
    }
    
    private func setChartView() {
        chartView.backgroundColor = .white
        chartView.xAxis.labelPosition = .bottom
    }
    
    private func setChart(with data: [Double], xValues: [String]){
        let unitsSold = data
        
        chartView.setBarChartData(xValues: xValues, yValues: unitsSold, label: "一週步數")
    }

}

extension BarChartView {
    
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    fileprivate func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: label)
        chartDataSet.colors = [UIColor.lightGreen]
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        self.data = chartData
    }
}
