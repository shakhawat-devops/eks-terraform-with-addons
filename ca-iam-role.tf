resource "aws_iam_policy" "ca_policy" {
  name        = "iam-ca-policy"

  policy = file ("ca-policy.json")

}