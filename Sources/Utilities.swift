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

public enum FNUQUtilities {
    
    public static func hostToBigEndian<T: FixedWidthInteger>(_ value: T) -> T {
        return value.bigEndian
    }
    
    public static func bigEndianToHost<T: FixedWidthInteger>(_ value: T) -> T {
        return T(bigEndian: value)
    }
    
    
    public static func alignUp(_ value: UInt64, alignment: UInt64) -> UInt64 {
        return (value + alignment - 1) & ~(alignment - 1)
    }
    
    public static func alignDown(_ value: UInt64, alignment: UInt64) -> UInt64 {
        return value & ~(alignment - 1)
    }
    
    
    public static func hexString(_ value: UInt64, digits: Int = 16) -> String {
        return String(format: "0x%0\(digits)llx", value)
    }
    
    public static func hexDump(_ data: Data, address: UInt64 = 0) -> String {
        var result = ""
        let bytesPerLine = 16
        
        for (index, byte) in data.enumerated() {
            if index % bytesPerLine == 0 {
                if index > 0 { result += "\n" }
                result += "\(hexString(address + UInt64(index))): "
            }
            result += String(format: "%02x ", byte)
        }
        
        return result
    }
}
