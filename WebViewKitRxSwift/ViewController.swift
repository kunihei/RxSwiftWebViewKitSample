//
//  ViewController.swift
//  WebViewKitRxSwift
//
//  Created by 祥平 on 2021/12/15.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import RxOptional
import RxWebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        // Do any additional setup after loading the view.
    }
    
    private func setupWebView() {
        //プログレスバーの表示制御、ゲージ制御、アクティビティーインジゲーター表示制御で使うため、一旦オブザーバー定義
        let loadingObservable = webView.rx.loading.share()
        //プログレスバーの表示・非表示
        loadingObservable
            .map{ return !$0 }
            .observeOn(MainScheduler.instance)
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)
        //iPhoneの上部の時計のところのバーの(名称不明)アクティビティーインジケーター表示制御
        loadingObservable
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        //NavigationControllerのタイトル表示
        webView.rx.title
            .filterNil()
            .observeOn(MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        //プログレスバーのゲージ制御
        webView.rx.estimatedProgress
            .map{ return Float($0) }
            .observeOn(MainScheduler.instance)
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        let url = URL(string: "https://www.google.com/")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    
//    private func setupWebView() {
//        //プログレスバーの表示制御、ゲージ制御、アクティビティーインジゲーター表示制御で使うため、一旦オブザーバー定義
//        let loadingObservable = webView.rx.observe(Bool.self, "loading").filterNil().share()
//        //プログレスバーの表示・非表示
//        loadingObservable.map { return !$0 }.bind(to: progressView.rx.isHidden).disposed(by: disposeBag)
//        //iPhoneの上部の時計のところのバーの(名称不明)アクティビティーインジケーター表示制御
//        loadingObservable.bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible).disposed(by: disposeBag)
//        //NavigationControllerのタイトル表示
//        loadingObservable.map { [weak self] _ in
//            return self?.webView.title
//        }
//        .bind(to: navigationItem.rx.title).disposed(by: disposeBag)
//        //プログレスバーのゲージ制御
//        webView.rx.observe(Double.self, "estimatedProgress").filterNil().map { return Float($0) }.bind(to: progressView.rx.progress).disposed(by: disposeBag)
//        let url = URL(string: "https://www.google.com/")
//        let urlRequest = URLRequest(url: url!)
//        webView.load(urlRequest)
//    }
    
    
// RxSwiftを使用しない方法
//    private func setupWebView() {
//        // webView.isLoadingの値の変化を監視
//        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
//        // webView.estimatedProgressの変化を監視
//        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
//        let url = URL(string: "https://www.google.com/")
//        let urlRequest = URLRequest(url: url!)
//        webView.load(urlRequest)
//        progressView.setProgress(0.1, animated: true)
//    }
//
//    deinit {
//        // 監視の解除
//        webView.removeObserver(self, forKeyPath: "loading")
//        webView.removeObserver(self, forKeyPath: "estimatedProgress")
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "loading" {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = webView.isLoading
//            if !webView.isLoading {
//                //ロード完了時にProgressViewの進捗を0.0(非表示)にする
//                progressView.setProgress(0.0, animated: false)
//                //ロード完了時にNavigationTitleに読み込んだページのタイトルをセット
//                navigationItem.title = webView.title
//            }
//        }
//
//        if keyPath == "estimatedProgress" {
//            //ProgressViewの進捗状態を更新
//            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
