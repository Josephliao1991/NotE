//
//  ActionRequestHandler.swift
//  NotExtension
//
//  Created by TSUNG-LUN LIAO on 2015/6/25.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    
    
    var extensionContext: NSExtensionContext?
    
    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        // Do not call super in an Action extension with no user interface
        self.extensionContext = context
  
        // Find the item containing the results from the JavaScript preprocessing.
        let identifierType = NSString(format: kUTTypePropertyList, NSUTF8StringEncoding)
        
        for item: NSExtensionItem in context.inputItems as! [NSExtensionItem] {
            
            for itemProvider: NSItemProvider in item.attachments as! [NSItemProvider] {
                
                if itemProvider.hasItemConformingToTypeIdentifier(identifierType as String) {
                    
                    itemProvider.loadItemForTypeIdentifier(
                        identifierType as String,
                        options: nil,
                        
                        completionHandler: {
                            (item, error) in
                            let dictionary = item as! NSDictionary
                            dispatch_async(dispatch_get_main_queue(),{
                                self.itemLoadCompletedWithPreprocessingResults(dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary as [NSObject : AnyObject])
                            })
                    })
                }
            }
        }

    }
    
    func itemLoadCompletedWithPreprocessingResults(javaScriptPreprocessingResults: [NSObject: AnyObject]) {
        
        // In this very simple example, the JavaScript will have passed us the
        // current background color style, if there is one. We will construct a
        // dictionary to send back with a desired new background color style.

        // Here, do something, potentially asynchronously, with the preprocessing
        // results.
        if var content = javaScriptPreprocessingResults["args"] as? String {
            
            var note :NSString = NSString.localizedStringWithFormat("%@", content)
            var userDefaults: NSUserDefaults = NSUserDefaults(suiteName: "group.tw.tokakyo.NotE")!

            if let notes:NSMutableArray = userDefaults.objectForKey("notes") as? NSMutableArray {
                
                var tmp_notes:NSMutableArray = NSMutableArray()
                
                for note in notes{
                    
                    tmp_notes.addObject(note)
                    
                }
                
                tmp_notes.insertObject(note, atIndex: 0)
                userDefaults.setObject(tmp_notes, forKey: "notes")
                
            }else{
                
                var notes:NSMutableArray = []
                notes.addObject(note)
                userDefaults.setObject(notes, forKey: "notes")
//                userDefaults!.synchronize()
                
            }
        
            
        self.doneWithResults(["message": "Successfully added to the NotE"])
        
        }
        
    }
    
    func doneWithResults(resultsForJavaScriptFinalizeArg: [NSObject: AnyObject]?) {
        if let resultsForJavaScriptFinalize = resultsForJavaScriptFinalizeArg {
            // Construct an NSExtensionItem of the appropriate type to return our
            // results dictionary in.
            
            // These will be used as the arguments to the JavaScript finalize()
            // method.
            
            var resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize]
            
            var resultsProvider = NSItemProvider(item: resultsDictionary, typeIdentifier: String(kUTTypePropertyList))
            
            var resultsItem = NSExtensionItem()
            resultsItem.attachments = [resultsProvider]
            
            // Signal that we're complete, returning our results.
            self.extensionContext!.completeRequestReturningItems([resultsItem], completionHandler: nil)
            
        } else {
            
            // We still need to signal that we're done even if we have nothing to
            // pass back.
            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        }
        
        // Don't hold on to this after we finished with it.
        self.extensionContext = nil
    }

}


