//
//  LearnWordApp.swift
//  LearnWord
//
//  Created by Аружан Куаныш on 02.01.2026.
//

import SwiftUI

@main
struct LearnWordApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
    init() {
        StorageService.shared.addMockWordsIfNeeded()
    }
}
