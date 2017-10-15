module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiParam parser
            # multiline: true
            # @apiParam [(group)] [{type}] [field=defaultValue] [description]
            class Param < AbstractParametrable
                # test regexp http://rubular.com/r/l9BCILbz8K

                @@parser = %r{
                    ^\s*
                    (\((?<group>\w[-\w\s]*)\)\s)?\s*
                    (
                        \{(?<type>(
                                [a-zA-Z]\w*
                                (\s?\{\d*[-\.]{0,2}\d*\})?
                                (\[\])?
                                (=[^\}]+)?
                                |
                                \[[A-Za-z][-\s\w]+\]\([^\s\)]*\)
                        ))\}\s
                    )?\s*
                    (?<field>
                        \[?
                            [-\w\.]+
                            (=[-"'\w]*)?
                        \]?
                    )
                    \s*
                    (?<description>\S.*)?
                    $
                }x

                def analyze
                    Ajd2jkl.verbose_say('Analyze Common/Param... ')
                    match = @@parser.match(@raw)
                    raise "Parsing apiParam don't have `field` part (RE: #{@@parser}) raw: #{@raw}" unless match && match[:field]
                    @group = match[:group] unless match[:group].nil? || match[:group].strip == ''
                    @type = match[:type] unless match[:type].nil? || match[:type].strip == ''
                    @field = match[:field]
                    md = /\=(?<defvalue>.*)$/.match @field
                    @default_value = md[:defvalue].strip unless md.nil? || md[:defvalue].strip == ''
                    @description = match[:description] unless match[:description].nil?
                    @raw = nil
                end
            end
        end
    end
end
