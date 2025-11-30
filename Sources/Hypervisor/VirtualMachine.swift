// FNUQCore - A Core Library for FNUQ
// VirtualMachine implementation (compatibility build)

import Foundation
import Hypervisor
public final class VirtualMachine {
    private var vm: hv_vm_t?
    private var vcpus: [VCPU] = []
    private var memoryRegions: [MemoryRegion] = []
    private var isRunning = false
    
    public let id = UUID()
    public let configuration: VMConfiguration
    
    public init(configuration: VMConfiguration = VMConfiguration()) throws {
        self.configuration = configuration
        try create()
    }
    
    deinit {
        stop()
        destroy()
    }
    
    // MARK: - Lifecycle
    private func create() throws {
        guard SystemInfo().isHypervisorSupported else {
            throw FNUQError.hypervisorNotSupported
        }
        
        var vmHandle: hv_vm_t = 0
        let result = hv_vm_create(vmHandle as! OS_hv_vm_config)
        guard result == HV_SUCCESS else {
            throw FNUQError.vmCreationFailed(result)
        }
        self.vm = vmHandle
        print("[FNUQCore] VM created (handle: \(vmHandle))")
    }
    
    
    private func destroy() {
        if let vmHandle = vm {
            
            vcpus.forEach { _ in /* noop */ }
            vcpus.removeAll()
            memoryRegions.removeAll()
            self.vm = nil
            isRunning = false
            print("[FNUQCore] VM is killed and removed")
        }
    }
}

// MARK: - Memory Management
extension VirtualMachine {
    public struct MemoryRegion {
        public let guestAddress: UInt64
        public let hostBuffer: UnsafeMutableRawPointer
        public let size: Int

        public init(guestAddress: UInt64, hostBuffer: UnsafeMutableRawPointer, size: Int) {
            self.guestAddress = guestAddress
            self.hostBuffer = hostBuffer
            self.size = size
        }
    }

    public func mapMemory(_ buffer: UnsafeMutableRawPointer,
                          guestAddress: UInt64,
                          size: Int,
                          permissions: MemoryPermissions = [.read, .write, .execute]) throws {
        guard vm != nil else { throw FNUQError.vmNotCreated }
        let region = MemoryRegion(guestAddress: guestAddress, hostBuffer: buffer, size: size)
        memoryRegions.append(region)
        print("[FNUQCore] Memory mapping: 0x\(String(guestAddress, radix: 16)) - Size: \(size)")
    }

    public func unmapMemory(guestAddress: UInt64) throws {
        guard vm != nil else { throw FNUQError.vmNotCreated }
        memoryRegions.removeAll { $0.guestAddress == guestAddress }
        print("[FNUQCore] Memory unmapping: 0x\(String(guestAddress, radix: 16))")
    }
}

// MARK: - VCPU Management
extension VirtualMachine {
    public func createVCPU() throws -> VCPU {
        guard vm != nil else { throw FNUQError.vmNotCreated }
        let vcpu = try VCPU(vm: hv_vm_t(1), id: vcpus.count)
        vcpus.append(vcpu)
        return vcpu
    }

    public func start() throws {
        guard !isRunning else { return }
        if vcpus.isEmpty { _ = try createVCPU() }
        isRunning = true
        print("[FNUQCore] VM is start")
    }

    public func stop() {
        guard isRunning else { return }
        isRunning = false
        print("[FNUQCore] VM is stopped")
    }
}

// MARK: - Config and Status
extension VirtualMachine {
    public struct VMConfiguration {
        public var memorySize: UInt64
        public var vcpuCount: Int
        public var architecture: Architecture

        public init(memorySize: UInt64 = 1 * 1024 * 1024 * 1024,
                    vcpuCount: Int = 1,
                    architecture: Architecture = .current) {
            self.memorySize = memorySize
            self.vcpuCount = vcpuCount
            self.architecture = architecture
        }
    }

    public struct MemoryPermissions: OptionSet {
        public static let read = MemoryPermissions(rawValue: 1 << 0)
        public static let write = MemoryPermissions(rawValue: 1 << 1)
        public static let execute = MemoryPermissions(rawValue: 1 << 2)

        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
    }

    public var status: VMStatus {
        if isRunning { return .running }
        return vm != nil ? .created : .stopped
    }
}

public enum VMStatus {
    case stopped
    case created
    case running
    case error(Error)
}

// Provide manual Equatable conformance because `Error` doesn't conform to Equatable.
extension VMStatus: Equatable {
    public static func == (lhs: VMStatus, rhs: VMStatus) -> Bool {
        switch (lhs, rhs) {
        case (.stopped, .stopped), (.created, .created), (.running, .running):
            return true
        case (.error(let a), .error(let b)):
            return String(describing: a) == String(describing: b)
        default:
            return false
        }
    }
}
