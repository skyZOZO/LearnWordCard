//
//  WordStatus.swift
//  LearnWord
//
//  Created by Аружан Куаныш on 02.01.2026.
//

import Foundation

enum WordStatus: Int16 {
    case new = 0        // новое
    case learning = 1   // учу
    case learned = 2    // выучено
    case known = 3      // уже знал
}
