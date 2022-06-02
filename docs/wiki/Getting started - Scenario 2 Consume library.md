In case you want to simply consume the modules of the library to build a solution, you only have to perform a few simple steps:

- [1. Download the library](#1-download-the-library)
- [2. (Optional) Convert library to ARM](#2-optional-convert-library-to-arm)
- [3. Build a solution](#3-build-a-solution)

# 1. Download the library

To gather a local copy of the library, you essentially have a few options to choose from:

<details>
<summary>Download a release</summary>

To download a specific release version of the repository:
1. Navigate to the [releases](https://github.com/Azure/ResourceModules/releases) page.
1. Scroll to the `'Assets'` section at the bottom end of the release you'd like to download
1. Here you will find a packaged version of the repository (as it was when the release was created) and can download it with a simple click on the `'Source code'` package (e.g. `Source code (zip)`) itself. This will start the download and drop the file in your default download folder.

    <img src="./media/SetupEnvironment/downloadZipRelease.png" alt="Download zip" height="150">

1. Finally, you only need to unpack the downloaded file to a location of your choice

</details>

<details>
<summary>Download latest</summary>

To download the latest version of the repository
1. Navigate to the main page of [CARML](https://aka.ms/CARML)
1. On the overview page, select the `<> Code` button to the top right, and select the `Download ZIP` button in the opening pop up to trigger the repository to be downloaded as a compressed file into your default download folder.

    <img src="./media/SetupEnvironment/downloadZipLatest.png" alt="Download zip" height="350">

1. Finally, you only need to unpack the downloaded file to a location of your choice

</details>

<details>
<summary>Clone latest</summary>

To clone the latest version of the repository
1. On your local machine, open a PowerShell session
1. Navigate to the location you want to clone the repository into
1. Run

    ```PowerShell
    git clone 'https://github.com/Azure/ResourceModules.git'
    ```

</details>

<p>

# 2. (Optional) Convert library to ARM

Note that in case you don't want to use Bicep, you always have the option to use the utility `ConvertTo-ARMTemplate`, we provide in path `utilities/tools`, to convert the repository to an ARM-only repository. For further information on how to use the tool, please refer to the tool-specific [documentation](./Interoperability%20-%20Bicep%20to%20ARM%20conversion).

# 3. Build a solution

With the codebase ready you can now start to build a solution. For examples on how to do so, please refer to the corresponding [solution creation](./Solution%20creation) section.
