---
name: "📝 Pull Request"
title: "feat: "
labels: enhancement
body:

- type: markdown
    attributes:
      value: |
        Thank you for your contribution! Please ensure your pull request adheres to the project's standards.

- type: textarea
    id: description
    attributes:
      label: "Description"
      description: "Provide a clear and concise description of the changes. What is the purpose of this pull request?
        What problem does it solve?"
    validations:
      required: true

- type: input
    id: issue-link
    attributes:
      label: "Related Issue"
      description: "Link to the issue that this pull request addresses. e.g., Closes #123"
      placeholder: "Closes #"
    validations:
      required: false

- type: checkboxes
    id: checklist
    attributes:
      label: "Checklist"
      description: "Please confirm the following before submitting your pull request."
      options:
        - label: "I have read the [**CONTRIBUTING.md**](CONTRIBUTING.md) document."
          required: true
        - label: "My commit message follows the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification."
          required: true
        - label: "I have updated the [**CHANGELOG.md**](CHANGELOG.md) with a description of my changes."
          required: true
        - label: "I have removed completed tasks from [**PLANNING.md**](PLANNING.md) and added new tasks as needed."
          required: true
        - label: "I have performed a self-review of my own code."
          required: true
        - label: "I have added or updated tests to cover my changes."
          required: false
        - label: "All new and existing tests passed."
          required: false
