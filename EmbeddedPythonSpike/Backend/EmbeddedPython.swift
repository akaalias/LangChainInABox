//
//  EmbeddedPython.swift
//  EmbeddedPythonSpike
//
//  Created by Alexis Rondeau on 23.04.23.
//

import Foundation
import Python
import PythonKit

public struct DefaultPythonModules {
    public static let list = ["langchain"]
    public static let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
}

@MainActor class EmbeddedPython: ObservableObject {
    @Published var running: Bool = false
    @Published var evalResult: PythonObject?
    @Published var stdoutOutput: String = ""
    
    var output = OutputListener()

    init() {
        // Initialize the Python runtime early in the app
        if  let stdLibPath = Bundle.main.path(forResource: "python-stdlib", ofType: nil),
            let libDynloadPath = Bundle.main.path(forResource: "python-stdlib/lib-dynload", ofType: nil),
            let langchainLibrariesPath = Bundle.main.path(forResource: "langchain-libraries", ofType: nil) {
            setenv("PYTHONHOME", stdLibPath, 1)
            setenv("PYTHONPATH", "\(stdLibPath):\(libDynloadPath):\(langchainLibrariesPath):\(appFolderPath())", 1)
            
            do {
                Py_Initialize()
                for module in DefaultPythonModules.list {
                    let _ = try Python.attemptImport(module)
                    ApplicationState.shared.importedPythonModules.append(module)
                }
                
                // setOpenAIKey()
            } catch {
                print(error)
            }
            
            self.evalResult = PythonObject(stringLiteral: "Default")
        }
        
        // Open so we can capture stdout
        output.openConsolePipe()
    }
    
    func setOpenAIKey() {
//        let os = Python.import("os")
//        if let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String {
//            os.environ["OPENAI_API_KEY"] = PythonObject(stringLiteral: apiKey)
//        }
    }
    
    // Simple example of loading Python modules into the runtime
    // and accessing Python object members in Swift
    func printPythonInfo() {
        let sys = Python.import("sys")
        print("Python Version: \(sys.version_info.major).\(sys.version_info.minor)")
        print("Python Encoding: \(sys.getdefaultencoding().upper())")
        print("Python Path: \(sys.path)")
    }
    
    func appFolderPath() -> URL {
        return DefaultPythonModules.paths[0]
    }
    
    func saveAndRun(input: String) {
        self.running = true
        let hash = input.hashValue
        self.saveToFile(hash: hash, input: input)
        self.runUserFile(hash: hash)
    }
    
    func saveToFile(hash: Int, input: String) {
        let str = input
        let url = appFolderPath().appendingPathComponent("user_\(hash).py")
        do {
            try str.write(to: url, atomically: true, encoding: .utf8)
            // let input = try String(contentsOf: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func runSimpleString(code: String) {
        self.running = true
        DispatchQueue.main.async {
            PyRun_SimpleString(code)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.stdoutOutput = "Updating..."
            self.stdoutOutput = self.output.contents
            self.running = false
        }
    }
    
    /// The idea was initially I'd use python import a newline created module file
    func runUserFile(hash: Int) {
        do {
            let user = try Python.attemptImport("user_\(hash)")
            let result = user.eval()

            DispatchQueue.main.async {
                self.evalResult = result
                self.running = false
            }
        } catch {
            print(error)
        }
        
        self.running = false
    }
}
