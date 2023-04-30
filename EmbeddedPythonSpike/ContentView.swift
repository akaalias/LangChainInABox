//
//  ContentView.swift
//  EmbeddedPythonSpike
//
//  Created by Alexis Rondeau on 20.04.23.
//

import SwiftUI
import PythonKit

struct ContentView: View {
    @StateObject var state = ApplicationState.shared
    @EnvironmentObject var embeddedPython: EmbeddedPython
    @State var output: PythonObject = PythonObject(stringLiteral: "")
    @State var running: Bool = false
    @State var input = """
def eval():
    from langchain.llms import OpenAI
    llm = OpenAI(temperature=0.9)
    text = "What would be a good company name for a company that makes colorful socks?"
    idea = llm(text)
    print(idea)
    return idea
"""
    
    @State var saved = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Imported Modules:")
                ForEach(ApplicationState.shared.importedPythonModules, id: \.self) { module in
                    Text(module)
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 4).fill(.white.opacity(0.3)))
                }
            }
            
            HStack(alignment: .top) {
                TextEditor(text: $input)
                    .autocorrectionDisabled(true)
                    .font(.title2)
                    .lineSpacing(8)
                    .background(.white.opacity(0.1))

                VStack(alignment: .leading) {
                    if embeddedPython.running {
                        ProgressView()
                            .progressViewStyle(.linear)
                    } else {
                        Text("\(embeddedPython.evalResult!.description.trimmingCharacters(in: .whitespacesAndNewlines))")
                    }
                }
                .frame(width: 250)
                .background(.black.opacity(0.1))
            }
            
            HStack {
                Button {
                    self.running = true

                    DispatchQueue.main.async {
                        embeddedPython.saveAndRun(input: self.input)
                    }
                } label: {
                    Text("Run")
                }
                .keyboardShortcut("r")
                .accessibilityHint("Run this Python code")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            self.isAutomaticQuoteSubstitutionEnabled = false
            self.backgroundColor = .clear
        }
    }
}
