#ホストゾーン
resource "aws_route53_zone" "route53_zone" {
  name          = var.domain
  force_destroy = false
  tags = {
    Name    = "${var.project}-${var.environment}-domain"
    Project = var.project
    Env     = var.environment
  }
}

#Aレコード
resource "aws_route53_record" "route53_record" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = "dev-elb.${var.domain}"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

#登録済みドメインのNSを上書き（暫定対応、TFバージョンの関係で一旦手動で更新する形式で保留）
# resource "aws_route53domains_registered_domain" "registered_domain" {
#   domain_name = var.domain

#   dynamic "name_server" {
#     for_each = toset(aws_route53_zone.route53_zone.name_servers)

#     content {
#       name = name_server.value
#     }
#   }
# }