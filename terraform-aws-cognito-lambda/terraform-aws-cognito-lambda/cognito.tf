resource "aws_cognito_user_pool" "miyo-cognito" {
    count = var.create_cognito ? 1 : 0  
    auto_verified_attributes   = [
        "email",
    ]

    deletion_protection        = "INACTIVE"
    mfa_configuration          = "OFF"
    name                       = "miyo-US-userpool-${var.Environment}-virginia"
    tags                       = {
        "BU"          = "US"
        "Environment" = var.Environment
        "Name"        = "miyo-US-userpool-${var.Environment}-virginia"
    }
    tags_all                   = {
        "BU"          = "US"
        "Environment" = var.Environment
        "Name"        = "miyo-US-userpool-${var.Environment}-virginia"
    }
    username_attributes        = [
        "email",
    ]

    account_recovery_setting {
        recovery_mechanism {
            name     = "verified_email"
            priority = 1
        }
    }

    admin_create_user_config {
        allow_admin_create_user_only = false

        invite_message_template {
            email_message = "Your username is {username} and temporary password is {####}. "
            email_subject = "Your temporary password"
            sms_message   = "Your username is {username} and temporary password is {####}. "
        }
    }

    email_configuration {
        email_sending_account = "COGNITO_DEFAULT"
    }

    lambda_config {
        pre_sign_up    =  aws_lambda_function.functionname[count.index].arn
    }

    password_policy {
        minimum_length                   = 8
        require_lowercase                = false
        require_numbers                  = false
        require_symbols                  = false
        require_uppercase                = false
        temporary_password_validity_days = 7
    }

    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "email"
        required                 = true

        string_attribute_constraints {
            max_length = "2048"
            min_length = "0"
        }
    }
    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "master_account_id"
        required                 = false

        string_attribute_constraints {
            max_length = "256"
            min_length = "1"
        }
    }
    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "name"
        required                 = true

        string_attribute_constraints {
            max_length = "2048"
            min_length = "0"
        }
    }
    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "source"
        required                 = false

        string_attribute_constraints {
            max_length = "256"
            min_length = "1"
        }
    }

    verification_message_template {
        default_email_option  = "CONFIRM_WITH_LINK"
        email_message         = "Your verification code is {####}. "
        email_message_by_link = "Please click the link below to verify your email address. {##Verify Email##}"
        email_subject         = "Your verification code"
        email_subject_by_link = "Your verification link"
    }
}
resource "aws_cognito_user_pool_domain" "domain" {
  count        = var.create_cognito ? 1 : 0
  domain       = var.domain
  user_pool_id = aws_cognito_user_pool.miyo-cognito[count.index].id
}
