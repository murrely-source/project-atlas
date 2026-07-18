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
failures << "mobile navigation drawer is missing" unless css.match?(/@media \(max-width: 767px\).*?\.site-navigation \{ position: fixed;.*?transform: translateX\(105%\);/m)
failures << "mobile navigation open state is missing" unless css.include?('.site-navigation.is-open { transform: translateX(0); visibility: visible; }')
failures << "mobile scroll lock is missing" unless css.include?("body.nav-open { overflow: hidden; }")
failures << "mobile menu does not close after selection" unless script.match?(/event\.target\.closest\("a"\).*?closeMenu\(\)/m)
failures << "touch targets are undersized" unless css.include?("min-height: 44px") && css.include?("min-height: 48px") && css.include?("min-height: 52px")
failures << "hero placeholder may overflow" unless css.match?(/@media \(max-width: 767px\).*?\.hero-art-placeholder \{ min-height: 280px;/m)
failures << "footer does not stack on mobile" unless css.match?(/@media \(max-width: 767px\).*?\.footer-grid \{ grid-template-columns: 1fr; \}/m)

unless failures.empty?
  failures.each { |failure| warn "FAIL: #{failure}" }
  exit 1
end

puts "PASS: Solaris Lucerna responsive contracts"
puts "  desktop, tablet, mobile navigation, grids, hero, touch targets, and footer behavior validated"
