#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

require 'set'
require 'json'
require 'digest'

module Ash
	module UtilsBase

		def self.email?(email)
			/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/ =~ email ? true : false
		end

		def self.uuid?(uuid)
			uuid =~ /^[0-9a-f]{40}$/ ? true : false
		end

		def self.password?(pwd)
			pwd =~ /^[0-9a-f]{32}$/ ? true : false
		end

		def self.md5_password(pwd = '')
			raise ArgumentError, "md5_password argument error" if pwd.empty?
			Digest::MD5.hexdigest(pwd)
		end

		def self.format_time(time = '')
			raise ArgumentError, "format_time argument error" if time.empty?
			Time.at(time.to_i).utc.strftime("%F %R").to_s
		end

		def self.split_time(time = '')
			raise ArgumentError, "format_time argument error" if time.empty?
			result = time.split('-')
			raise ArgumentError, "format_time argument error" unless result.length == 3
			Struct.new(:year, :month, :day).new(result[0].to_i, result[1].to_i, result[2].to_i)
		end

		def self.time?(t = '')
			raise ArgumentError, "time argument error" if t.empty?
			/^(201[0-9])-((0[1-9])|(1[0-2]))-((0[1-9])|([1-2][0-9])|(3[0-1]))$/ =~ t ? true : false
		end

		def self.arr_password?(*pwds)
			raise ArgumentError, "arr_password argument error" if pwds.empty?
			pwds.each {|pwd| return false unless self.password?(pwd)}
			true
		end

		def self.inte_basic_info(args)
			args.to_json
		end

		def self.inte_info(status, type, info)
			{status: status, type: type, info: info}.to_json
		end

		def self.inte_err_info(type, info)
			self.inte_info(false, type, info)
		end

		def self.inte_bigerr_info
			self.inte_info(false, Disposition::COMMON_PAGE_BIG_ERROR, Disposition::COMMON_PAGE_BIG_ERROR_INFO)
		end

		def self.inte_succ_info
			self.inte_info(true, Disposition::COMMON_PAGE_SUCCESS, Disposition::COMMON_PAGE_SUCCESS_INFO)
		end

		def self.inte_equal_info(info = '')
			self.inte_info(true, Disposition::COMMON_PAGE_EQUAL, info)
		end

		def self.chars_zh?(str)
			str =~ /\p{Han}/u ? true: false
		end

		def self.dev_mode?
			ASH_MODE == ASH_MODE_DEV
		end
	end
end
