//
//  TranslatorSentencesViewController.swift
//  LeBaluchon
//
//  Created by Greg on 08/09/2021.
//

import UIKit


protocol SentenceSelectionDelegate {
    func didSelection(sentence: String)
}

class TranslatorSentencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectionDelegate: SentenceSelectionDelegate!
    var selectedFav = String()
    
    @IBOutlet weak var sentencesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sentencesTableView.tableFooterView = UIView.init(frame: .zero)
        self.sentencesTableView.dataSource = self
        self.sentencesTableView.delegate = self
    }
    
    @objc func deleteRow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: sentencesTableView)
        guard let indexPath = sentencesTableView.indexPathForRow(at: point) else {
            return
        }
        sentences.remove(at: indexPath.row)
        self.sentencesTableView.deleteRows(at: [indexPath], with: .left)
    }
    
    @objc func selectFav(_ sender: UIAlertAction) {
        selectionDelegate?.didSelection(sentence: self.selectedFav)
        self.dismiss()
        
    }
    
   
    @objc func showFullSentence(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: sentencesTableView)
        guard let indexPath = sentencesTableView.indexPathForRow(at: point) else {
            return
        }
        self.selectedFav = sentences[indexPath.row]
        let alert = UIAlertController(title: "", message: self.selectedFav, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Sélectionner", style: UIAlertAction.Style.default, handler: self.selectFav(_:)))
        alert.addAction(UIAlertAction(title: "Autre", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addRow(_ sender: UIButton) {
        sentences.insert(contentsOf: ["Je voudrais une glace au melon, s'il-vous-plait."], at: 0)
        self.sentencesTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentences")
        
        if let view = cell?.contentView.viewWithTag(1) as? UIButton {
            view.addTarget(self, action: #selector(self.showFullSentence(_:)), for: .touchUpInside)
               
        }
        
        if let sentenceLabel = cell?.contentView.viewWithTag(2) as? UILabel {
            sentenceLabel.text = sentences[indexPath.row]
        }
        
        if let deleteButton = cell?.contentView.viewWithTag(3) as? UIButton {
            deleteButton.addTarget(self, action: #selector(deleteRow(_:)), for: .touchUpInside)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionDelegate?.didSelection(sentence: sentences[indexPath.row])
        self.dismiss()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
