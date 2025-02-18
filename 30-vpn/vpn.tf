resource "aws_key_pair" "openvpn" {
  key_name   = "openvpnas"
  public_key = file("c:\\devops\\daws-82s\\openvpnas.pub")
}
resource "aws_instance" "openvpn" {
  ami                    = data.aws_ami.openvpn.id
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.openvpn.key_name
  subnet_id = local.public_subnet_ids
  user_data = file("user-data.sh")
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
    

}
output "vpn_ip"{
  value = aws_instance.openvpn.public_ip
}