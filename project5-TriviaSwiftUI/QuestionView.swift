//
//  QuestionView.swift
//  project5-TriviaSwiftUI
//
//  Created by Lixing Zheng on 3/27/24.
//

import SwiftUI

struct QuestionView: View {
    let question: QuizQuestion
    @Binding var selectedChoice: String?
    @State private var submitted = false
    
    var allAnswers: [String] {
            var answers = question.incorrect_answers
            answers.append(question.correct_answer)
            return answers.shuffled()
        }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Rectangle()
                .fill(Color.blue)
                .frame(height: 1)
            Text(question.question)
            
            ForEach(allAnswers, id: \.self) { answer in
                Button(action: {
                    self.selectChoice(answer)
                }) {
                    Text(answer)
                        .foregroundColor(.black)
                        .padding()
                        .background(self.isSelected(answer) ? Color.green.opacity(0.5) : Color.blue)
                        .cornerRadius(8)
                            }
                        }
                    }
        .padding()
        }
    
    func selectChoice(_ answer: String) {
           // Update the selected choice
        self.selectedChoice = answer
        print(answer)
        print(selectedChoice)
       }
       
    func isSelected(_ answer: String) -> Bool {
           // Check if the answer is selected
           return self.selectedChoice == answer
       }
    }

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleQuestion = QuizQuestion(type: "multiple",
                                           difficulty: "easy",
                                           category: "General Knowledge",
                                           question: "What is the capital of France?",
                                           correctAnswer: "Paris",
                                           incorrectAnswers: ["London", "Berlin", "Rome"])
        
        return QuestionView(question: exampleQuestion, selectedChoice: .constant(nil))
            .padding()
    }
}
