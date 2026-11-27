resource "aws_s3_bucket" "s3" {
  bucket = var.BUCKETNAME

  tags = {
    Name        = var.BUCKETNAME
  }
}
