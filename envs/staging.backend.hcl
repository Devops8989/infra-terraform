bucket         = "eks-demo-tfstate-<suffix-from-output>"  # replace with output
key            = "staging/eks/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "eks-demo-tf-locks"
encrypt        = true
kms_key_id     = "<kms-key-arn-from-output>"
