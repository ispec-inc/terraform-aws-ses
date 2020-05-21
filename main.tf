locals {
  stripped_domain_name = replace(var.domain_name, "/[.]$/", "")
  dash_domain          = replace(var.domain_name, ".", "-")
}

resource "aws_ses_domain_identity" "this" {
  domain = local.stripped_domain_name
}

resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}

#
# receipt resource
#

resource "aws_s3_bucket" "mailbox" {
  count = var.enable_incoming_email ? 1 : 0

  bucket = format("%s-mailbox", local.dash_domain)
}

resource "aws_s3_bucket_policy" "mailbox" {
  count = var.enable_incoming_email ? 1 : 0

  bucket = aws_s3_bucket.mailbox[0].id
  policy = data.aws_iam_policy_document.mailbox.json
}

data "aws_iam_policy_document" "mailbox" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = ["${aws_s3_bucket.mailbox[0].arn}/*"]
  }
}

resource "aws_ses_receipt_rule_set" "this" {
  count = var.enable_incoming_email ? 1 : 0

  rule_set_name = format("%s-primary-rules", local.dash_domain)
}

resource "aws_ses_active_receipt_rule_set" "this" {
  count = var.enable_incoming_email ? 1 : 0

  rule_set_name = aws_ses_receipt_rule_set.this[0].rule_set_name
}

resource "aws_ses_receipt_rule" "this" {
  count = var.enable_incoming_email ? 1 : 0

  name          = format("%s-s3-rule", local.dash_domain)
  rule_set_name = aws_ses_receipt_rule_set.this[0].rule_set_name

  recipients    = var.from_addresses
  enabled       = true
  scan_enabled  = true

  s3_action {
    position    = 1
    bucket_name = aws_s3_bucket.mailbox[0].id
  }
}

