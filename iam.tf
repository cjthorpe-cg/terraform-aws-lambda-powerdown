data "aws_iam_policy_document" "powerdown_scheduler_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com",
      "events.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "powerdown_scheduler_role" {
  assume_role_policy = data.aws_iam_policy_document.powerdown_scheduler_role.json
  name               = "powerdown-scheduler-role"
}

data "aws_iam_policy_document" "powerdown_scheduler_policy" {
  statement {
    actions = [
      "logs:*",
      "ec2:Describe*",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "powerdown_scheduler_policy" {
  name   = "powerdown-scheduler"
  policy = data.aws_iam_policy_document.powerdown_scheduler_policy.json
  role   = aws_iam_role.powerdown_scheduler_role.id
}
