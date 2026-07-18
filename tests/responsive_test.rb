#!/usr/bin/env ruby
# Responsive contracts for the Solaris Lucerna public website.

root = File.expand_path("..", __dir__)
html = File.read(File.join(root, "app", "index.html"), encoding: "UTF-8")
css = File.read(File.join(root, "app", "site.css"), encoding: "UTF-8")
script = File.read(File.join(root, "app", "site.js"), encoding: "UTF-8")
failures = []

failures << "viewport metadata is missing" unless html.include?('name="viewport" content="width=device-width, initial-scale=1"')
failures << "320px minimum layout contract is missing" unless css.include?("html { min-width: 320px;")
failures << "page-level overflow protection is missing" unless css.match?(/body \{[^}]*overflow-x: hidden;/)
failures << "fluid page container is missing" unless css.include?("width: min(100% - 40px, var(--page-width))")
failures << "tablet layout breakpoint is missing" unless css.include?("@media (max-width: 980px)")
failures << "mobile layout breakpoint is missing" unless css.include?("@media (max-width: 767px)")
failures << "small-phone layout breakpoint is missing" unless css.include?("@media (max-width: 420px)")
failures << "hero does not collapse on tablet" unless css.match?(/@media \(max-width: 980px\).*?\.hero-layout, \.lens-layout \{ grid-template-columns: 1fr; \}/m)
failures << "content grids do not collapse on mobile" unless css.match?(/@media \(max-width: 767px\).*?\.solution-grid, \.resource-grid \{ grid-template-columns: 1fr; \}/m)
failures << "narrative layout does not collapse on mobile" unless css.match?(/@media \(max-width: 767px\).*?\.perspective-layout \{ grid-template-columns: 1fr; \}/m)
mobile_css = css[/@media \(max-width: 767px\) \{(.*?)\n\}/m, 1].to_s
mobile_navigation_rule = mobile_css[/\.site-navigation \{([^}]*)\}/, 1].to_s
mobile_open_rule = mobile_css[/\.site-navigation\.is-open \{([^}]*)\}/, 1].to_s
failures << "mobile navigation drawer is missing" unless mobile_navigation_rule.include?("position: fixed") && mobile_navigation_rule.include?("inset: 0") && mobile_navigation_rule.include?("transform: translateX(105%)")
failures << "mobile navigation open state is missing" unless mobile_open_rule.include?("transform: translateX(0)") && mobile_open_rule.include?("visibility: visible") && mobile_open_rule.include?("opacity: 1")
failures << "mobile scroll lock is missing" unless css.include?("body.nav-open { position: fixed; width: 100%; overflow: hidden; }") && script.include?("window.scrollTo(0, lockedScrollPosition)")
failures << "mobile menu does not close after selection" unless script.match?(/event\.target\.closest\("a"\).*?closeMenu\(\)/m)
failures << "touch targets are undersized" unless css.include?("min-height: 44px") && css.include?("min-height: 48px") && css.include?("min-height: 52px")
failures << "hero does not span the viewport" unless css.match?(/\.hero \{[^}]*width: 100vw;/)
failures << "hero background does not preserve the full-width composition" unless css.include?("background-size: 100% auto;") && css.include?("background-position: center bottom;") && css.include?("background-repeat: no-repeat;")
failures << "footer does not stack on mobile" unless css.match?(/@media \(max-width: 767px\).*?\.footer-grid \{ grid-template-columns: 1fr; \}/m)

unless failures.empty?
  failures.each { |failure| warn "FAIL: #{failure}" }
  exit 1
end

puts "PASS: Solaris Lucerna responsive contracts"
puts "  desktop, tablet, mobile navigation, grids, hero, touch targets, and footer behavior validated"
