inputs: {}
resources:
  terraform:
    type: Cloud.Terraform.Configuration
    properties:
      providers:
        - name: aws
        # List of available cloud zones: AWS/ap-northeast-2
          cloudZone: AWS/ap-northeast-2
      terraformVersion: 1.4.6
      configurationSource:
        repositoryId: 14ecd84b-dbd7-4db9-985c-b295bb9bd846
        commitId: ab715661c5e338cfc572d9541521f785af395294
        sourceDirectory: /
