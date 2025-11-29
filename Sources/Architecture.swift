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

public enum Architecture {
    case x86_64
    case arm64
    case unknown(String)
    
    public static var current: Architecture {
        #if arch(x86_64)
        return .x86_64
        #elseif arch(arm64)
        return .arm64
        #else
        return .unknown("unknown")
        #endif
    }
    
    public var name: String {
        switch self {
        case .x86_64: return "x86_64"
        case .arm64: return "arm64"
        case .unknown(let name): return name
        }
    }
    
    public var pageSize: Int {
        switch self {
        case .x86_64, .arm64:
            return 4096 // 4KB page size
        case .unknown:
            return 4096
        }
    }
    
    public var isSupported: Bool {
        switch self {
        case .x86_64, .arm64:
            return true
        case .unknown:
            return false
        }
    }
}
