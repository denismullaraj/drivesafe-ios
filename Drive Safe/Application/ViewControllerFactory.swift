//
//  ViewControllerFactory.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 29.8.22.
//  Copyright © 2022 dmullaraj. All rights reserved.
//

protocol ViewControllerFactory {
    func makeHomeViewController() -> HomeViewController
    func makeKeepEyesOpenViewController() -> KeepEyesOpenViewController
}
