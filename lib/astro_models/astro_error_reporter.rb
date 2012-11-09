module AstroModels::AstroErrorReporter

  def error_report(options = {})
    message = if options[:message]
      options[:message]
    else
      "#{options[:class_name]} request with parameters: <info>#{options[:params].inspect}</info> " +
      "was unsuccessful, <info>#{options[:exception].to_s}</info> error was raised"
    end
    message = message.gsub(/<info>(.*?)<\/info>/, "\033[93m\\1\033[31m")
    # \033[31m enables color, \033[0m disables color
    error_report_logger.error("\033[36m#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}: \033[31m#{message}\033[0m")
    # Do not cache block because there was an error
#    AstroCache.do_not_cache_block = true
    return nil
  end


  private

    def error_report_logger
      Rails.logger
    end

end
