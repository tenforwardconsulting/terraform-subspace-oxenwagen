resource "aws_route53_record" "web" {
  count = length(var.route53_zone_id) > 0 ? var.web_instance_count : 0
  zone_id = var.route53_zone_id
  name    = aws_instance.web[count.index].tags["Name"]
  type    = "A"
  ttl     = 300
  records = [aws_instance.web[count.index].public_ip]
}

resource "aws_route53_record" "worker" {
  count = length(var.route53_zone_id) > 0 ? var.worker_instance_count : 0
  zone_id = var.route53_zone_id
  name    = aws_instance.worker[count.index].tags["Name"]
  type    = "A"
  ttl     = 300
  records = [aws_instance.worker[count.index].public_ip]
}

resource "aws_route53_record" "lb" {
  count = length(var.route53_zone_id) > 0 ? 1 : 0
  zone_id = var.route53_zone_id
  name    = var.lb_domain_name
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.production.dns_name]
}
