#SSL証明書（us_east_1、ALB用）
resource "aws_acm_certificate" "us_east_1_cert" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name    = "${var.project}-${var.environment}-wildecard-sslcert-us_east_1"
    Project = var.project
    Env     = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_route53_zone.route53_zone
  ]
}

#SSL証明書（us_east_2、CloudFront用）
resource "aws_acm_certificate" "us_east_2_cert" {
  provider = aws.useast2

  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name    = "${var.project}-${var.environment}-wildecard-sslcert-us_east_2"
    Project = var.project
    Env     = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_route53_zone.route53_zone
  ]
}

#証明書検証用のランダムCNAMEレコードを追加
resource "aws_route53_record" "route53_acm_dns_resolve" {
  for_each = {
    for s in aws_acm_certificate.us_east_1_cert.domain_validation_options : s.domain_name => {
      name   = s.resource_record_name
      type   = s.resource_record_type
      record = s.resource_record_value
    }
  }

  allow_overwrite = true
  zone_id         = aws_route53_zone.route53_zone.id
  name            = each.value.name
  type            = each.value.type
  ttl             = 600
  records         = [each.value.record]
}

#証明書検証を確認
resource "aws_acm_certificate_validation" "cert_valid" {
  certificate_arn         = aws_acm_certificate.us_east_1_cert.arn
  validation_record_fqdns = [for s in aws_route53_record.route53_acm_dns_resolve : s.fqdn]
}
