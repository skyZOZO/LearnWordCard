//
//  WordEntity+CoreDataProperties.swift
//  LearnWord
//
//  Created by Аружан Куаныш on 02.01.2026.
//
//

import Foundation
import CoreData

extension WordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordEntity> {
        NSFetchRequest<WordEntity>(entityName: "WordEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var english: String?
    @NSManaged public var russian: String?
    @NSManaged public var status: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var lastReviewed: Date?
    @NSManaged public var nextReview: Date?
    @NSManaged public var timesShown: Int16
    @NSManaged public var correctAnswers: Int16
}
