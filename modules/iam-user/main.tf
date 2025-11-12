# 1️⃣ Create IAM user
resource "aws_iam_user" "this" {
  name = var.user_name
  path = "/"
}

# 2️⃣ Attach AdministratorAccess policy
resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = var.policy_arn
}

# 3️⃣ Create access key
resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

# 4️⃣ Outputs for use
output "user_name" {
  value = aws_iam_user.this.name
}

output "access_key_id" {
  value     = aws_iam_access_key.this.id
  sensitive = true
}

output "secret_access_key" {
  value     = aws_iam_access_key.this.secret
  sensitive = true
}
