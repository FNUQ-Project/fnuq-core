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

public final class MemoryManager {
    private var allocations: [Allocation] = []
    
    public init() {}
    
    deinit {
        cleanup()
    }
}

// MARK: - Memory Manager
extension MemoryManager {
    public struct Allocation {
        public let pointer: UnsafeMutableRawPointer
        public let size: Int
        public let alignment: Int
        
        public init(pointer: UnsafeMutableRawPointer, size: Int, alignment: Int) {
            self.pointer = pointer
            self.size = size
            self.alignment = alignment
        }
    }
    
    public func allocate(size: Int, alignment: Int = 4096) throws -> UnsafeMutableRawPointer {
        guard size > 0 else {
            throw FNUQError.bufferTooSmall
        }
        
        let buffer = aligned_alloc(alignment, size)
        guard let buffer = buffer else {
            throw FNUQError.memoryAllocationFailed
        }
        
        // set 0 to memory
        memset(buffer, 0, size)
        
        let allocation = Allocation(pointer: buffer, size: size, alignment: alignment)
        allocations.append(allocation)
        
        return buffer
    }
    
    public func reallocate(_ pointer: UnsafeMutableRawPointer, newSize: Int) throws -> UnsafeMutableRawPointer {
        guard let index = allocations.firstIndex(where: { $0.pointer == pointer }) else {
            throw FNUQError.invalidAddress
        }
        
        let oldAllocation = allocations[index]
        let newBuffer = try allocate(size: newSize, alignment: oldAllocation.alignment)
        
        // Copy old data
        let copySize = min(oldAllocation.size, newSize)
        memcpy(newBuffer, oldAllocation.pointer, copySize)
        
        // Free old memory
        free(oldAllocation.pointer)
        allocations.remove(at: index)
        
        return newBuffer
    }
    
    public func free(_ pointer: UnsafeMutableRawPointer) {
        if let index = allocations.firstIndex(where: { $0.pointer == pointer }) {
            free(pointer)
            allocations.remove(at: index)
        }
    }
    
    public func cleanup() {
        allocations.forEach { free($0.pointer) }
        allocations.removeAll()
    }
}

// MARK: - Data
extension MemoryManager {
    public func copy(to destination: UnsafeMutableRawPointer,
                    from source: UnsafeRawPointer,
                    size: Int) throws {
        guard size > 0 else {
            throw FNUQError.bufferTooSmall
        }
        
        memcpy(destination, source, size)
    }
    
    public func copy(to destination: UnsafeMutableRawPointer,
                    data: Data,
                    offset: Int = 0) throws {
        guard offset + data.count <= malloc_size(destination) else {
            throw FNUQError.bufferTooSmall
        }

        _ = data.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) in
            guard let base = buffer.baseAddress else { return }
            memcpy(destination.advanced(by: offset), base, data.count)
        }
    }
    
    public func fill(_ pointer: UnsafeMutableRawPointer,
                    with value: UInt8,
                    size: Int) throws {
        guard size > 0 else {
            throw FNUQError.bufferTooSmall
        }
        
        memset(pointer, Int32(value), size)
    }
}
