import Foundation

struct CodeSignature {
    enum Error: Swift.Error {
        case noCode
        case noStaticCode
        case fromSecurityFramework(function: String, status: OSStatus)
    }

    let code: SecStaticCode

    init(code: SecCode) throws {
        var optionalStaticCode: SecStaticCode? = nil
        let status = SecCodeCopyStaticCode(code, [], &optionalStaticCode)
        guard status == errSecSuccess else {
            throw Error.fromSecurityFramework(function: "SecCodeCopyStaticCode", status: status)
        }
        guard let staticCode = optionalStaticCode else {
            throw Error.noStaticCode
        }
        self.code = staticCode
    }

    init() throws {
        var optionalCode: SecCode? = nil
        let status = SecCodeCopySelf([], &optionalCode)
        guard status == errSecSuccess else {
            throw Error.fromSecurityFramework(function: "SecCodeCopySelf", status: status)
        }
        guard let code = optionalCode else {
            throw Error.noCode
        }
        try self.init(code: code)
    }

    var signingInfo: NSDictionary {
        var optionalSigningInfo: CFDictionary? = nil
        let status = SecCodeCopySigningInformation(code, [], &optionalSigningInfo)
        guard status == errSecSuccess else {
            NSLog(String(describing: Error.fromSecurityFramework(function: "SecCodeCopySigningInformation", status: status)))
            return [:]
        }
        guard let signingInfo = (optionalSigningInfo as NSDictionary?) else {
            return [:]
        }
        return signingInfo
    }

    var entitlements: [String: Any] {
        guard let entitlements = (signingInfo[kSecCodeInfoEntitlementsDict] as? [String: Any]) else {
            return [:]
        }
        return entitlements
    }

    var applicationGroups: [String] {
        guard let applicationGroups = (entitlements["com.apple.security.application-groups"] as? [String]) else {
            return []
        }
        return applicationGroups
    }
}

extension CodeSignature.Error: CustomStringConvertible {
    var description: String {
        switch self {
            case .noCode:
                return "Failed to determine code"
            case .noStaticCode:
                return "Failed to determine static code"
            case .fromSecurityFramework(let function, let status):
                let prefix = "Error in '\(function)()': "
                let details: String
                if let errorMessage = (SecCopyErrorMessageString(status, nil) as String?) {
                    details = errorMessage
                } else {
                    details = "Unknown error"
                }
                return prefix + details + " (\(status))"
        }
    }
}
