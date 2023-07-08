import json
def handler(event, context):
    event['response'] = {
      'autoConfirmUser': True,
      'autoVerifyEmail': True,
      'autoVerifyPhone': False
      }
    return event