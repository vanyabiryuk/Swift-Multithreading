//
//  MainAsync.swift
//  Multithreading
//
//  Created by (_:) on 17.10.2022.
//

import Foundation

struct MainAsync {
    
    /* MARK: The problem
     The problem is that text "73 is a great number!" will not be printed.
     
     func output:
     [Begin]
     [End]
     */
    static func problem() {
        print("[Begin]")
        // same problem appears when passing .main as an argument to notify() methods
        DispatchQueue.main.async {
            print("73 is a great number!")
        }
        
        sleep(1)
        print("[End]")
    }
    
    /* MARK: The solution?
     The problem disappears if you switch the RunLoop to the default mode after calling the async method.
     At the same time, the program freezes when the RunLoop is switched to another mode.
     Therefore, using methods unrelated to UI updating in DispatchQueue.main is a bad idea.
     Another queue must be used for this. */
    static func solution() {
        print("[Begin]")
        DispatchQueue.main.async {
            print("73 is a great number!")
            print("Mode in async: \(CFRunLoopCopyCurrentMode(CFRunLoopGetMain()!)!.rawValue)")
        }
        CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 2, false)
        print("Mode after CFRunLoopRunInMode(): \(String(describing: CFRunLoopCopyCurrentMode(CFRunLoopGetMain()!)))")
        print("[End]")
    }
}
