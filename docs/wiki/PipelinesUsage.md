# Pipelines Usage

This section gives you an overview of how to interact with the platform pipelines.

---

### _Navigation_

- [General](#general)
- [How to](#how-to)
  - [Operate the module pipelines](#operate-the-module-pipelines)
  - [Operate the dependency pipelines](#operate-the-dependency-pipeline)
- [DevOps-Tool-specific](#devops-tool-specific-considerations)
  - [GitHub Workflows](#github-workflows)

---

# General

When working with this platform's pipelines it is important to understand first which pipelines serve which purpose, when they are triggered and how you can use them to test your modules.

As described in the [Pipelines Design](./PipelinesDesign.md) section we offer the following pipelines:

| Pipeline | Target | Trigger | Notes |
| - | - | - | - |
| [Module Pipelines](./PipelinesDesign.md#module-pipelines) | Module | Changes to [module\|workflow] files in branch [main\|master] or manual | Used to test & publish modules. This is the most common pipeline you will interact with when working on modules. |
| [Dependencies pipeline](./PipelinesDesign.md#dependencies-pipeline) | All required dependency resources | Manual | Deploys resources we reference in the module tests. Should be run once before testing modules. |
| [ReadMe pipeline](./PipelinesDesign.md#readme-pipeline) | `README.md` in `<root>` & `<root>/arm` | Changes to [template files] in branch [main\|master] | Keeps the target ReadMe files aligned with the modules in the repository.  |
| [Wiki pipeline](./PipelinesDesign.md#wiki-pipeline) | Wiki | Changes in [docs/wiki] in branch [main\|master] | Keeps the Wiki-repository in sync with the wiki folder in the modules repository |

---

# How to

This section will give you instructions on how to use our interactive pipelines - independent of the DevOps tooling.



## Operate the module pipelines

## Operate the dependency pipeline

---

# DevOps-Tool-specific considerations

## GitHub Workflows
