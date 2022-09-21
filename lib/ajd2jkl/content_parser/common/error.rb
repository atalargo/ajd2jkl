module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiError parser
            # multiline: true
            # @apiError [(group)] [{type}] field [description]
            class Error < AbstractParametrable

                # test regexp http://rubular.com/r/UwvIDkAa8b
                @@parser = %r{
                    ^
                        (\((?<group>\w[-\w\s]*)\)\s+)?
                        ({(?<type>(
                            [a-zA-Z]\w*|
                            |
                            \[[A-Za-z][-\s\w]+\]\([^\s\)]*\)
                        ))}\s+)?
                        (?<field>[\w]*)\s*
                        (?<description>\S.*)?
                    $
                }x

                def analyze
                    Ajd2jkl.verbose_say('Analyzing Common/Error... ')
                    match = @@parser.match(@raw)
                    raise "Missing `field` part of @apiError declaration (RE: #{@@parser}) raw: #{@raw}" unless match && match[:field]
                    @group = match[:group] unless match[:group].nil? || match[:group].strip == ''
                    @type = match[:type] unless match[:type].nil? || match[:type].strip == ''
                    @field = match[:field]
                    @description = match[:description] unless match[:description].nil?
                    @raw = nil
                end
            end
        end
    end
end
