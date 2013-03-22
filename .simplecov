SimpleCov.start do
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group 'Helpers', 'app/helpers'
  add_group "Libraries", "lib/"

  #add_group "Long files" do |src_file|
  #  src_file.lines.count > 100
  #end
  #add_group "Short files", LineFilter.new(5) # Using the LineFilter class defined in Filters section above
end