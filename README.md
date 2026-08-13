AWS と Terraformで実現するInfrastructure as Code
概要

Terraformを使用し、AWSリソースをコードで構築・管理するためのハンズオンリポジトリです。

Infrastructure as Code（IaC）の基本的な考え方を理解し、AWS環境の構築・変更・削除をTerraformで実施することを目的としています。

学習内容
Terraformの基本的な記述方法
Providerの設定
AWSリソースの作成・変更・削除
変数（Variable）や出力値（Output）の利用
リソース間の依存関係
Terraform Stateによるリソース管理
terraform plan による変更内容の事前確認
Infrastructure as CodeによるAWS環境の再現
基本的な実行手順

Terraformの初期化：

terraform init

構成ファイルの確認：

terraform validate

変更内容の確認：

terraform plan

AWSリソースの作成・変更：

terraform apply

作成したAWSリソースの削除：

terraform destroy
使用技術
AWS
Terraform
Infrastructure as Code（IaC）
Git / GitHub
注意事項
AWSリソースの作成により料金が発生する場合があります。
ハンズオン終了後は、不要なAWSリソースが残っていないことを確認します。
AWSアクセスキーなどの認証情報はリポジトリに含めません。
.terraform/、Terraform State、認証情報など、公開不要・機密性のあるファイルは .gitignore の対象とします。
本リポジトリについて

AWSおよびTerraformの学習・ハンズオンで自身が作成したIaCコードを記録するためのリポジトリです。

教材等から提供された再配布対象外のリソースは含めず、自身の学習成果を中心に掲載しています。
