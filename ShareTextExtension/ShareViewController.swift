//
//  ShareViewController.swift
//  ShareTextExtension
//

import UIKit
import Social
import Combine

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        guard let text = textView.text,
              let defaults = UserDefaults(suiteName: ShareConstants.group),
              let url = URL(string: ShareConstants.scheme) else { return }
        
        defaults.set(text, forKey: "copied_text")
        openURL(url)
        
        dismiss(animated: false) {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
    
    @discardableResult
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let app = responder as? UIApplication {
                return app.perform(#selector(openURL), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}

public struct ShareConstants {
    static let scheme = "otus://text"
    static let group = "group.ru.it.kot.hwappsecond"
}
