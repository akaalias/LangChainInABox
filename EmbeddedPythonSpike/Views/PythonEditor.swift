//
//  PythonEditor.swift
//  LangChainInABox
//
//  Created by Alexis Rondeau on 30.04.23.
//

import SwiftUI
import CodeEditor

struct PythonEditor: View {
    @StateObject var state = ApplicationState.shared
    @EnvironmentObject var embeddedPython: EmbeddedPython

    @AppStorage("fontsize") var fontSize = 18
    @State private var language = CodeEditor.Language.python
    @State var source = """
from langchain.llms import OpenAI
llm = OpenAI(temperature=0.9)
text = "What would be a good company name for a company that makes colorful socks?"
idea = llm(text)
print(idea)
"""

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                Spacer()

                Text("Imported Modules:")
                ForEach(ApplicationState.shared.importedPythonModules, id: \.self) { module in
                    Text(module)
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 4).fill(.black.opacity(0.3)))
                }

                Button {
                    DispatchQueue.main.async {
                        embeddedPython.runSimpleString(code: self.source)
                    }
                } label: {
                    Text("Run")
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut("r")
                .accessibilityHint("Run this Python code")
                
            }

            CodeEditor(source: $source, language: language,
                       fontSize: .init(get: { CGFloat(fontSize)  },
                                       set: { fontSize = Int($0) }))
        }
    }
}

struct PythonEditor_Previews: PreviewProvider {
    static var previews: some View {
        PythonEditor()
    }
}
