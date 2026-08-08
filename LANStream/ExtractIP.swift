//
//  ExtractIP.swift
//  LANStream
//
//  Created by Amay Raj Srivastav on 08/08/26.
//

import Foundation

func getWiFiIPAddress() -> String? {
    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>?

    guard getifaddrs(&ifaddr) == 0 else { return nil }
    defer { freeifaddrs(ifaddr) }

    var pointer = ifaddr
    while pointer != nil {
        defer { pointer = pointer?.pointee.ifa_next }

        let interface = pointer!.pointee
        let addrFamily = interface.ifa_addr.pointee.sa_family

        if addrFamily == UInt8(AF_INET) {
            let name = String(cString: interface.ifa_name)

            if name == "en0" {
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(
                    interface.ifa_addr,
                    socklen_t(interface.ifa_addr.pointee.sa_len),
                    &hostname,
                    socklen_t(hostname.count),
                    nil,
                    0,
                    NI_NUMERICHOST
                )
                address = String(cString: hostname)
            }
        }
    }

    return address
}

