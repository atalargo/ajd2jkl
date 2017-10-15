module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiHeader parser
            # multiline: true
            # @apiHeader [(group)] [{type}] [field=defaultValue] [description]
            class Header < AbstractParametrable
                # test regexp http://rubular.com/r/l9BCILbz8K

                @@parser = %r{
                    ^
                    (\((?<group>\w[-\w\s]*)\)\s)?\s*
                    ({(?<type>[a-zA-Z]\w*)}\s)?\s*
                    (?<field>
                        \[?
                            \w[\w]*
                            (=[-"'\w]*)?
                        \]?
                    )
                    \s*
                    (?<description>\S.*)?
                    $
                }x

                def analyze
                    Ajd2jkl.verbose_say('Analyze Common/Header... ')
                    match = @@parser.match(@raw)
                    raise "Parsing apiHeader don't have `field` part (RE: #{@@parser}) raw: #{@raw}" unless match && match[:field]
                    @group = match[:group] unless match[:group].nil? || match[:group].strip == ''
                    @type = match[:type] unless match[:type].nil? || match[:type].strip == ''
                    @field = match[:field]
                    md = /\=(?<defvalue>.*)$/.match @field
                    @default_value = md[:defvalue].strip unless md.nil? || md[:defvalue].strip == ''
                    @description = match[:description] unless match[:description].nil?
                    Ajd2jkl.verbose_say(" Found Header `#{@field}`#{@type ? ' of type '+@type : ''}#{@group ? " in group `#{@group}`" : ''}")
                    @raw = nil
                end
            end
        end
    end
end
