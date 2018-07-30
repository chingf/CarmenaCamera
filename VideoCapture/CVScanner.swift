//
//  Code taken from: http://jeremei.com/scan-a-csv-into-swift/
//

import Foundation

class CSVScanner {
    
    class func debug(string:String){
        
        print("CSVScanner: \(string)")
    }
    
    class func runFunctionOnRowsFromFile(theColumnNames:Array<String>, withFileName theFileName:String, withFunction theFunction:(Dictionary<String, String>)->()) {
        
        let bundle = Bundle.main
        if let strBundle = bundle.path(forResource: theFileName, ofType: "csv") {
            
            var encodingError:NSError? = nil
            
            var fileObject = NSString()
            do {
                fileObject = try NSString(contentsOfFile: strBundle, encoding: String.Encoding.utf8.rawValue)
            } catch {
                CSVScanner.debug(string: "Unable to load csv file from path: \(strBundle)")
            
                if let errorString = encodingError?.description {
                    CSVScanner.debug(string: "Received encoding error: \(errorString)")
                }
            }
            fileObject = fileObject.replacingOccurrences(of: "\r", with: "\n") as NSString
            
            var fileObjectCleaned = fileObject.replacingOccurrences(of: "\n\n", with: "\n")
            
            let objectArray = fileObjectCleaned.components(separatedBy: "\n")
            
            for anObjectRow in objectArray {
                let objectColumns = anObjectRow.characters.split(separator: ",").map(String.init)
                
                var aDictionaryEntry = Dictionary<String, String>()
                
                var columnIndex = 0
                
                for anObjectColumn in objectColumns {
                    let anObjectColumnNS = anObjectColumn as NSString
                    
                    aDictionaryEntry[theColumnNames[columnIndex]] = anObjectColumnNS.replacingOccurrences(of: "\"", with: "")
                    
                    columnIndex = columnIndex + 1
                }
                
                if aDictionaryEntry.count>1{
                    theFunction(aDictionaryEntry)
                }else{
                    
                    CSVScanner.debug(string: "No data extracted from row: \(anObjectRow) -> \(objectColumns)")
                }
            }
        }else{
            CSVScanner.debug(string: "Unable to get path to csv file: \(theFileName).csv")
        }
    }
}
