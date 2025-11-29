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

public enum FNUQError: Error, CustomStringConvertible {
    // System errors
    case hypervisorNotSupported
    case insufficientResources
    case permissionDenied
    
    // VM errors
    case vmNotCreated
    case vmCreationFailed(Int32)
    case vmAlreadyRunning
    case vmNotRunning
    
    // Memory errors
    case memoryMappingFailed(Int32)
    case memoryUnmappingFailed(Int32)
    case invalidAddress
    case bufferTooSmall
    case memoryAllocationFailed
    
    // vCPU errors
    case vcpuNotCreated
    case vcpuCreationFailed(Int32)
    case vcpuExecutionFailed(Int32)
    case vcpuAlreadyRunning
    case registerReadFailed(Int32)
    case registerWriteFailed(Int32)
    
    // Arch errors
    case architectureNotSupported
    case instructionNotSupported
    
    public var description: String {
        switch self {
        case .hypervisorNotSupported:
            return "Hypervisor is not supported on this system"
        case .insufficientResources:
            return "Insufficient system resources"
        case .permissionDenied:
            return "Permission denied - check virtualization settings"
            
        case .vmNotCreated:
            return "Virtual machine not created"
        case .vmCreationFailed(let code):
            return "Failed to create VM (error: \(code))"
        case .vmAlreadyRunning:
            return "Virtual machine is already running"
        case .vmNotRunning:
            return "Virtual machine is not running"
            
        case .memoryMappingFailed(let code):
            return "Failed to map memory (error: \(code))"
        case .memoryUnmappingFailed(let code):
            return "Failed to unmap memory (error: \(code))"
        case .invalidAddress:
            return "Invalid memory address"
        case .bufferTooSmall:
            return "Buffer size is too small"
        case .memoryAllocationFailed:
            return "Failed to allocate memory"
            
        case .vcpuNotCreated:
            return "vCPU not created"
        case .vcpuCreationFailed(let code):
            return "Failed to create vCPU (error: \(code))"
        case .vcpuExecutionFailed(let code):
            return "vCPU execution failed (error: \(code))"
        case .vcpuAlreadyRunning:
            return "vCPU is already running"
        case .registerReadFailed(let code):
            return "Failed to read register (error: \(code))"
        case .registerWriteFailed(let code):
            return "Failed to write register (error: \(code))"
            
        case .architectureNotSupported:
            return "Architecture not supported"
        case .instructionNotSupported:
            return "Instruction not supported"
        }
    }
    
    public var errorCode: Int32 {
        switch self {
        case .hypervisorNotSupported: return -1000
        case .insufficientResources: return -1001
        case .permissionDenied: return -1002
            
        case .vmNotCreated: return -2000
        case .vmCreationFailed(let code): return code
        case .vmAlreadyRunning: return -2001
        case .vmNotRunning: return -2002
            
        case .memoryMappingFailed(let code): return code
        case .memoryUnmappingFailed(let code): return code
        case .invalidAddress: return -3000
        case .bufferTooSmall: return -3001
        case .memoryAllocationFailed: return -3002
            
        case .vcpuNotCreated: return -4000
        case .vcpuCreationFailed(let code): return code
        case .vcpuExecutionFailed(let code): return code
        case .vcpuAlreadyRunning: return -4001
        case .registerReadFailed(let code): return code
        case .registerWriteFailed(let code): return code
            
        case .architectureNotSupported: return -5000
        case .instructionNotSupported: return -5001
        }
    }
}
