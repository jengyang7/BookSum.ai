//
//  ContentView.swift
//  BookSum
//
//  Created by Jayden Kong on 21/04/2023.
//

import SwiftUI

struct BookSummaryView: View {
    @State private var bookTitle = ""
    @State private var showSummary = false
    
    let text: String = "What book do you want to summarize?"
    @State private var animatedText = ""
    
    
    var body: some View {
        NavigationView {
            
            ZStack{
                Image("background_book")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack {
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130, height: 130)
                        .cornerRadius(20)
                    Spacer()
                    Text(animatedText)
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center) // center-align the text
                        .lineLimit(2) // limit the text to 2 lines
                        .frame(maxWidth: 260, alignment: .center)
                        .onAppear {
                            bookTitle = "" // Clear the text field text
                            animatedText = ""
                            
                            for (index, character) in text.enumerated() {
                                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                                    animatedText.append(character)
                                }
                            }
                        }
                    TextField("Enter book title", text: $bookTitle)
                        .padding(.horizontal)
                        .padding()
                        .foregroundColor(.black)
                        .accentColor(.black)
                        .background(Color.white)
                        .opacity(0.7)
                        .cornerRadius(8)
                        .frame(maxWidth: 280)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    NavigationLink(
                        destination: SummaryView(bookTitle: bookTitle),
                        isActive: $showSummary
                    ) {
                        
                        Button(action: {
                            showSummary = true
                            animatedText = ""
                        }) {
                            Text("Next")
                                .foregroundColor(.black)
                                .frame(width: 200 , height: 40, alignment: .center)
                        }
                        .background(Color.primary)
                        .opacity(0.8)
                        .font(.headline)
                        .cornerRadius(12)
                        
                    }
                    .disabled(bookTitle.isEmpty) // Disable button if name is empty

                    Spacer()
                }
            }
            .preferredColorScheme(.dark) // white tint on status bar
            
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Add this line to fix the status bar issue when using navigation bar with ZStack
        
        .navigationBarTitle(Text("Book Summary"))
    }
}

struct SummaryView: View {
    @Environment(\.presentationMode) var presentationMode
    var bookTitle: String
    
    @ObservedObject var viewModel: ViewModel
    
    init(bookTitle: String) {
        self.bookTitle = bookTitle
        self.viewModel = ViewModel(messages: [], currentInput: "Give me 3 sections which are 100 words summary of book \(bookTitle), Points form of 5 detailed important lessons from book \(bookTitle) and 3 recommends books that similar to book \(bookTitle). Don't mention word \"section\" in the response", bookName: self.bookTitle)
    }
    
    var body: some View {
        
        ZStack {
            Image("background_book")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("\(bookTitle)")
                    .font(.title)
                    .fontWeight(.bold)
                ScrollView{
                    ForEach(viewModel.messages.filter({$0.role == .assistant}), id: \.id) { message in
                        messageView(message: message)
                    }
                }
                .cornerRadius(12)
                .padding()
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()

                }) {
                    Text("Back")
                        .foregroundColor(.black)
                        .frame(width: 200 , height: 40, alignment: .center)
                }
                .background(Color.white)
                .font(.headline)
                .cornerRadius(12)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.sendMessage()
        }
    }
    
    func messageView(message: AIMessage) -> some View {
        HStack {
//            if message.role == .user { Spacer()}
            Text(message.content)
                .padding()
                .foregroundColor(Color.theme)
                .background(Color.white)
                .cornerRadius(8)
//            if message.role == .assistant { Spacer()}
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BookSummaryView()
    }
}


extension Color {
    static let theme = Color("theme")
}
