module Ajd2jkl
    module Generator
        module Jekyll
            def self.navbar(config, groups)
                header = if config.key? 'header'
                             entry_nav config['header']['title'], File.basename(config['header']['filename'], '.*'), 1
                         else
                             ''
                         end
                footer = if config.key?('footer')
                             entry_nav(config['footer']['title'], File.basename(config['footer']['filename'], '.*'), 1)
                         else
                             ''
                         end
                groupnav = groups.map do |grp|
                    entry_nav grp[:name], grp[:burl], grp[:level]
                end.join('')
                nav = <<EOF
main:
#{header}#{groupnav}#{footer}
EOF
            end

            def self.navbar_include
                nav =<<EOF
<nav class="site-nav">
    <div class="nav-header">
        <a href="{{ '/' | prepend: site.baseurl }}">API Documentation</a>
        <img src="/images/{{site.logo}}">
    </div>

    <span class="sr-only">API Document</span>
    <ul>
      {% assign in_sub = false %}
      {% for node in site.data.sidebar.main %}
        {% if node.level == 1 %}
            {% if in_sub %}
                {% assign in_sub = false %}
                </ul>
            {% endif %}
        </li>
        {% endif %}
        <li>
          <a class="sidebar-nav-item{% if page.url == node.url %} active{% endif %} level{{ node.level }}" href="{{ node.url | relative_url }}">{{ node.name }}</a>
          {% if node.level == 2 %}
            {% assign in_sub = true %}
        </li>
        {% endif %}
      {% endfor %}
    </ul>

</nav>

EOF
            end

            def self.entry_nav(name, url, level = 1)
                "    - { name: '#{name.tr("'", '&quote;')}', level: #{level}, url: '/#{url}' }\n"
            end
        end
    end
end
