provider "aws" {
  region = "us-east-1"
   
}

resource "aws_cognito_user_pool_client" "app1" {
    count = var.create_cognito ? 1 : 0   
    access_token_validity                         = 1
    allowed_oauth_flows                           = [
        "code",
        "implicit",
    ]
    allowed_oauth_flows_user_pool_client          = false
    allowed_oauth_scopes                          = [
        "aws.cognito.signin.user.admin",
        "email",
        "openid",
        "phone",
        "profile",
    ]
    auth_session_validity                         = 3
    callback_urls                                 = [
      "https://aivk.rf.gd/?i=2",
    ]
    enable_propagate_additional_user_context_data = false
    enable_token_revocation                       = true
    explicit_auth_flows                           = [
        "ALLOW_ADMIN_USER_PASSWORD_AUTH",
        "ALLOW_CUSTOM_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH",
        "ALLOW_USER_SRP_AUTH",
    ]
    id_token_validity                             = 1
    logout_urls                                   = [
        "https://aivk.rf.gd/?i=2",
    ]
    name                                          = "miyo-US-portal_web-${var.Environment}-${var.region}"
    read_attributes                               = [
        "custom:master_account_id",
        "custom:source",
        "email",
        "name",
    ]
    refresh_token_validity                        = 7
    supported_identity_providers                  = [
        "COGNITO",
    ]
    user_pool_id                                  = aws_cognito_user_pool.miyo-cognito[count.index].id 
    write_attributes                              = [
        "custom:master_account_id",
        "custom:source",
        "email",
        "name",
        "nickname",
    ]

    token_validity_units {
        access_token  = "days"
        id_token      = "days"
        refresh_token = "days"
    }
}

