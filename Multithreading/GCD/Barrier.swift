//
//  Barrier.swift
//  Multithreading
//
//  Created by (_:) on 17.10.2022.
//

import Foundation

struct Barrier {
    static var array = Array(repeating: -1, count: 200_000)
    static var queue = DispatchQueue(label: "com.github-vanyabiryu.concurrent-queue", attributes: .concurrent)
    
    static func test(withBarrier: Bool) {
        queue.async {
            for index in array.indices {
                array[index] = (index % 7) * (index % 3 == 0 ? 12 : -12)
                if index.isMultiple(of: 10_000) {
                    print("[...] \(index) iterations passed")
                }
            }
        }
        
        queue.async(flags: withBarrier ? [.barrier] : []) {
            print("Sum counting began")
            var totalSum = 0
            for element in array {
                totalSum += element
            }
            print("Sum of the array's elements is \(totalSum)")
        }
        
        queue.async {
            print("Another async method call")
        }
        
        while true {  }
    }
    
    /*
     withBarrier == false:
  -> Another async method call
  -> Sum counting began
     [...] 0 iterations passed
     [...] 10000 iterations passed
     [...] 20000 iterations passed
     [...] 30000 iterations passed
     [...] 40000 iterations passed
     [...] 50000 iterations passed
  -> Sum of the array's elements is -199999
     [...] 60000 iterations passed
     [...] 70000 iterations passed
     [...] 80000 iterations passed
     [...] 90000 iterations passed
     [...] 100000 iterations passed
     [...] 110000 iterations passed
     [...] 120000 iterations passed
     [...] 130000 iterations passed
     [...] 140000 iterations passed
     [...] 150000 iterations passed
     [...] 160000 iterations passed
     [...] 170000 iterations passed
     [...] 180000 iterations passed
     [...] 190000 iterations passed
     
     
     
     withBarrier == true:
     [...] 0 iterations passed
     [...] 10000 iterations passed
     [...] 20000 iterations passed
     [...] 30000 iterations passed
     [...] 40000 iterations passed
     [...] 50000 iterations passed
     [...] 60000 iterations passed
     [...] 70000 iterations passed
     [...] 80000 iterations passed
     [...] 90000 iterations passed
     [...] 100000 iterations passed
     [...] 110000 iterations passed
     [...] 120000 iterations passed
     [...] 130000 iterations passed
     [...] 140000 iterations passed
     [...] 150000 iterations passed
     [...] 160000 iterations passed
     [...] 170000 iterations passed
     [...] 180000 iterations passed
     [...] 190000 iterations passed
  -> Sum counting began
  -> Sum of the array's elements is -2399928
  -> Another async method call
     */
}
