# Terraform AWA SES

## Introduction
AWSで独自ドメインのSESを作成するためのモジュールです。
Route53を同時に作成するサンプルが多く公開されていますが、このモジュールはSESと受信用のs3を作るのみのシンプルなものになっています。
(理由としては、ドメインを別サイト(AWS以外)で取得しており、AWSの管理下に置けない場合を想定して作られているためです。)

## Usage
```
provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

module "ses" {
  source  = "ispec-inc/ses/aws"
  version = "0.1.0"
  
  providers = {
    aws = aws.use1
  }
 
  domain_name = "hoge.io"
  from_addresses = ["hogehoge@example.com"]
}
```

SESは扱えるリージョンが限られているため、(上記の様に)エイリアスとして定義する必要がある場合があります。

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| domain\_name | The domain name to configure SES. | `string` | n/a | yes |
| enable\_incoming\_email | Control whether or not to handle incoming emails. | `bool` | `true` | no |
| enable\_verification | Control whether or not to verify SES DNS records. | `bool` | `true` | no |
| from\_addresses | List of email addresses to catch bounces and rejections. | `list(string)` | n/a | yes |

## Outputs
now developing...

## License
Apache 2 Licensed. See LICENSE for full details.
