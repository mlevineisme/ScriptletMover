#-- This program copies files in the current directory that include "Scriptlets" into the
# folders specified in the .conf file of the same name

require 'FileUtils'

DIRECTORY_CONFIG_NAME = "#{File.basename(__FILE__, ".rb")}.conf"
SOURCE_FOLDER = FileUtils.pwd
puts "The source folder used to move the Scriptlet files from: #{SOURCE_FOLDER}"
DIR_CONF_FILE = File.open("#{SOURCE_FOLDER}/#{DIRECTORY_CONFIG_NAME}")
directory_paths = Array.new
DIR_CONF_FILE.each_line {|line| directory_paths << line.chomp}

#-- Gather the files list
filesToMove = Dir.glob("*Scriptlets.*")

#-- Copy the source files into the destination directories
directory_paths.each {|path|
   
   #-- Give write access to the files in team, so "read only" files can be overwritten
   filesToMove.each {|file|
      FileUtils.chmod("u=wrx,go=rx", "#{path}\\#{file}") if path.include?("team") and File.exist?("#{path}\\#{file}")}

   #-- Copy the files to their new directory
   if (File.directory?(path))
      FileUtils.cp [*filesToMove], path, :preserve => true
      puts "Files copied to: #{path}"
   else
      puts "Files were not copied to #{path}, because the path was invalid"
   end}