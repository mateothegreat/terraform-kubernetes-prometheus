resource "aws_ebs_volume" "data" {

    availability_zone = "us-east-1a"
    size              = var.volume_size

    tags = {

        Name = "${ var.name }-data"

    }

}
