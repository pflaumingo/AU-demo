# insert your copyright here

# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/

require 'erb'

# start the measure
class SpaceLatentLoad < OpenStudio::Measure::ReportingMeasure
  # human readable name
  def name
    # Measure name should be the title case of the class name.
    return 'Space Latent Load'
  end

  # human readable description
  def description
    return 'Gathers the latent load on spaces and returns JSON keyed by the spaces CADObjectId'
  end

  # human readable description of modeling approach
  def modeler_description
    return ''
  end

  # define the arguments that the user will input
  def arguments
    args = OpenStudio::Measure::OSArgumentVector.new

    # this measure does not require any user arguments, return an empty list

    return args
  end
  
  # define the outputs that the measure will create
  def outputs
    outs = OpenStudio::Measure::OSOutputVector.new

    # this measure does not produce machine readable outputs with registerValue, return an empty list

    return outs
  end
  
  # return a vector of IdfObject's to request EnergyPlus objects needed by the run method
  # Warning: Do not change the name of this method to be snake_case. The method must be lowerCamelCase.
  def energyPlusOutputRequests(runner, user_arguments)
    super(runner, user_arguments)

    # result = OpenStudio::IdfObjectVector.new
    #
    # # use the built-in error checking
    # if !runner.validateUserArguments(arguments, user_arguments)
    #   return result
    # end
    #
    # request = OpenStudio::IdfObject.load('Output:Variable,,Site Outdoor Air Drybulb Temperature,Hourly;').get
    # result << request
    #
    # return result
  end

  # define what happens when the measure is run
  def run(runner, user_arguments)
    super(runner, user_arguments)

    # use the built-in error checking
    if !runner.validateUserArguments(arguments, user_arguments)
      return false
    end

    # get the last model and sql file
    model = runner.lastOpenStudioModel
    if model.empty?
      runner.registerError('Cannot find last model.')
      return false
    end
    model = model.get

    sql_file = runner.lastEnergyPlusSqlFile
    if sql_file.empty?
      runner.registerError('Cannot find last sql file.')
      return false
    end
    sql_file = sql_file.get
    model.setSqlFile(sql_file)

    # Latent load logic
    latent_loads = {}

    model.getSpaces.each do |space|
      thermal_zone = space.thermalZone.get
      zone_name = thermal_zone.name.get
      cad_object_id = space.additionalProperties.getFeatureAsString('CADObjectId').get

      query = "SELECT Value From TabularDataWithStrings WHERE TableName = 'Estimated Cooling Peak Load Components'
              AND UPPER(ReportForString) = '#{zone_name.upcase}' AND RowName = 'Grand Total' AND ColumnName == 'Latent'"

      result = sql_file.execAndReturnVectorOfString(query).get

      latent_loads[cad_object_id] = result.get unless result.nil?
    end
    # put data into the local variable 'output', all local variables are available for erb to use when configuring the input html file

    json_out = File.open("../space_latent_load.json", "w")
    json_out.write(JSON.dump(latent_loads))
    # close the sql file
    sql_file.close

    return true
  end
end

# register the measure to be used by the application
SpaceLatentLoad.new.registerWithApplication
