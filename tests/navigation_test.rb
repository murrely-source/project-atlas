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
abort("FAIL: mobile navigation uses transparent or filtered styling") if mobile_navigation_rule.match?(/rgba|backdrop-filter|mix-blend-mode|filter:|opacity:\s*(?:0|\.[0-9])/)
abort("FAIL: mobile navigation foreground variable is missing") unless mobile_navigation_rule.include?("--mobile-navigation-foreground: #f2f6fa") && mobile_navigation_rule.include?("color: var(--mobile-navigation-foreground)")
abort("FAIL: mobile navigation links do not inherit the menu foreground") unless mobile_css.match?(/\.site-navigation a \{[^}]*color: inherit;[^}]*opacity: 1;/)
abort("FAIL: mobile current navigation item is not visibly selected") unless mobile_css.include?('.site-navigation a[aria-current="page"]') && mobile_css.include?("border-left: 3px solid var(--gold)")
abort("FAIL: mobile close control does not inherit the menu foreground") unless mobile_css.match?(/\.menu-close \{[^}]*background: var\(--solaris-blue\);[^}]*color: inherit;[^}]*opacity: 1;/)
abort("FAIL: mobile navigation label does not inherit the menu foreground") unless mobile_css.match?(/\.mobile-nav-heading \{[^}]*color: inherit;[^}]*opacity: 1;/)
abort("FAIL: mobile menu state does not synchronize aria-hidden and inert") unless script.include?('navigation.setAttribute("aria-hidden", String(navigationHidden))') && script.include?("navigation.inert = navigationHidden") && script.include?("synchronizeNavigationState();")
abort("FAIL: iOS page-position lock is missing") unless script.include?("lockedScrollPosition = window.scrollY") && script.include?('document.body.style.top = `-${lockedScrollPosition}px`') && script.include?("window.scrollTo(0, lockedScrollPosition)")

puts "PASS: Solaris Lucerna public navigation"
puts "  approved six-link order and accessible mobile behavior validated"
