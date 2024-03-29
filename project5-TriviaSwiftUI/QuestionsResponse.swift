//
//  QuestionsResponse.swift
//  project5-TriviaSwiftUI
//
//  Created by Lixing Zheng on 3/26/24.
//

import SwiftUI


struct QuizData: Codable {
    let results: [QuizQuestion]
}

struct QuizQuestion: Codable, Hashable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
    
    init(type: String, difficulty: String, category: String, question: String, correctAnswer: String, incorrectAnswers: [String]) {
            self.type = type
            self.difficulty = difficulty
            self.category = category
            self.question = question
            self.correct_answer = correctAnswer
            self.incorrect_answers = incorrectAnswers
        }
}
