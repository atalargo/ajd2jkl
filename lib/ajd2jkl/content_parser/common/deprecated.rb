module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiDeprecated parser
            # multiline: true
            # @apiDeprecated [text]
            class Deprecated < AbstractCommonMultiline
                attr_reader :description

                def analyze
                    Ajd2jkl.verbose_say('Analyzing Common/Deprecated... ')
                    @description = @raw.rstrip
                    @raw = nil
                end

                def end_multiline
                    Ajd2jkl.verbose_say(" Found Deprecated #{@description}")
                end
            end
        end
    end
end
