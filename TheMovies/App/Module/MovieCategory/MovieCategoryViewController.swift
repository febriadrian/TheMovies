//
//  MovieCategoryViewController.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieCategoryViewController: MoviesCollectionViewController {
    var homeVC: HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupLayout() {
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    override func registerCellType() {
        collectionView.registerCellType(MoviesCollectionViewCell.self)
    }
    
    override func setupCommonDelegates() {
        homeVC?.getMoviesDelegate = self
    }
    
    override func cellForItemAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(MoviesCollectionViewCell.self, for: indexPath)
        cell.movies = movies[indexPath.item]
        return cell
    }
    
    override func sizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collWidth: CGFloat = collectionView.frame.size.width
        let padding: CGFloat = 4 * 12
        let width = (collWidth - padding) / 3
        let height = width * 1.75
        return CGSize(width: width, height: height)
    }
}

extension MovieCategoryViewController: GetMoviesDelegate {
    func displayGetMovies(page: Int, totalResults: Int, movies: [HomeModel.Movies]) {
        displayMovies(page: page, totalResults: totalResults, movies: movies)
    }
    
    func displayGetMoviesFailed(message: String) {
        displayMoviesFailed(message: message)
    }
    
    func scrollToTop() {
        scrollToFirst()
    }
}
