//
//  Dictionary+Extensions.swift
//  airwallex-payment-flutter
//
//  Created by Hector.Huang on 2024/11/10.
//

extension NSDictionary {
    func removingNSNullValues() -> NSDictionary {
        let mutableCopy = self.mutableCopy() as! NSMutableDictionary
        for (key, value) in self {
            if value is NSNull {
                mutableCopy.removeObject(forKey: key)
            } else if let nestedDict = value as? NSDictionary {
                mutableCopy[key] = nestedDict.removingNSNullValues()
            }
        }
        return mutableCopy
    }
}
