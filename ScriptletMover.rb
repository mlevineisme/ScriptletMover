require 'FileUtils'

# This is a config value that may need to be changed
DIRECTORY_CONFIG_NAME = "ScriptletMover.conf"

SOURCE_FOLDER = FileUtils.pwd
puts "The source folder used to move the Scriptlet files from: #{SOURCE_FOLDER}"
DIRECTORY_CONFIG = File.open("#{SOURCE_FOLDER}/#{DIRECTORY_CONFIG_NAME}")
directory_paths = Array.new
DIRECTORY_CONFIG.each_line {|line| directory_paths << line.chomp}

# Gather the files list, removing the config, script, and GIT files
files = Dir.glob("*.*")
files.delete(DIRECTORY_CONFIG_NAME)
files.delete(__FILE__.split("/").last)
files.delete("README.md")

# Copy the source files into the destination directories
directory_paths.each {|path|
   
   # Give write access to the files, so they can be overwritten if "read only"
   files.each {|file|
      FileUtils.chmod("u=wrx,go=rx", "#{path}\\#{file}")}

   # Copy the files
   FileUtils.cp [*files], path, :preserve => true
   puts "Files copied to: #{path}"}