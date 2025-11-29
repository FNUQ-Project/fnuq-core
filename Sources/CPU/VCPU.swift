// FNUQCore - A Core Library for FNUQ
// Copyright (C) 2025 Saladin5101
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
import Foundation

#if canImport(Hypervisor)
import Hypervisor

// Hypervisor-backed VCPU interface would go here when Hypervisor.framework is available.
// For now, keep a simple wrapper that uses compatibility fallback unless full API bindings are implemented.
public final class VCPU {
    private var vcpu: hv_vcpu_t?
    private var isCreated = false
    private var isRunning = false

    public let id: Int
    public private(set) var exitReason: hv_vcpu_exit_t?

    public init(vm: hv_vm_t, id: Int = 0) throws {
        self.id = id
        try create(vm: vm)
    }

    deinit {
        destroy()
    }
}

// The Hypervisor-specific implementation is intentionally left minimal here. Implementers
// should replace the create/run/read/write calls with the appropriate hv_* calls as needed.

extension VCPU {
    private func create(vm: hv_vm_t) throws {
        // Attempt to emulate if not wired to real hv API
        self.vcpu = 1
        self.isCreated = true
        print("[FNUQCore] vCPU created!(ID: \(id))")
    }

    private func destroy() {
        if let _ = vcpu, isCreated {
            stop()
            self.vcpu = nil
            self.isCreated = false
            print("[FNUQCore] vCPU is killed ! (ID: \(id))")
        }
    }
}

extension VCPU {
    public func run() throws -> hv_vcpu_exit_t {
        guard let _ = vcpu else { throw FNUQError.vcpuNotCreated }
        guard !isRunning else { throw FNUQError.vcpuAlreadyRunning }
        isRunning = true
        defer { isRunning = false }
        let exitReason = hv_vcpu_exit_t(0)
        self.exitReason = exitReason
        return exitReason
    }

    public func stop() {
        guard isRunning else { return }
        isRunning = false
    }

    public func setRegister(_ register: hv_x86_reg_t, value: UInt64) throws {
        guard vcpu != nil else { throw FNUQError.vcpuNotCreated }
    }

    public func getRegister(_ register: hv_x86_reg_t) throws -> UInt64 {
        guard vcpu != nil else { throw FNUQError.vcpuNotCreated }
        return 0
    }
}

// MARK: - Register
extension VCPU {
    public enum Register: UInt32 {
        case rax = 0
        case rbx = 1
        case rcx = 2
        case rdx = 3
        case rsi = 4
        case rdi = 5
        case rsp = 6
        case rbp = 7
        case r8 = 8
        case r9 = 9
        case r10 = 10
        case r11 = 11
        case r12 = 12
        case r13 = 13
        case r14 = 14
        case r15 = 15
        case rip = 16
        case rflags = 17
    }
}

#else

public final class VCPU {
    private var vcpu: Int = 0
    private var isCreated = false
    private var isRunning = false

    public let id: Int
    public private(set) var exitReason: Int32 = 0

    public init(vm: Int, id: Int = 0) throws {
        self.id = id
        try create(vm: vm)
    }

    deinit {
        destroy()
    }
}

// MARK: - Life Managment
extension VCPU {
    private func create(vm: Int) throws {
        // In environments where Hypervisor.framework isn't available at runtime,
        // provide a lightweight emulation: assign a unique numeric id.
        let createdId = id
        self.vcpu = createdId
        self.isCreated = true
        print("[FNUQCore] vCPU created!(ID: \(id))")
    }

    private func destroy() {
        if isCreated {
            stop()
            self.vcpu = 0
            self.isCreated = false
            print("[FNUQCore] vCPU is killed ! (ID: \(id))")
        }
    }
}

// MARK: - Run control
extension VCPU {
    public func run() throws -> Int32 {
        guard isCreated else {
            throw FNUQError.vcpuNotCreated
        }

        guard !isRunning else {
            throw FNUQError.vcpuAlreadyRunning
        }

        isRunning = true
        defer { isRunning = false }

        // Emulate a basic run: set exitReason to zero
        let exitReason = Int32(0)
        self.exitReason = exitReason
        return exitReason
    }

    public func stop() {
        guard isRunning else { return }
        isRunning = false
    }

    public func setRegister(_ register: Int, value: UInt64) throws {
        guard isCreated else { throw FNUQError.vcpuNotCreated }
        // In this compatibility build we do not actually set hardware registers.
    }

    public func getRegister(_ register: Int) throws -> UInt64 {
        guard isCreated else { throw FNUQError.vcpuNotCreated }
        return 0
    }
}

// MARK: - Register
extension VCPU {
    // x86_64 Register
    public enum Register: UInt32 {
        case rax = 0
        case rbx = 1
        case rcx = 2
        case rdx = 3
        case rsi = 4
        case rdi = 5
        case rsp = 6
        case rbp = 7
        case r8 = 8
        case r9 = 9
        case r10 = 10
        case r11 = 11
        case r12 = 12
        case r13 = 13
        case r14 = 14
        case r15 = 15
        case rip = 16
        case rflags = 17
    }
}
#endif
