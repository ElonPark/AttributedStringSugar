//
//  ViewController.swift
//  AttributedStringSugar
//
//  Created by ElonPark on 03/16/2020.
//  Copyright (c) 2020 ElonPark. All rights reserved.
//

import UIKit
import AttributedStringSugar

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = "Hello".attribute
            .paragraphStyle(alignment: .center)
            .systemFont(ofSize: 20, weight: .bold)
            .underline(style: .styleDouble, color: .green)
            .append(string: ", .........", makeAttribute: {
                $0.attribute
                    .foreground(color: .blue)
                    .background(color: .cyan)
            })
            .append(string: "wolrd!", makeAttribute: {
                $0.attribute
                    .systemFont(ofSize: 25, weight: .black)
                    .stroke(width: 5, color: .yellow)
                    .background(color: .red)
                    .strikeThrough(style: .styleDouble)
            })
            .append(string: "\nlink", makeAttribute: {
                $0.attribute
                    .systemFont(ofSize: 30, weight: .bold)
                    .link(url: URL(string: "https://github.com")!)
            })
        
        let textView = UITextView()
        textView.attributedText = text + "!!!!!!!"
        textView.isEditable = false
        textView.isSelectable = true
        textView.delegate = self
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            textView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            textView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            textView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}

extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print(URL)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL)
        }
        
        return false
    }
}

