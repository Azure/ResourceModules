The CARML library is continuously improved and updated.

This section provides an overview of how to keep your library up-to-date.

## Customization

A factor to take into account before updating your local copy of the library is if your copy deviates from the upstream version due to customizations you applied to the code.

Customizations are normally of two kinds: general improvements which may be useful for the public or something specific to your own environment.

### General improvements

As a [Solution Developer](./The%20context%20-%20Logical%20layers%20and%20personas#solution-developer) you may need to modify existing modules to get a new feature that is not implemented yet or to fix a bug.

In this case we recommend to [contribute](./Contribution%20guide) to the public CARML repository, in the spirit of collaboration and open source principles, helping to maintain a common codebase.

Contributing back to the upstream repository has two main advantages:

1. Once merged, your improvements will be already part of next CARML releases and you won't need to deal with those customizations the next time you'll fetch latest changes from upstream.

1. Your improvements will be validated in the CARML CI environment, and you can avoid managing additional validation of those customizations going forward.

### Specific requirements

As a [Module Developer](./The%20context%20-%20Logical%20layers%20and%20personas#module-developer) you might add to the library company/organization specifics, either via conventions, parameters, extensions, or CI-specific changes.

In this case every time you integrate CARML updates into your own library, you'll have to compare the new public code with your customized one and re-apply your customizations to the updated code. This process can be automated, by script or CI, if customization tasks are repeatable.

In addition, you'll need to manage the validation of your updated and customized modules.

We recommend to adopt module library with the CI environment in this case, to automate the import of new code and speed up the validation process.

## CARML updates' impact on your copy of the library

CARML updates can have different impacts on your version of the library:

- Impacts limited to the CI environment
- Impacts limited to specific modules
- Impacts on all the modules when design changes are implemented

Before to proceed with the updates it's always recommended to check the new release's highlights on the [releases](https://github.com/Azure/ResourceModules/releases) page, and the [closed pull requests](https://github.com/Azure/ResourceModules/pulls?q=is%3Apr+is%3Aclosed) to have an overview of what has been changed and the possible impact on your library.

## Update procedure

The update procedure depends on which scenario you adopted when onboarding CARML:
- [**Scenario 1:** Consume library](./Fetching%20latest%20changes%20-%20Scenario%201%20Consume%20library). In this case we refer to the update of your copy of module templates.
- [**Scenario 2:** Module library and CI environment](./Fetching%20latest%20changes%20-%20Scenario%202%20Module%20library%20and%20CI%20environment). In this case we refer to the update of both your internalized library's repository and the related CI environment.
