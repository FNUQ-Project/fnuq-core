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
import XCTest
@testable import FNUQCore

final class IntegrationTests: XCTestCase {
    var memoryManager: MemoryManager!
    
    override func setUp() {
        super.setUp()
        memoryManager = MemoryManager()
    }
    
    override func tearDown() {
        memoryManager.cleanup()
        super.tearDown()
    }
    
    func testVirtualMachineLifecycle() throws {
        // Skip unsupport Hypervisor
        try XCTSkipUnless(FNUQCore.isSupported, "Hypervisor not supported")
        
        let vm = try VirtualMachine()
        XCTAssertEqual(vm.status, .created)
        
        
        let buffer = try memoryManager.allocate(size: 4096)
        try vm.mapMemory(buffer, guestAddress: 0x1000, size: 4096)
        
       
        let vcpu = try vm.createVCPU()
        XCTAssertEqual(vcpu.id, 0)
        
    
        try vm.start()
        XCTAssertEqual(vm.status, .running)
        
        
        vm.stop()
    }
    
    func testMemoryOperations() throws {
        let memoryManager = MemoryManager()
        
      
        let buffer = try memoryManager.allocate(size: 1024)
        XCTAssertNotNil(buffer)
        
        
        let testData = Data([0xDE, 0xAD, 0xBE, 0xEF])
        try memoryManager.copy(to: buffer, data: testData)
        
   
        let copiedData = Data(bytes: buffer, count: 4)
        XCTAssertEqual(copiedData, testData)
        

        try memoryManager.fill(buffer, with: 0xAA, size: 8)
    }
    
    func testArchitectureDetection() {
        let arch = Architecture.current
        XCTAssertTrue(arch.isSupported)
        XCTAssertFalse(arch.name.isEmpty)
    }
}
