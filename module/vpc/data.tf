data    "aws_availability_zones" "available" {
    filter {
        name   = "state"
        values = ["available"]
    }
}

locals {
  azs =  slice(data.aws_availability_zones.available.names,0,length(var.public_subnet_cidr))
  
}
