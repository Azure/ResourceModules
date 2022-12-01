This section provides details on the Bicep configuration used in the CARML CI environment. This configuration happens in two places, the Bicep Configuration File (`bicepconfig.json`) and inside the modules themselves.

---

### _Navigation_

- [Bicep Configuration File](#bicep-configuration-file)
- [Module-level Bicep configuration](#module-level-bicep-configuration)

---

# Bicep Configuration File

Using this file, you can customize your Bicep development experience. This includes
- Linter Rules (e.g., [max parameters](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/linter-rule-max-parameters))
- Source locations (e.g., [aliases](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config-modules))

For a full list of available rules, please refer to the [official documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config).

> If you remove this file, Bicep uses default values

The configuration applied in the CI environment can be found in the `bicepconfig.json` file in the root folder. Next to the corresponding settings you will also find the rational for its application.

# Module-level Bicep configuration

The Bicep DSL (Domain Specific Language) is continuously improved and extended with additional capabilities. Of of them, the Bicep Linter, provides guidance around template design & best practices - and surfaces any findings as warnings. However, while it is a great feature, there can be cases where rules show false-positives - or are not addressed by us immediately. For these cases, we occasionally apply ignore tags such as `#disable-next-line secure-secrets-in-params` on a module level.

> Note: Each ignore tag should be accompanied by a comment to justify its existence.

> Note: As we want to follow best-practices whenever we can, the ignore tags should only be applied when absolutely necessary, on a case-by-case basis.
