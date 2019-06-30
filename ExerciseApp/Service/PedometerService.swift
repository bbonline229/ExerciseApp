//
//  PedometerService.swift
//  ExerciseApp
//
//  Created by Jack on 6/28/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import CoreMotion

enum PedometerStatus {
    case success(Int, Double)
    case unknown(Int, Double)
    case noAuthorize
}

class PedometerService {

    let pedometer = CMPedometer()
    let calendar = Calendar.current
    
    var date: Date? {
        get {
            var component = calendar.dateComponents([.year, .month, .day], from: Date())
            component.hour = 0
            component.minute = 0
            component.second = 0
            
            return calendar.date(from: component)
        }
    }

    var isCoreMotionAuthorized: Bool {
        if #available(iOS 11.0, *) {
            return !(CMPedometer.authorizationStatus() == .denied)
        } else {
            // Fallback on earlier versions
            return CMSensorRecorder.isAuthorizedForRecording()
        }
    }

    // MARＫ: - 從計步器取得當天的步數與距離
    func startUpdatePedoMeterStep(completion: @escaping (PedometerStatus) -> Void) {
        guard let date = date else {
            completion(.unknown(0, 0.0))
            return
        }
        
        pedometer.startUpdates(from: date) { (pedometerData, error) in
        
            if let err = error as NSError?{
                if err.code == 105 {
                    completion(.noAuthorize)
                } else {
                   completion(.unknown(0, 0.0))
                }
            }
            
            guard let pedometerData = pedometerData,
                let step = Int(pedometerData.numberOfSteps.stringValue),
                let distanceStringValue = pedometerData.distance?.stringValue,
                let distanceDoubleValue = Double(distanceStringValue) else {
                completion(.unknown(0, 0.0))
                return
            }
            
            //let distance = (distanceDoubleValue / 1000).roundToDecimal(2)
            
            completion(.success(step, distanceDoubleValue))
        }
    }

    // MARK: - 取得計步器步數，但若是第一次，則會先要求用戶提供計步器步數權限
    func queryPedoMeterStep(completion: @escaping (Int) -> Void) {
        guard let date = date else {
            completion(0)
            return
        }
        
        pedometer.queryPedometerData(from: date, to: Date()) { (pedometerData, error) in
            guard let pedometerData = pedometerData, let stepValue = Int(pedometerData.numberOfSteps.stringValue) else {
                completion(0)
                return
            }
            print("stepValue:\(pedometerData)")
            completion(stepValue)
        }
    }

    // MARK: - 從計步器取得其他天的步數
    func queryPedoMeterResult(withDayBefore datebefore: Int, completion: @escaping ([PedometerInfo]) -> Void) {
        let queryDayBefore = datebefore // 查詢幾天前的資料, 0: 今天, 1: 昨天, 以此類推 (最多 7 天)

        var results = [PedometerInfo]()

        var start: Date = Date().midnight
        var end: Date = Date().dayEnd

        let pedoMeterGroup = DispatchGroup()

        for _ in 0...queryDayBefore {

            pedoMeterGroup.enter()

            query(from: start, to: end) { (pedometerData) in
                let step = Int(truncating: pedometerData?.numberOfSteps ?? 0)
                let distance = Double(truncating: pedometerData?.distance ?? 0)
                
                let pedometerInfo = PedometerInfo(step: step, distance: distance)
                results.append(pedometerInfo)

                start = Calendar.current.date(byAdding: .day, value: -1, to: start)!
                end = Calendar.current.date(byAdding: .day, value: -1, to: end)!

                pedoMeterGroup.leave()
            }
            pedoMeterGroup.wait()
        }

        pedoMeterGroup.notify(queue: .main) {
            completion(results.reversed())
        }
    }
    
    func query(from: Date, to: Date, completion: @escaping (CMPedometerData?) -> Void) {
        pedometer.queryPedometerData(from: from, to: to) { (pedometerData, error) in
            guard let pedometerData = pedometerData else {
                completion(nil)
                return
            }
            print("steppppValue:\(pedometerData)")
            completion(pedometerData)
        }
    }

    // MARK: - 結束計步器
    func stopUpdatePedoMeter() {
        pedometer.stopUpdates()
    }
}
