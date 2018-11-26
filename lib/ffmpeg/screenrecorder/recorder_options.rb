module FFMPEG
  class Screenrecorder
    # @since 1.0.0-beta2
    class RecorderOptions
      def initialize(options)
        @options = verify_options options
      end

      #
      # Returns given recording format
      #
      def format
        determine_format
      end

      #
      # Returns given framerate
      #
      def framerate
        @options[:framerate]
      end

      #
      # Returns given input file or infile
      #
      def infile
        @options[:infile]
      end

      #
      # Returns given output filepath
      #
      def output
        @options[:output]
      end

      #
      # Returns given values that are optional
      #
      def advanced
        @options[:advanced]
      end

      #
      # Returns given log filename
      #
      def log
        @options[:log]
      end

      #
      # Returns given log_level
      #
      def log_level
        @options[:log_level]
      end

      #
      # Returns all given options
      #
      def all
        @options
      end

      #
      # Returns a String with all options parsed as a String,
      # ready for the ffmpeg process to use
      #
      def parsed
        vals = "-f #{determine_format} "
        vals << "-r #{@options[:framerate]} "
        vals << advanced_options if @options[:advanced]
        vals << "-i #{determine_infile} "
        vals << @options[:output]
        vals << ffmpeg_log_to(@options[:log]) # If provided
      end

      private

      #
      # Verifies the required options are provided and returns
      # the given options Hash
      #
      def verify_options(options)
        missing_options = required_options.select { |req| options[req].nil? }
        err             = "Required options are missing: #{missing_options}"
        raise(ArgumentError, err) unless missing_options.empty?

        options
      end

      #
      # Returns Array of required options sa Symbols
      #
      def required_options
        # -r framerate
        # -i input
        # output
        return %i[framerate infile output] unless OS.linux?

        %i[framerate output] # Linux
      end

      #
      # Returns advanced options parsed and ready for ffmpeg to receive.
      #
      def advanced_options
        return nil unless @options[:advanced]
        raise(ArgumentError, ':advanced cannot be empty.') if options[:advanced].empty?

        arr = []
        options[:advanced].each do |k, v|
          arr.push "-#{k} #{v}"
        end
        arr.join(' ') + ' '
      end

      #
      # Returns portion of the command which determines
      # if the ffmpeg output will be logged to a file
      # or completely ignored based on if the user
      # provides a log filepath in the options.
      #
      def ffmpeg_log_to(file)
        return " 2> #{file}" if file

        '> nul 2>&1' # No log file given
      end

      #
      # Returns final infile parameter.
      # Adds title= qualifier to infile parameter
      # unless the user is recording the desktop.
      #
      def determine_infile
        # x11grab doesn't support window capture
        return ':0.0' if OS.linux?

        return @options[:infile] if @options[:infile] == 'desktop'

        # Windows only
        %("title=#{@options[:infile]}")
      end

      #
      # Returns format based on the current OS.
      #
      def determine_format
        return @options[:format] if @options[:format]

        if OS.windows?
          'gdigrab'
        elsif OS.linux?
          'x11grab'
        elsif OS.mac?
          'avfoundation'
        else
          raise NotImplementedError, 'Your OS is not supported.'
        end
      end
    end
  end
end