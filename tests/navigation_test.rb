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

document_ids = html.scan(/\bid="([^"]+)"/).flatten
duplicate_ids = document_ids.group_by(&:itself).select { |_id, occurrences| occurrences.length > 1 }.keys
abort("FAIL: duplicate document IDs: #{duplicate_ids.join(', ')}") unless duplicate_ids.empty?

target_ids = expected.map { |_label, href| href.delete_prefix("#") }
section_ids = html.scan(/<section\b[^>]*\bid="([^"]+)"/).flatten
target_ids.each do |target_id|
  abort("FAIL: navigation target ##{target_id} must identify exactly one section") unless section_ids.count(target_id) == 1
end
document_navigation_order = section_ids.select { |id| target_ids.include?(id) }
abort("FAIL: navigation targets and document order diverge: #{document_navigation_order.inspect}") unless document_navigation_order == target_ids
abort("FAIL: hidden anchor workaround remains") if html.match?(/<a\b[^>]*\bid="(?:#{target_ids.join('|')})"/)
abort("FAIL: primary navigation landmark is missing") unless html.include?('id="site-navigation" aria-label="Primary navigation"')
abort("FAIL: accessible mobile menu control is missing") unless html.include?('id="site-menu-button" type="button" aria-expanded="false" aria-controls="mobile-navigation-overlay"')
abort("FAIL: dedicated mobile overlay is missing") unless html.include?('class="mobile-nav-overlay" id="mobile-navigation-overlay"') && html.include?('role="dialog" aria-modal="true"') && html.include?('aria-hidden="true" hidden')
abort("FAIL: accessible mobile close control is missing") unless html.include?('class="mobile-nav-close" id="mobile-navigation-close" type="button" aria-label="Close navigation"')
abort("FAIL: mobile navigation is not rendered from centralized data") unless html.include?("data-mobile-navigation") && script.include?("function renderMobileNavigation()") && script.include?('link.className = "mobile-nav-link"')
abort("FAIL: mobile open behavior is missing") unless script.include?("mobileOverlay.hidden = false") && script.include?('mobileOverlay.setAttribute("aria-hidden", "false")') && script.include?('menuButton.setAttribute("aria-expanded", "true")')
abort("FAIL: mobile close behavior is missing") unless script.include?("mobileOverlay.hidden = true") && script.include?('mobileOverlay.setAttribute("aria-hidden", "true")') && script.include?('menuButton.setAttribute("aria-expanded", "false")')
abort("FAIL: modal background isolation is missing") unless script.include?('document.querySelectorAll(".skip-link, .site-header, main, .site-footer")') && script.include?("element.inert = true") && script.include?("element.inert = false")
abort("FAIL: mobile backdrop close is missing") unless script.include?("event.target === mobileOverlay")
abort("FAIL: Escape close is missing") unless script.match?(/event\.key === "Escape" && menuOpen/)
abort("FAIL: focus return is missing") unless script.include?("menuButton.focus({ preventScroll: true })")
abort("FAIL: focus containment is missing") unless script.include?("function trapMenuFocus(event)")
abort("FAIL: current navigation state does not follow the selected section") unless script.include?("function updateCurrentNavigation()") && script.include?('window.addEventListener("hashchange", updateCurrentNavigation)')
abort("FAIL: navigation selection does not defer scrolling to the native anchor") unless script.include?('event.target.closest("a")') && script.match?(/event\.target\.closest\("a"\).*?closeMenu\(\{ restoreScroll: false \}\)/m)
abort("FAIL: shared anchor offset contract is incomplete") unless css.include?("--header-height: 82px") && css.include?("--anchor-offset: calc(var(--header-height) + 1rem)") && css.include?(".section[id] { scroll-margin-top: var(--anchor-offset); }") && css.include?(".site-header { position: sticky") && css.include?("min-height: var(--header-height)") && css.include?(":root { --header-height: 74px; }")
abort("FAIL: obsolete scroll-padding workaround remains") if css.match?(/scroll-padding(?:-top)?:/)
mobile_click_handler = script[/mobileOverlay\.addEventListener\("click".*?\n  \}\);/m].to_s
abort("FAIL: JavaScript overrides native fragment scrolling") if script.include?("scrollIntoView") || mobile_click_handler.include?("preventDefault") || mobile_click_handler.include?("window.scrollTo")
target_ids.each do |target_id|
  abort("FAIL: target-specific anchor positioning remains for ##{target_id}") if css.match?(/##{Regexp.escape(target_id)}\s*\{[^}]*(?:scroll|transform|position)\s*:/)
end
mobile_css = css[/@media \(max-width: 767px\) \{(.*?)\n\}/m, 1].to_s
overlay_rule = mobile_css[/\.mobile-nav-overlay \{([^}]*)\}/, 1].to_s
abort("FAIL: mobile overlay foundation is incomplete") unless overlay_rule.include?("position: fixed") && overlay_rule.include?("inset: 0") && overlay_rule.include?("z-index: 9999") && overlay_rule.include?("width: 100%") && overlay_rule.include?("height: 100vh") && overlay_rule.include?("min-height: 100vh") && overlay_rule.include?("background-color: #03131f") && overlay_rule.include?("color: #f4f7fa") && overlay_rule.include?("opacity: 1")
abort("FAIL: dynamic viewport support is missing") unless mobile_css.match?(/\.mobile-nav-overlay \{[^}]*height: 100dvh;[^}]*min-height: 100dvh;/)
abort("FAIL: hidden mobile overlay remains rendered") unless mobile_css.include?(".mobile-nav-overlay[hidden] { display: none; }") && mobile_css.include?(".mobile-nav-overlay:not([hidden]) { display: block; }")
abort("FAIL: mobile link states are incomplete") unless mobile_css.include?(".mobile-nav-link:visited") && mobile_css.include?("color: #f4f7fa") && mobile_css.include?("-webkit-text-fill-color: #f4f7fa") && mobile_css.include?("min-height: 52px")
abort("FAIL: mobile active state is incomplete") unless mobile_css.include?(".mobile-nav-link--active") && mobile_css.include?("background-color: #08283a") && mobile_css.include?("border-left: 3px solid #f5ad4e") && mobile_css.include?("-webkit-text-fill-color: #ffffff")
abort("FAIL: mobile label color is incorrect") unless mobile_css.match?(/\.mobile-nav-label \{[^}]*color: #9fdff2;/)
abort("FAIL: mobile close target or icon is incomplete") unless mobile_css.match?(/\.mobile-nav-close \{[^}]*min-width: 48px;[^}]*min-height: 48px;/) && mobile_css.match?(/\.mobile-nav-close path \{[^}]*stroke: #f4f7fa;/)
abort("FAIL: broken legacy mobile system remains active") if html.match?(/site-menu-close|site-nav-backdrop|mobile-nav-heading/) || script.match?(/classList\.(?:add|remove)\("is-open"\)|backdrop/) || mobile_css.include?(".site-navigation.is-open")
abort("FAIL: iOS page-position lock is missing") unless script.include?("lockedScrollPosition = window.scrollY") && script.include?('document.body.style.top = `-${lockedScrollPosition}px`') && script.include?("window.scrollTo(0, lockedScrollPosition)")

puts "PASS: Solaris Lucerna public navigation"
puts "  approved six-link order and accessible mobile behavior validated"
