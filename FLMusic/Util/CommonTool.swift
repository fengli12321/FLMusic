//
//  CommonTool.swift
//  FLMusic
//
//  Created by fengli on 2019/1/22.
//  Copyright © 2019 冯里. All rights reserved.
//

import Foundation
import KeychainAccess

let tokenKeychain = "tokenKeychain"
func saveToken(token: String) {
    
    getKeychainManager()[string: tokenKeychain] = token
}

func getToken() -> String? {
    
    return getKeychainManager()[string: tokenKeychain]
}

func removeToken() {
    
    let keychain = getKeychainManager()
    try? keychain.remove(tokenKeychain)
}

func getKeychainManager() -> Keychain {
    return Keychain(service: "com.FoxPower.FLMusic")
}
