require 'FileUtils'

# This is a config value that may need to be changed
DIRECTORY_CONFIG_NAME = "ScriptletMover.conf"
GIT_FILE = "README.md"

SOURCE_FOLDER = FileUtils.pwd
puts "The source folder used to move the Scriptlet files from: #{SOURCE_FOLDER}"
DIRECTORY_CONFIG = File.open("#{SOURCE_FOLDER}/#{DIRECTORY_CONFIG_NAME}")
directory_paths = Array.new
DIRECTORY_CONFIG.each_line {|line| directory_paths << line.chomp}

# Gather the files list, removing the config, script, and GIT files
files = Dir.glob("*.*")
files.delete(DIRECTORY_CONFIG_NAME)
files.delete(__FILE__.split("/").last)
files.delete(GIT_FILE) if files.include?(GIT_FILE)

# Copy the source files into the destination directories
directory_paths.each {|path|
   
   # Give write access to the files, so they can be overwritten if "read only"
   files.each {|file|
      FileUtils.chmod("u=wrx,go=rx", "#{path}\\#{file}") if path.include?("team") and File.exist?("#{path}\\#{file}")}

   # Copy the files
   if (File.directory?(path))
      FileUtils.cp [*files], path, :preserve => true
      puts "Files copied to: #{path}"
   else
      puts "Files were not copied to #{path}, because the path was invalid"
   end}