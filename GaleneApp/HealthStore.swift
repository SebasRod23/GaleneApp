//
//  HealthStore.swift
//  GaleneApp
//
//  Created by user190842 on 5/12/21.
//

import Foundation
import HealthKit

class Healthstore{
    
    var healthStore: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
            
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool)-> Void){
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        guard let healthStore = self.healthStore else{return completion(false)}
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            completion(success)
        }
    }
    
}
