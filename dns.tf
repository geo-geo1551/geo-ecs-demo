

resource "aws_route53_record" "ecsdemo-tietoaws-com" {
  zone_id = "${var.tietoaws_com_zone_id}"
  name    = "ecsdemo.tietoaws.com"
  type    = "A"

  alias {
    name                   = "${aws_alb.ecs-load-balancer.dns_name}"
    zone_id                = "${aws_alb.ecs-load-balancer.zone_id}"
    evaluate_target_health = false
  }
}