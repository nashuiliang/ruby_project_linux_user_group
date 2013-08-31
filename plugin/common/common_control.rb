#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require "#{Ash::Disposition::SYS_DIR_CORE}control.rb"
require 'fileutils'

module Ash
  module ModuleApp

    class CommonControl < Control

      def ct_image_uploader(args)
        begin
          upload = args['upload']
          file_sim_type = upload[:filename].split('.').last
          base_name = "/pictures/" + Time.now.to_i.to_s + '.' + file_sim_type
          FileUtils.move(upload[:tempfile].path.to_s, "#{Disposition::MAIN_DIR_ASSETS}#{base_name}" )
          base_name
        rescue
          UtilsBase.inte_err_info(4001, "file upload error")
        end

      end

      def ct_rss_subscribe
        begin
          File.open(Disposition::MAIN_FILE_RSS).read
        rescue
          UtilsBase.inte_bigerr_info
        end
      end
    end
  end
end