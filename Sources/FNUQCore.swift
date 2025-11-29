// FNUQCore - A Core Library for FNUQ

import Foundation

// Provide hv_* typealiases so sources can compile regardless of Hypervisor availability
public typealias hv_vm_t = Int
public typealias hv_vcpu_t = Int
public typealias hv_vcpu_exit_t = Int
public typealias hv_size_t = Int
public typealias hv_x86_reg_t = Int
public typealias hv_memory_flags_t = UInt64

public let HV_CAP_VM: Int32 = 1
public let HV_SUCCESS: Int32 = 0

public struct SystemInfo {
    public let architecture: String
    public let memorySize: UInt64
    public let cpuCount: Int
    public let isHypervisorSupported: Bool

    public init() {
        #if arch(arm64)
        self.architecture = "arm64"
        #elseif arch(x86_64)
        self.architecture = "x86_64"
        #else
        self.architecture = "unknown"
        #endif

        self.memorySize = ProcessInfo.processInfo.physicalMemory
        self.cpuCount = ProcessInfo.processInfo.processorCount

        // Default to false in this build environment; enable real detection on macOS when ready.
        self.isHypervisorSupported = false
    }
}

public enum FNUQCore {
    public static let version = "1.0.0"
    public static let author = "Saladin5101"

    public static var isSupported: Bool { return SystemInfo().isHypervisorSupported }
    public static func systemInfo() -> SystemInfo { return SystemInfo() }
}
