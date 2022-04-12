name: Feature request \U0001F680
description: Suggest an idea for this project
title: "[Feature Request]: "
labels: ["enhancement"]
body:
  - type: markdown
    attributes:
      value: |
        Thank you for suggesting a new feature

        <!-- Please search existing issues to avoid creating duplicates. -->
  - type: textarea
    id: bdescription
    attributes:
      label: Description
      description: Please describe your request
    validations:
      required: true
