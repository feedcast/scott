require "tempfile"

module AudioOperations
  class Wave < FunctionalOperations::Operation
    class CommandError < StandardError; end

    BIN = `which audiowaveform`

    def arguments
      required :file_path, String
      required :duration, Integer
    end

    def perform
      filename  = File.basename(@file_path, ".*")
      output_path = File.join(File.dirname(@file_path), "#{filename}.json")

      command = TTY::Command.new(logger: logger)
      result = command.run!("audiowaveform -i #{@file_path} -o #{output_path} -s 0 -e #{@duration}")

      raise CommandError, result.err unless result.success?

      output = File.read(output_path)

      json_output  = JSON.parse(output)
      json_output.fetch("data", [])
    end

    private

    def logger
      Rails.logger
    end
  end
end
