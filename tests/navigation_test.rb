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
mobile_navigation_rule = mobile_css[/\.site-navigation \{([^}]*)\}/, 1].to_s
abort("FAIL: mobile navigation does not cover the full viewport") unless mobile_navigation_rule.include?("position: fixed") && mobile_navigation_rule.include?("inset: 0") && mobile_navigation_rule.include?("width: 100%") && mobile_navigation_rule.include?("min-height: 100vh") && mobile_navigation_rule.include?("min-height: 100dvh")
abort("FAIL: mobile navigation is below page content") unless mobile_navigation_rule.include?("z-index: 300")
abort("FAIL: mobile navigation uses transparent or filtered styling") if mobile_navigation_rule.match?(/rgba|opacity|backdrop-filter|mix-blend-mode|filter:/)
abort("FAIL: mobile navigation links do not use Soft White") unless mobile_css.match?(/\.site-navigation a \{[^}]*color: var\(--soft-white\);/)
abort("FAIL: mobile current navigation item is not visibly selected") unless mobile_css.include?('.site-navigation a[aria-current="page"]') && mobile_css.include?("border-left: 3px solid var(--gold)")
abort("FAIL: mobile close control lacks contrast") unless mobile_css.match?(/\.menu-close \{[^}]*background: var\(--solaris-blue\);[^}]*color: var\(--soft-white\);/)
abort("FAIL: mobile navigation label lacks contrast") unless mobile_css.match?(/\.mobile-nav-heading \{[^}]*color: var\(--soft-white\);/)
parent_override = mobile_css[/\.site-navigation\.is-open, \.site-navigation\.is-open ul, \.site-navigation\.is-open li \{([^}]*)\}/, 1].to_s
contrast_override = mobile_css[/\.site-navigation\.is-open \.mobile-nav-heading,.*?\{([^}]*)\}/, 1].to_s
svg_override = mobile_css.scan(/\.site-navigation\.is-open \.menu-close svg, \.site-navigation\.is-open \.menu-close svg path \{([^}]*)\}/).flatten.find { |rule| rule.include?("stroke:") }.to_s
abort("FAIL: open mobile navigation parents can reduce text opacity") unless parent_override.include?("opacity: 1 !important") && parent_override.include?("visibility: visible") && parent_override.include?("color: #f2f6fa")
abort("FAIL: explicit mobile text contrast override is missing") unless contrast_override.include?("color: #f2f6fa !important") && contrast_override.include?("opacity: 1 !important") && contrast_override.include?("visibility: visible") && contrast_override.include?("filter: none !important") && contrast_override.include?("mix-blend-mode: normal !important") && contrast_override.include?("text-shadow: none") && contrast_override.include?("-webkit-text-fill-color: #f2f6fa !important")
abort("FAIL: mobile close SVG contrast override is missing") unless svg_override.include?("fill: none") && svg_override.include?("stroke: #f2f6fa !important")
abort("FAIL: iOS page-position lock is missing") unless script.include?("lockedScrollPosition = window.scrollY") && script.include?('document.body.style.top = `-${lockedScrollPosition}px`') && script.include?("window.scrollTo(0, lockedScrollPosition)")

puts "PASS: Solaris Lucerna public navigation"
puts "  approved six-link order and accessible mobile behavior validated"
