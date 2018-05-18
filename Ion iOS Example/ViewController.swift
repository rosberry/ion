//
//  ViewController.swift
//  Ion iOS Example
//
//  Created by Anton K on 3/23/18.
//

import UIKit
import Ion

class CustomMatcher: Matcher {
    func match(_ object: Character) -> Bool {
        return true
    }

    func transform(_ object: Character) -> Character {
        return Character(name: String(object.name.reversed()), source: object.source)
    }
}

class ViewController: UIViewController {

    let service = Service()

    lazy var singleCharacterCollector = Collector(source: service.singleCharacterSource)
    lazy var characterListCollector = Collector(source: service.characterListSource)
    lazy var guessResultCollector = Collector(source: service.guessResultSource)

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var guessTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Any

        singleCharacterCollector.subscribe { [weak self] (character: Character) in
            self?.log("Any: \(character)")
        }

        // MARK: - Just Monika

        singleCharacterCollector.subscribe(\Character.name, value: "Monika") { [weak self] (character: Character) in
            self?.log("Just \(character)")
        }

        // MARK: - With short names

        singleCharacterCollector.subscribe({ (character: Character) -> (Bool) in
            return character.name.count <= 10
        }) { [weak self] (character: Character) in
            self?.log("Short name: \(character)")
        }

        // MARK: - Custom matcher

        singleCharacterCollector.subscribe(CustomMatcher()) { [weak self] (character: Character) in
            self?.log("Reversed: \(character)")
        }

        // MARK: - All characters

        characterListCollector.subscribe { [weak self] (characters: [Character]) in
            self?.log("All: \(characters)")
        }

        // MARK: - List of characters from books

        let elementMatcher = ClosureMatcher { (character: Character) -> (Bool) in
            if case .book = character.source {
                return true
            }

            return false
        }
        let bookListMatcher = TrainMatcher<[Character]>(elementMatcher: elementMatcher)
        characterListCollector.subscribe(bookListMatcher) { [weak self] (characters: [Character]) in
            self?.log("From books: \(characters)")
        }

        // MARK: - List of characters, names reversed

        let reverseListMatcher = TrainMatcher<[Character]>(elementMatcher: CustomMatcher())
        characterListCollector.subscribe(reverseListMatcher) { [weak self] (characters: [Character]) in
            self?.log("Reversed names: \(characters)")
        }

        // MARK: - Result

        guessResultCollector.subscribe { [weak self] (result: Service.CharacterResult) in
            self?.log("Got guess result: \(result)")
        }

        /* Explicit matcher
        let successMatcher = ResultMatcher<Service.CharacterResult>.success
        guessResultCollector.subscribe(successMatcher) { [weak self] (result: Service.CharacterResult) in
            self?.log("Guessed correctly")
        }
        */

        guessResultCollector.subscribeSuccess { [weak self] (character: Character) in
            self?.log("Guessed correctly")
        }

        guessResultCollector.subscribeFailure { [weak self] (error: Error) in
            self?.log("Guessed incorrectly")
        }
    }

    // MARK: - Actions

    func log(_ text: String) {
        textView.text = textView.text.appending("\(text)\n")

        let range = NSRange(location: textView.text.count - 1, length: 1)
        textView.scrollRangeToVisible(range)
    }

    @IBAction func randomCharacterButtonPressed(_ sender: Any) {
        self.log(">>> Random Character")
        service.fetchRandomCharacter()
    }

    @IBAction func allCharactersButtonPressed(_ sender: Any) {
        self.log(">>> All Characters")
        service.fetchCharacters()
    }

    @IBAction func guessButtonPressed(_ sender: Any) {
        guard let guess = guessTextField.text else {
            return
        }

        self.log(">>> Guessing: \(guess)")
        service.guessNextCharacter(name: guess)
    }

}

