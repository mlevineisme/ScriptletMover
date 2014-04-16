#-- This program copies files in the current directory that include "Scriptlets" into the
# folders specified in the .conf file of the same name

require 'FileUtils'

def print_err errorMsg
   puts errorMsg
   puts $!
   puts $!.backtrace
end

NAME_STRING = "Scriptlets"
SOURCE_FOLDER = FileUtils.pwd
puts "The Scriptlet Source Folder Is: #{SOURCE_FOLDER}\n\n"
DIRECTORY_CONFIG_NAME = "#{File.basename(__FILE__, ".rb")}.conf"

#-- Open the directory configuration file
begin
   DIR_CONF_FILE = File.open("#{SOURCE_FOLDER}/#{DIRECTORY_CONFIG_NAME}")
rescue
   print_err "A problem arose when trying to open the directory configuration file. Please verify it exists and is named to match the script file"
end

directory_paths = Array.new
DIR_CONF_FILE.each_line {|line| directory_paths << line.chomp}

#-- Collect the source Scriptlet file names and modification times
begin
   #-- Gather the files list
   filesToMove = Dir.glob("*#{NAME_STRING}.*")
   filesToMoveTimes = filesToMove.collect {|file| File.mtime(file)}
rescue
   print_err "A problem arose when trying to find the source Scriptlet files or their timestamps"
end

#-- Copy the source files into the destination directories
directory_paths.each do |path|
   
   #-- Give write access to the destination, so "read only" files can be overwritten.
   filesToMove.each do |file|
      begin
         FileUtils.chmod("u=wrx,go=rx", "#{path}\\#{file}") if (File.exist?("#{path}\\#{file}")) and !(File.writable?("#{path}\\#{file}"))
      rescue
         print_err "A problem arose when trying to adjust the permissions settings on pre-copy destination files"
      end
   end

   begin
      #-- Copy the files to their new directory
      if (File.directory?(path))
         FileUtils.cp [*filesToMove], path, :preserve => true

         #-- Compare the source and destination file modification times as an extra
         # verification that the files were correctly copied
         filesEqual = Array.new
         filesToMove.each do |file|
            if (File.mtime("#{path}\\#{file}").eql?(File.mtime(file)))
               filesEqual << true
            else
               filesEqual << false
               puts "#{SPACES}Failure: File located in at #{path}\\#{file} is the same as the source file!"
            end
         end
         if !(filesEqual.include?(false)) and !(filesEqual.empty?)
            puts "Files successfully copied to: #{path}"
         elsif (filesEqual.empty?)
            puts "No Scriptlet files were found in the source directory, so none we copied!"
         end
      else
         puts "#{SPACES}Failure: Files were not copied to #{path}, because the path was invalid!"
      end
   rescue
      print_err "A problem arose when trying to copy the files"
   end
end
DIR_CONF_FILE.close