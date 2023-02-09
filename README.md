# 株式会社ゆめみ iOS エンジニアコードチェック課題
   
#### 使用ライブラリ（SwiftPackageManagerを使用）   
[Ink](https://github.com/vadimdemedes/ink)  
[SFSafeSymbols](https://github.com/SFSafeSymbols/SFSafeSymbols)  
[SnapKit](https://github.com/SnapKit/SnapKit)
  
_________________
  
#### ・工夫した点
- StoryBoardを使わない開発手法に移行しました。  
   これにより、コードレビューのしやすさ & AutoLayoutのコンフリクト部分の判定のし易さを向上させました。
   
- READMEを表示させる機能を追加 
   READMEが当該リポジトリについて一番詳しく説明が書いているはずであるので、それを表示しユーザーがそれが何なのかわかりやすいようにしました。
  
- WKWebViewの中のブラウザバッグなどに対応したオブジェクトを設置した。
  READMEには大抵URLが埋め込まれているので、それに対応しさらにユーザーのアプリ使用体験を向上させました。
  
- お気に入り登録機能の追加
  お気に入り登録機能を追加し、ユーザーのお気に入りのリポジトリにすぐに飛べるようにしました。  
  （しかし下記問題が生じてしまいました。）
  
_________________
  
#### ・できたこと  
(参考１：[プルリク1](https://github.com/reeen-git/iOSCodeCheck/pull/13))  
(参考２：[プルリク2](https://github.com/reeen-git/iOSCodeCheck/pull/14))  
(参考３：[プルリク３](https://github.com/reeen-git/iOSCodeCheck/pull/15))
　　　
- FatVCの回避  
  Modelを切り出し、APIを呼び出す責務をVCから分離
   
- コードの可読性の向上  
 Markの適用、extensionでの分離、StoryBoardを使用しないAutoLayou(コードレビューのしやすさを向上)
    
- コードの安全性の向上  
  guard文の使用による想定外のnilの潰し、強制アンラップ・強制ダウンキャストの未使用化
 
 - バグを修正  
   StoryBoardを廃止、Modelの実装、メモリリーク（未実装）
  
 - UIをブラッシュアップ、新機能の追加  
   READMEを表示する機能の追加・お気に入り機能の追加及びUserDefaultsの追加
    
#### ・できなかったこと   
- DetailViewのfavoriteButtonの挙動  
   ViewDidLoad()が複数回呼ばれてしまうと、ボタンが予期せぬ動きをしてしまい、一度押下したボタンを再度押下するのを防ぐ処理ができませんでした。  
   (リポジトリを検索して、一度CellをタップしDetailViewを表示するのは上手く表示されますが、一度SearchViewControllerに戻り再度Cellに飛ぶとボタンが変化してしまう状況です。)
   
- リポジトリの言語によって、CellのImageViewの色を変える部分  
  もう少し、美しく書くべきだと考え様々試しましたが、実装ができませんでした。
