module Ajd2jkl
    module Generator
        module Jekyll
            def self.layout
                lay =<<EOF
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
        <link rel="icon" href="images/favicon.ico" />
		<link rel="stylesheet" href="/css/style.css" />
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script src="/js/main.js"></script>
	</head>
	<body>
		<header>
			<h1>
				<a href="/"><img src="/images/logo.svg" height="40" alt="{{ site.title }} logo"></a>
				<button type="button" class="open-nav" id="open-nav"></button>
			</h1>

			<form action="/search/" method="get">
				<input type="text" name="q" id="search-input" placeholder="Search">
				<input type="submit" value="Search" style="display: none;">
			</form>

			{% include nav.html %}

			<p class="copyright">

			</p>
		</header>
		<div class="main">
			{{ content }}
		</div>
		<script>
			document.getElementById("open-nav").addEventListener("click", function () {
				document.body.classList.toggle("nav-open");
			});
		</script>
	</body>
</html>
EOF
            end
        end
    end
end
