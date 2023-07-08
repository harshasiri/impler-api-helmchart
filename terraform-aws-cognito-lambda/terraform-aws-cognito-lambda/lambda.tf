resource "aws_iam_role" "rolename" {
    count = var.create_cognito ? 1 : 0  
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "lambda.amazonaws.com"
                    }
                },

            ]
            Version   = "2012-10-17"
        }
    )
    
    tags                  = {
        "BU"          = "US"
        "Environment" = "dev"
        "Name"        = "miyo-US-Lambda_Role-${var.Environment}-${var.region}"
    }
    tags_all              = {
        "BU"          = "US"
        "Environment" = "dev"
        "Name"        = "miyo-US-Lambda_Role-${var.Environment}-${var.region}"
    }

    inline_policy {
        name   = "kmsReadInline"
        policy = jsonencode(
            {
                Statement = [
                    {
                        Action   = [
                            "cognito-idp:AdminCreateUser",
                        ]
                        Effect   = "Allow"
                        Resource = "*"
                    },
                    {
                        Action   = [
                            "kms:DescribeKey",
                        ]
                        Effect   = "Allow"
                        Resource = "*"
                    },
                ]
            }
        )
    }

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    # Add more managed policies as needed
  ]

}
data "archive_file" "Zip_the_python_code" {
  type = "zip"
  source_dir = "${path.module}/presignup/"
  #source_file = "${path.module}/presignup/"
  output_path = "${path.module}/presignup/index.zip"
}

# aws_lambda_function.function_name:
resource "aws_lambda_function" "functionname" {
    count = var.create_cognito ? 1 : 0
    description                    = "This trigger is invoked when a user submits their information to sign up, allowing you to perform custom validation to accept or deny the sign up request."
    function_name                  = "miyo-US-LambdaPreSignUp-${var.Environment}-${var.region}"
    handler                        = "index.handler"
    memory_size                    = 128
    package_type                   = "Zip"
    role                           = aws_iam_role.rolename[count.index].arn
    runtime                        = "python3.8"
    filename                       = "${path.module}/presignup/index.zip"
    tags                           = {
        "BU"          = "US"
        "Environment" = "dev"
        "Name"        = "miyo-US-LambdaPreSignUp-${var.Environment}-${var.region}"
    }
    tags_all                       = {
        "BU"          = "US"
        "Environment" = var.Environment
        "Name"        = "miyo-US-LambdaPreSignUp-${var.Environment}-${var.region}"
    }
    timeout                        = 360
    ephemeral_storage {
        size = 512
    }


}


# resource "aws_iam_role" "lambda_basic_execution_role" {
#   count = var.create_cognito ? 1 : 0     
#   name = "LambdaBasicExecutionRole"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_policy_attachment" "lambda_basic_execution_role_policy" {
#   name       = "LambdaBasicExecutionRolePolicy"
#   roles      = [aws_iam_role.lambda_basic_execution_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
#  AKIAYBZKTND6GIZJJZN7
# AWS Secret Access Key [****************SWBw]: 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
resource "aws_lambda_permission" "allow_cloudwatch" {
  count = var.create_cognito ? 1 : 0  
  statement_id  = "CSI_PreSignUp_us-east-1TRePfwFju_CSI_PreSignUp"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.functionname[count.index].function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = "arn:aws:cognito-idp:us-east-1:856478999786:userpool/us-east-1_TRePfwFju"
#   qualifier     = aws_lambda_alias.test_alias.name
}
resource "aws_lambda_permission" "allow_cloudwatch2" {
  count = var.create_cognito ? 1 : 0      
  statement_id  = "miyo-dev-test-UserPoolToCognitoTriggeredPermissionPreSignUp-1PTHZZRFUCZUV"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.functionname[count.index].function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = "arn:aws:cognito-idp:us-east-1:856478999786:userpool/us-east-1_TRePfwFju"
#   qualifier     = aws_lambda_alias.test_alias.name
}
resource "aws_lambda_permission" "allow_cloudwatch3" {
  count = var.create_cognito ? 1 : 0      
  statement_id  = "CSI_PreSignUp_us-east-1UgveQ7uBK_CSI_PreSignUp"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.functionname[count.index].function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = "arn:aws:cognito-idp:us-east-1:856478999786:userpool/us-east-1_UgveQ7uBK"
#   qualifier     = aws_lambda_alias.test_alias.name
}