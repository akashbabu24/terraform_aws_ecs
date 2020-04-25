data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [""] # insert values here
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["", ""] # insert values here
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["", ""] # insert values here
  }
}
