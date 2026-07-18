#!/usr/bin/env ruby
# Public navigation and mobile-menu contracts.

root = File.expand_path("..", __dir__)
html = File.read(File.join(root, "app", "index.html"), encoding: "UTF-8")
config = File.read(File.join(root, "app", "brand-config.js"), encoding: "UTF-8")
script = File.read(File.join(root, "app", "site.js"), encoding: "UTF-8")
css = File.read(File.join(root, "app", "site.css"), encoding: "UTF-8")

expected = [
  ["Home", "#home"],
  ["Solutions", "#solutions"],
  ["LENS", "#lens"],
  ["Resources", "#resources"],
  ["About", "#about"],
  ["Contact", "#contact"]
]

configured = config.scan(/label: "([^"]+)", href: "([^"]+)"/)
abort("FAIL: approved navigation changed: #{configured.inspect}") unless configured == expected
abort("FAIL: primary navigation landmark is missing") unless html.include?('id="site-navigation" aria-label="Primary navigation"')
abort("FAIL: accessible mobile menu control is missing") unless html.include?('id="site-menu-button" type="button" aria-expanded="false" aria-controls="site-navigation"')
abort("FAIL: mobile close and backdrop controls are missing") unless html.include?('id="site-menu-close"') && html.include?('id="site-nav-backdrop"')
abort("FAIL: mobile open behavior is missing") unless script.include?('navigation.classList.add("is-open")') && script.include?('menuButton.setAttribute("aria-expanded", "true")')
abort("FAIL: mobile close behavior is missing") unless script.include?('navigation.classList.remove("is-open")') && script.include?('menuButton.setAttribute("aria-expanded", "false")')
abort("FAIL: Escape close is missing") unless script.match?(/event\.key === "Escape" && menuOpen/)
abort("FAIL: focus return is missing") unless script.include?("menuButton.focus()")
abort("FAIL: focus containment is missing") unless script.include?("function trapMenuFocus(event)")
abort("FAIL: current navigation state does not follow the selected section") unless script.include?("function updateCurrentNavigation()") && script.include?('window.addEventListener("hashchange", updateCurrentNavigation)')
abort("FAIL: navigation selection does not close mobile menu and restore focus") unless script.include?('event.target.closest("a")') && script.match?(/event\.target\.closest\("a"\).*?closeMenu\(\)/m)
mobile_css = css[/@media \(max-width: 767px\) \{(.*?)\n\}/m, 1].to_s
abort("FAIL: mobile navigation background is not opaque deep navy") unless mobile_css.match?(/\.site-navigation \{[^}]*background: #0d2637;/)
abort("FAIL: mobile navigation links do not use Soft White") unless mobile_css.match?(/\.site-navigation a \{[^}]*color: var\(--soft-white\);/)
abort("FAIL: mobile current navigation item is not visibly selected") unless mobile_css.include?('.site-navigation a[aria-current="page"]') && mobile_css.include?("border-left: 3px solid var(--gold)")
abort("FAIL: mobile close control lacks contrast") unless mobile_css.match?(/\.menu-close \{[^}]*background: var\(--solaris-blue\);[^}]*color: var\(--soft-white\);/)

puts "PASS: Solaris Lucerna public navigation"
puts "  approved six-link order and accessible mobile behavior validated"
