module Ajd2jkl
    module Generator
        module Jekyll
            def self.navbar(config, groups)
                header = if config.key? 'header'
                             entry_nav config['header']['title'], '', 1
                         else
                             ''
                         end
                footer = if config.key?('footer')
                             entry_nav(config['footer']['title'], File.basename(config['footer']['filename'], '.*'), 1)
                         else
                             ''
                         end
                groupnav = groups.map do |grp|
                    entry_nav grp[:name], grp[:burl], grp[:level], grp[:type]
                end.join('')
                nav = <<EOF
main:
#{header}#{groupnav}#{footer}
EOF
            end

            def self.entry_nav(name, url, level = 1, type = nil)
                "    - { name: '#{name.tr("'", '&quote;')}', level: #{level}, url: '/#{url}'#{type.nil? ? '' : ", type: '#{type}'"} }\n"
            end
        end
    end
end
