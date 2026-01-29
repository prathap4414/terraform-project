resource "aws_instance" "web" {
  count = length(module.vpc.public_subnet_ids)

  ami           = local.ami
  instance_type = var.node_groups["general"].instance_type
  key_name      = var.instance_keypair

  subnet_id              = module.vpc.public_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "${var.cluster_name}-web-${count.index}"
  }
}
