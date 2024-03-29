import SwiftUI

struct TriviaGameView: View {
    var questions: [QuizQuestion]
    
    
    @State private var selectedChoices: [String?]
    @State private var showingAlert = false
    @State private var score = 0
    @Binding var selectedTime: Int
    @State private var timeRemaining: Int
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(questions: [QuizQuestion], selectedTime: Binding<Int>) {
        self.questions = questions
        self._selectedTime = selectedTime
        self._selectedChoices = State(initialValue: Array(repeating: nil, count: questions.count))
        self._timeRemaining = State(initialValue: selectedTime.wrappedValue)
        
        var initialChoices = [String?]()
                for _ in questions {
                    initialChoices.append(nil)
                }
                _selectedChoices = State(initialValue: initialChoices)
    }
    
    var body: some View {
        Text("Time Remaining: \(timeRemaining) seconds")
                           .font(.title)
        ScrollView {
            VStack {
                               
                Text("Trivia Game Screen")
                    .font(.title)
                
                
                ForEach(questions.indices, id: \.self) { index in
                    QuestionView(question: self.questions[index], selectedChoice: self.$selectedChoices[index])
                }
                
                Button(action: {
                    self.calculateScore()
                    self.showingAlert = true
                }) {
                    Text("Submit")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Score"), message: Text("Your score is \(score) out of \(questions.count)"), dismissButton: .default(Text("OK")))
                }
            }
            .padding()
            .onReceive(timer) { _ in
                            if self.timeRemaining > 0 {
                                self.timeRemaining -= 1
                            } else {
                                self.timer.upstream.connect().cancel() // Stop the timer when time is up
                                self.calculateScore()
                                self.showingAlert = true
                            }
                        }
        }
        }
        func calculateScore() {
            score = 0
            
            // Iterate through questions and compare selected choices with correct answers
            for (index, question) in questions.enumerated() {
                if selectedChoices[index] == question.correct_answer {
                    score += 1
                }
            }
            
            // Print or display the score
            print("Your score is: \(score)")
        }
        
}



struct TriviaGameView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleQuestions: [QuizQuestion] = [
            QuizQuestion(type: "multiple",
                         difficulty: "easy",
                         category: "General Knowledge",
                         question: "What is the capital of France?",
                         correctAnswer: "Paris",
                         incorrectAnswers: ["London", "Berlin", "Rome"]),
            
            QuizQuestion(type: "multiple",
                         difficulty: "medium",
                         category: "Art",
                         question: "Who painted the Mona Lisa?",
                         correctAnswer: "Leonardo da Vinci",
                         incorrectAnswers: ["Vincent van Gogh", "Pablo Picasso", "Michelangelo"])
            // Add more sample questions as needed
        ]
        
        let timeElapsed = 120
        
        TriviaGameView(questions: exampleQuestions, selectedTime: .constant(timeElapsed))
    }
}


