//
//  Reachability.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 11.01.2025.
//

import Foundation
import Network

final class Reachability {
    static var shared = Reachability()
    lazy private var monitor = NWPathMonitor()

    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    func startNetworkReachabilityObserver() {
        monitor.pathUpdateHandler = { path in
        }
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
}
