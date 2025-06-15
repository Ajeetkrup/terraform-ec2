resource aws_s3_bucket state_bucket {
    bucket = "terra-tut-state-buck"

    tags = {
        Name = "terra-tut-state-buck"
    }
}