# Introduction
This repository serves as a source to get users started with customizing Systems Analysis for their needs. 
It includes various useful links to resources to learn about the Systems Analysis Workflow from the UI, to understand
OpenStudio and how Measures and Workflows work, as well as pointers to EnergyPlus documentation and so on.

**These links and resources are supplemental to the AU class and webinars links in the next session. Please watch them first.**

# Getting Started with this Repository
As a first step to learning Systems Analysis, the following videos should be viewed:
 - Webinar by Ian Molloy, Autodesk Senior Product Manager: [An Introduction to Revit Systems Analysis](https://www.youtube.com/watch?v=8kvSB5abVH4)
 - AU Class by Ian Molloy: [Revit Systems Analysis Features and Framework: An Introduction](https://autodeskuniversity.smarteventscloud.com/connect/sessionDetail.ww?SESSION_ID=323529)
 - AU Class by Noah Pflaum: [Revit Systems Analysis Features and Framework—Creating Custom Workflows](https://autodeskuniversity.smarteventscloud.com/connect/sessionDetail.ww?SESSION_ID=323563)

Additional information regarding standard back-end assumptions can be found at the [Autodesk Knowledge Network](https://knowledge.autodesk.com/support/revit-products/learn-explore/caas/CloudHelp/cloudhelp/2020/ENU/Revit-Analyze/files/GUID-A262F53F-B389-4846-89EF-5855F55476A5-htm.html).

*Note: that the "Heating and Cooling Loads Analysis" section is a different product that should not be confused with Systems Analysis*

# Additional Links Mentioned in the Custom Workflows Class
## gbXML
gbXML is simply an xml file conforming to the gbXML schema that Revit writes all of the pertinent analysis information to.
OpenStudio then consumes the gbXML to generate the EnergyPlus model. The schema can be found [here](http://www.gbxml.org/schema_doc/6.01/GreenBuildingXML_Ver6.01.html).
Although it should be noted that Systems Analysis uses some non-compliant schema elements for the HVAC Systems.

## EnergyPlus
EnergyPlus is a Building Energy Modeling (BEM) engine used for both sizing equipment and performing various analyses such
as annual energy consumption prediction. More information can be found at it's webpage [here](https://energyplus.net/), 
as well as the most recent documentation [here](https://energyplus.net/documentation). The EnergyPlus input file, is a
text file known as IDF and it is unlikely users will work with it directly in the Systems Analysis workflow. That said,
if users want to gain an appreciation for working with EnergyPlus directly and for the hard work OpenStudio does for them,
then they should considering going through the getting started guide. Moreover, the Engineering Reference and Input Output
Reference help give users a greater understanding of what the inputs do (i.e. how controls work). Finally, the Output
Details and Examples section of the documentation provides further information on what data is available from the 
simulation outputs.

## OpenStudio
OpenStudio is a collection of software tools focused on building and orchestrating EnergyPlus simulations more easily.
OpenStudio contains extensive [User Documentation](https://nrel.github.io/OpenStudio-user-documentation/) highlighting
how to get started with OpenStudio, and [SDK Documentation](https://openstudio-sdk-documentation.s3.amazonaws.com/index.html)
to make navigating the API easier. I strongly suggest reading the [About Measures](https://nrel.github.io/OpenStudio-user-documentation/getting_started/about_measures/)
section, creating a ["Hello, World!" Measure](https://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/)
tutorial and, given that Systems Analysis uses OpenStudio Workflows, you should read up on the 
[OpenStudio Command Line Interace](https://nrel.github.io/OpenStudio-user-documentation/reference/command_line_interface/).
The OSW Structure sub section will be of most relevance, but feel free to read the entire page.

## Additional OpenStudio Projects
 - There is the [Parametric Analysis Tool (PAT)](https://nrel.github.io/OpenStudio-user-documentation/reference/parametric_studies/)
and [OpenStudio-server](https://nrel.github.io/OpenStudio-user-documentation/tutorials/large_scale_analysis/) that allow
users to run batches of simulations locally and in the cloud.
 - The OpenStudio Standards is a ruby gem (library) that makes generating typical buildings and systems easier, as well
 as providing baseline automation for some Standards (i.e. various versions of ASHRAE 90.1). You can read about it 
 [here](https://github.com/NREL/openstudio-standards)
 - The [Building Component Library](bcl.nrel.gov) is an online repository of Measures and and OpenStudio Components with a tutorial on
 how to use it available [here](https://nrel.github.io/OpenStudio-user-documentation/tutorials/tutorial_bcl/). It's a good
 resource for looking at other Measures people have built and made public to help you craft your own.

# Customizing Systems Analysis
The first step in customizing Systems Analysis should be to watch the AU class by Noah Pflaum above. It will highlight 
the Systems Analysis Framework and give an understanding of all the components involved and the end-to-end data flow 
from Revit through simulation and back again. It will walk you through two "Hello, World!" type of customizations.

The model used in the class in a simple single space/zone model with 1 PTAC that can be found in the models directory of
this repo. The model is available in the incomplete state and the final state after both customizations are complete. It is important to note for these tutorials that the Measures and Workflows (OSWs) reside at C:\Program Files\NREL\OpenStudio CLI For Revit 2020
by default.

The following notes provide some written guidance on how to complete the customizations, however, the AU class is the 
primary resource to follow.

## Customization Part 1: Adding more inputs to the simulation
The goal of this customization is to propagate more information from Revit into the simulation. In this example, the COP
is added to the PTAC DX cooling coil.
1. Open the SingleZonePTAC.rvt model and add a custom parameter to Zone Equipment
   - Revit > Manage > Project Parameters > Add
     - Name: "Cooling Coil COP"
     - Discipline: "Common"
     - Type of Parameter: "Number"
     - Group parameter under: "Energy Analysis"
     - Categories: ["Zone Equipment"]
   - This adds additional COP data to the gbXML - watch the customization class for more information.
2. Add an attribute to the PTAC class to store this added information
   - Open ptac.rb located at C:\Program Files\NREL\OpenStudio CLI For Revit 2020\measures\gbxml_hvac_import\resources\ptac.rb
   - At the top of the file, next to the other attributes add :cooling_coil_cop
3. Add code to the static xml constructor in ptac.rb to read the added data that will be present in the gbXML
   - Try and do this yourself reading the REXML documentation first. The solution is on the following line.
   - Add the following code to ptac.rb at line 37:
    ```ruby
    first_elem = REXML::XPath.first(xml, path="AnalysisParameter[Name[text()='Cooling Coil COP']]")
    if first_elem
      equipment.cooling_coil_cop = first_elem.elements['ParameterValue'].text.to_f
    end
    ```
4. Add code to the add_cooling_coil method to translate the data from the PTAC object to the OpenStudio cooling coil object.
   - This code should make a call to the setRatedCOP method of the CoilCoolingDXSingleSpeed object to set it's COP to the
   newly defined attribute (cooling_coil_cop) if it is present. The solution is below.
   - Add the following code to line 142 in the ptac.rb file.
   ```ruby
    cooling_coil.setRatedCOP(self.cooling_coil_cop) if self.cooling_coil_cop
   ```
5. If you can't get it to work, copy the ptac.rb file within the measures/gbxml_hvac_import/resources directory over to
your local measures Revit is running at C:\Program Files\NREL\OpenStudio CLI For Revit 2020\measures

## Customization Part 2: Getting more data back to Revit
The goal of this customization is to add the peak latent load back onto analytical spaces in Revit.
1. Open the SingleZonePTAC.rvt model and add a custom parameter to Analyical Spaces
   - Revit > Manage > Project Parameters > Add
     - Name: "Peak Latent Load"
     - Discipline: "HVAC"
     - Type of Parameter: "Cooling Load"
     - Group parameter under: "Energy Analysis"
     - Categories: ["Analytical Spaces"]
2. The measure for this tutorial has been written in advance and can be found in this repo at measures/space_latent_load.
Moreover an additional Workflow has been added to the workflows directory of this repo called "Space Latent Load Retrieval.osw".
   - Copy the space_latent_load directory into the measures located at C:\Program Files\NREL\OpenStudio CLI For Revit 2020\measures.
   - Copy the "Space Latent Load Retrieval.osw" into C:\Program Files\NREL\OpenStudio CLI For Revit 2020\workflows.
   - Run the simulation with this added workflow. You may need to restart Revit or add the new workflow manually.
     - See customization 3 in the class video.
3. After the simulation has run, open the dynamo graph provided in this repo in the dynamo directory and update the input path
to match that of the most recent simulation that writes out the space_latent_load.json file.
4. Run the dynamo graph and hopefully all works well.

# Extra bits of Information
- The IDE seen in the class is RubyMine and the text editor is Sublime Text 3.
- The Everything app is used to watch for most recent runs in the class. It can be found [here](https://www.voidtools.com/)
