//
//  Group.swift
//  Multithreading
//
//  Created by (_:) on 16.10.2022.
//

import Foundation

struct Group {
    static func test(groupCount: Int = 20) {
        guard groupCount >= 1 else { return }
        
        let group = DispatchGroup()
        
        let concurrentQueue = DispatchQueue(label: "com.github-vanyabiryuk.concurrent-queue",
                                            attributes: .concurrent)
        let notificationQueue = DispatchQueue(label: "com.github-vanyabiryuk.concurrent-queue")
        
        for i in 1...groupCount {
            concurrentQueue.async(group: group) {
                sleep(UInt32.random(in: 0...4))
                print("[\(i)] work item's work is done!")
            }
        }
        
        group.notify(queue: notificationQueue) {
            print("All work items finished their work!")
        }
        
        while true {  }
    }
}
