# GitHub　RaiseTech課題提出目次（2025年4月〜2026年3月）

# aws-study

RaiseTechの課題を通じて、AWSの手動構築、CloudFormation、Terraformによるインフラ構築を学習・実践した記録用リポジトリです。  
主に EC2、RDS、S3、ALB、VPC などを扱い、運用監視、CI/CD、自動化まで段階的に取り組みました。  
学習内容の振り返りと成果物を、ポートフォリオとしてまとめています。

---

## 使用技術

<p>
  <img src="https://img.shields.io/badge/AWS-232F3E.svg?logo=amazonaws&style=for-the-badge&logoColor=white" alt="AWS">
  <img src="https://img.shields.io/badge/CloudFormation-232F3E.svg?logo=amazonaws&style=for-the-badge&logoColor=white" alt="CloudFormation">
  <img src="https://img.shields.io/badge/Terraform-7B42BC.svg?logo=terraform&style=for-the-badge&logoColor=white" alt="Terraform">
  <img src="https://img.shields.io/badge/GitHub_Actions-2088FF.svg?logo=githubactions&style=for-the-badge&logoColor=white" alt="GitHub Actions">
  <img src="https://img.shields.io/badge/Ansible-EE0000.svg?logo=ansible&style=for-the-badge&logoColor=white" alt="Ansible">
  <img src="https://img.shields.io/badge/Java-007396.svg?logo=openjdk&style=for-the-badge&logoColor=white" alt="Java">
  <img src="https://img.shields.io/badge/Spring_Boot-6DB33F.svg?logo=springboot&style=for-the-badge&logoColor=white" alt="Spring Boot">
  <img src="https://img.shields.io/badge/MySQL-4479A1.svg?logo=mysql&style=for-the-badge&logoColor=white" alt="MySQL">
</p>

---

## リポジトリ概要

このリポジトリでは、AWS環境の構築を以下の流れで学習しました。

- AWSサービスの手動構築
- CloudFormationを用いたインフラ構築
- Terraformを用いたインフラのコード化
- GitHub Actionsを用いたCI/CD
- Ansibleを用いた環境構築の自動化

インフラ構成の理解から、コード化、自動化までを段階的に学びながら、各課題に取り組んでいます。

---

## 構成図

手動構築、CloudFormation、Terraformで作成したAWS構成です。

<p align="center">
  <img src="./images/aws-study-architecture.png" alt="AWS構成図" width="800">
</p>

---

## このリポジトリで取り組んだこと

- AWSの基本サービス（EC2、RDS、S3、ALB、VPC）の構築
- CloudFormationによるインフラ構築
- Terraformによるインフラのコード化
- CloudWatchを用いた運用監視
- Terraform testを用いたインフラの自動テスト
- GitHub Actionsを用いたCI/CD環境構築
- Ansibleを用いた環境構築の自動化
- Spring BootアプリケーションとRDS接続の学習

---

## 学習内容の振り返り

| 課題 | 学習内容 | 取り組んだこと | 提出物 |
|------|------|------|------|
| 23 | インフラ構成図 | AWS構成図を作成し、各リソースの関係を整理 | [PR #3](https://github.com/MihoDaijo/aws-study/pull/3) |
| 25 | CloudFormation解説 | CloudFormationの基本理解 | [PR #4](https://github.com/MihoDaijo/aws-study/pull/4) |
| 27 | CloudFormation実演 | AWS環境をCloudFormationでコード化 | [PR #5](https://github.com/MihoDaijo/aws-study/pull/5) |
| 31 | 運用監視 | CloudWatch等を用いた監視設定 | [PR #6](https://github.com/MihoDaijo/aws-study/pull/6) |
| 33 | Terraform | CloudFormation構成をTerraformで再構築 | [PR #7](https://github.com/MihoDaijo/aws-study/pull/7) |
| 40 | 自動テスト | Terraform test等による検証 | [PR #8](https://github.com/MihoDaijo/aws-study/pull/8) |
| 41 | GitHub Actions | CI/CD環境構築 | [PR #32](https://github.com/MihoDaijo/aws-study/pull/32) |
| 43 | Ansible | 環境構築の自動化 | [PR #55](https://github.com/MihoDaijo/aws-study/pull/55) |

---

## 工夫した点

- 手動構築だけで終わらせず、CloudFormation、Terraformと段階的にコード化に取り組んだこと
- GitHub Actionsを利用し、インフラ変更の自動確認やCI/CDの流れを学んだこと
- Ansibleを用いて、環境構築の自動化にも取り組んだこと
- AWSサービスを個別に学ぶだけでなく、サービス同士のつながりを意識して構成を理解したこと

---

## 学習を通じて身についたこと

- AWSの主要サービスに関する基礎理解
- Infrastructure as Code の考え方
- Terraformによるインフラ管理
- GitHub Actionsによる自動化の基礎
- Ansibleによる構成管理の基礎
- インフラ構築から運用・自動化までを一連で考える視点

---

## 今後取り組みたいこと

- Terraformのモジュール設計をより深く理解すること
- AWS環境のセキュリティや監視設計について理解を深めること
- CI/CDや構成管理の自動化をさらに実践的に学ぶこと
- インフラエンジニアとして実務に近い形で経験を積むこと

---

## GitHub

RaiseTech課題提出リポジトリ  
<https://github.com/MihoDaijo/aws-study>
