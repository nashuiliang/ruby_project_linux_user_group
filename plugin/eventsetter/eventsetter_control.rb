#coding: UTF-8

exit unless Object.const_defined? :ACCESS_ERROR

if Object.const_defined? :ASH_DEBUG
	require "#{MAIN_PATH}include/event/event_tool.rb"
else
	require "#{Ash::Disposition::SYS_DIR_CORE}control.rb"
	require "#{Ash::Disposition::MAIN_DIR_INCLUDE}event#{ASH_SEP}event_tool.rb"
end

module Ash
	module ModuleApp

		EventListPages = Struct.new(:content, :now_page, :left_page, :right_page) do
			def get_binding; binding(); end
		end

		#EventList = Struct.new(:title, :fmt_time, :content, :nid, :writer, ) do
			#def get_binding; binding(); end
		#end

		class EventsetterControl < Control

			public
			def ct_list_page(page = 1)
				et = ModuleTool::EventTool.new
				sp_len = (et.event_helper.active_count / Disposition::COMMON_EVENT_PAGE_MAX_NUM.to_f).ceil
				page = 1 if page <= 0 or sp_len < page
				l_page, r_page = page - 1, page + 1
				l_page = nil if l_page == 0
				r_page = nil if r_page > sp_len
				EventListPages.new(et.find_briefs_by_page(page), page, l_page, r_page)
			end

			def ct_list_details(num = 1)
				ModuleTool::EventTool.new.event_helper.find_by_nid(num)
			end

			def ct_verify_add(title = '', writer = '', cont = '')
				begin
					title, writer, cont = UtilsBase.html_strip(title.strip), UtilsBase.html_strip(writer.strip), cont.strip

					_verify = self._ct_verify(title, writer, cont)
					return _verify unless _verify.nil?
					ModuleTool::EventTool.new.insert(title, writer, cont)
					UtilsBase.inte_succ_info
				rescue
					UtilsBase.dev_mode? and raise
					UtilsBase.inte_bigerr_info
				end
			end

			def ct_verify_edit(num = '', title = '', writer = '', cont = '')
				begin
					num, title, writer, cont = UtilsBase.html_strip(num.strip), UtilsBase.html_strip(title.strip), UtilsBase.html_strip(writer.strip), cont.strip

					num = num.to_i
					et = ModuleTool::EventTool.new.init_event(nid: num)
					return UtilsBase.inte_err_info(4001, 'Page Do Not Edit') unless et.active?

					_verify = self._ct_verify(title, writer, cont)
					return _verify unless _verify.nil?
					et.update(num, title, writer, cont)
					UtilsBase.inte_succ_info
				rescue
					UtilsBase.dev_mode? and raise
					UtilsBase.inte_bigerr_info
				end
			end

			def ct_delete(num)
				cont = Disposition::COMMON_PAGE_DELETE_SUCC
				at = ModuleTool::EventTool.new.init_event(nid: num)
				if at.active?
					cont = Disposition::COMMON_PAGE_DELETE_ERROR unless at.event_helper.not_active
				else
					cont = Disposition::COMMON_PAGE_NOT_EXIST
				end
				cont
			end

			protected
			def _ct_verify(title, writer, cont)
				return UtilsBase.inte_err_info(2001, 'Event Title Not Empty') if title.empty?
				return UtilsBase.inte_err_info(2002, 'Event Time Not Empty') if writer.empty?
				return UtilsBase.inte_err_info(2005, 'Event Content Not Empty') if cont.empty?
			end

		end
	end
end
