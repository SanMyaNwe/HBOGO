//
//  Network.swift
//  HBO GO
//
//  Created by Riki on 8/3/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import SystemConfiguration
import CoreTelephony

public enum ReachabilityType: CustomStringConvertible {
    
    case WWAN
    case WiFi
    
    public var description: String {
        switch self {
        case .WWAN: return "WWAN"
        case .WiFi: return "WiFi"
        }
    }
}



class Network {
    
    func getSSID() -> String {
        
        if let interfaces:CFArray = CNCopySupportedInterfaces() {
            
            for i in 0..<CFArrayGetCount(interfaces){
                
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as NSDictionary?
                    return interfaceData?["SSID"] as! String
                }
            }
        }
        
        return ""
    }
    
    func getNetworkType() -> ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = (withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return .Unknown
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .Unknown
        }
        
        return ReachabilityStatus(reachabilityFlags: flags)
    }
}

public enum ReachabilityStatus: CustomStringConvertible  {
    case Offline
    case Online(ReachabilityType)
    case Unknown
    
    public var description: String {
        switch self {
        case .Offline: return "Offline"
        case .Online(let type): return "Online (\(type))"
        case .Unknown: return "Unknown"
        }
    }
}

extension ReachabilityStatus {
    
    public init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .Online(.WWAN)
            } else {
                self = .Online(.WiFi)
            }
        } else {
            self =  .Offline
        }
    }
}
