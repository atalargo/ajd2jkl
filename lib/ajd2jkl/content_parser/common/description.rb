module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiDescription parser
            # multiline: true
            # @apiDescription [text]
            class Description < AbstractCommonMultiline
                attr_reader :description

                def analyze
                    Ajd2jkl.verbose_say('Analyzing Common/Description... ')
                    @description = @raw.rstrip
                    @raw = nil
                end

                def end_multiline
                    Ajd2jkl.verbose_say(" Found Description #{@description}")
                end
            end
        end
    end
end
