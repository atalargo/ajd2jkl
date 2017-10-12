module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiUse parser
            # multiline: false
            # @apiUse nameOfDefined
            class Use < AbstractCommon
                attr_reader :name_of_defined

                def analyze
                    Ajd2jkl.verbose_say('Analyzing Common/Use... ')
                    @name_of_defined = @raw.gsub(/\s/, '')
                    Ajd2jkl.verbose_say(" Found Use of predefined `#{@name_of_defined}`")
                    @raw = nil
                end
            end
        end
    end
end
