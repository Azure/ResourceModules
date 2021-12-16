# Convert Bicep files into ARM helper script

As Bicep is still in a beta phase and many people are used to ARM, it makes sense for some of them, to wait for the Bicep release. In that case, the bicep module files need to be converted to ARM files. A translator/compiler to do that is part of the Bicep toolkit. To run the tool on all bicep files and do some cleanup, a conversion script is supplied with the CARML library. This page is about this script and how to use it.

└───utilities
    │
    └───tools
        │   ConvertTo-ARMTemplate.ps1
