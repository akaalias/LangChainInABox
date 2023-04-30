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
    public static let list = ["os", "langchain"]
    public static let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

}

@MainActor class EmbeddedPython: ObservableObject {
    @Published var running: Bool = false
    @Published var evalResult: PythonObject?

    init() {
        // Initialize the Python runtime early in the app
        if  let stdLibPath = Bundle.main.path(forResource: "python-stdlib", ofType: nil),
            let libDynloadPath = Bundle.main.path(forResource: "python-stdlib/lib-dynload", ofType: nil)
        {
            setenv("PYTHONHOME", stdLibPath, 1)
            setenv("PYTHONPATH", "\(stdLibPath):\(appFolderPath()):\(libDynloadPath)", 1)
            
            do {
                Py_Initialize()
                for module in DefaultPythonModules.list {
                    let _ = try Python.attemptImport(module)
                    ApplicationState.shared.importedPythonModules.append(module)
                }
                
                setOpenAIKey()
            } catch {
                print(error)
            }
            
            self.evalResult = PythonObject(stringLiteral: "Default")
        }
    }
    
    func setOpenAIKey() {
        let os = Python.import("os")
        os.environ["OPENAI_API_KEY"] = "..."
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
