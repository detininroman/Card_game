//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Roman on 24/05/2019.
//  Copyright © 2019 Roman. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme.name == "Default" {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle {
                cvc.changeTheme(on: themeName)
            }
        } else if let cvc = lastSeguedToConcentrationCiewController {
            if let themeName = (sender as? UIButton)?.currentTitle {
                cvc.changeTheme(on: themeName)
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationCiewController: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.changeTheme(on: themeName)
                    lastSeguedToConcentrationCiewController = cvc
                }
            }
        }
    }
    
}
