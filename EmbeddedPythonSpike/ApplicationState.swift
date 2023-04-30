//
//  ApplicationState.swift
//  EmbeddedPythonSpike
//
//  Created by Alexis Rondeau on 24.04.23.
//

import Foundation
import PythonKit

class ApplicationState : ObservableObject {
    static let shared = ApplicationState()

    @Published var importedPythonModules: [String] = []
    @Published var evalResult: PythonObject = PythonObject(stringLiteral: "Default")
    @Published var error: Error?
}
