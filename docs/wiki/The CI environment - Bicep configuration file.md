This section provides details on the Bicep configuration file (`bicepconfig.json`) used in the CARML CI environment.

---

### _Navigation_

- [Description](#description)

---

# Description

Using this file you can customize your Bicep development experience. This includes
- Linter Rules (e.g., [max parameters](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/linter-rule-max-parameters))
- Source locations (e.g., [aliases](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config-modules))

For a full list of available rules, please refer to the [official documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config).

> If you remove this file, Bicep uses default values

# Applied rules

The configuration applied in our CI environment can be found in the `bicepconfig.json` file in the root folder. Next to the corresponding settings you will also find the rational for its application.
