#!/usr/bin/env ruby
# Static WCAG 2.2 AA architecture contracts for the Solaris Lucerna public website.

require "digest"

root = File.expand_path("..", __dir__)
html = File.read(File.join(root, "app", "index.html"), encoding: "UTF-8")
css = File.read(File.join(root, "app", "site.css"), encoding: "UTF-8")
script = File.read(File.join(root, "app", "site.js"), encoding: "UTF-8")
accessibility_standard = File.read(File.join(root, "docs", "standards", "ACCESSIBILITY.md"), encoding: "UTF-8")
manual_test = File.read(File.join(root, "tests", "MANUAL_SMOKE_TEST.md"), encoding: "UTF-8")
pages_workflow = File.read(File.join(root, ".github", "workflows", "deploy-pages.yml"), encoding: "UTF-8")
failures = []

failures << "document language is missing" unless html.include?('<html lang="en">')
failures << "required landmarks are incomplete" unless %w[header main footer].all? { |element| html.match?(/<#{element}\b/) } && html.scan(/<nav\b/).length >= 2
failures << "skip link is missing" unless html.include?('<a class="skip-link" href="#main-content">') && html.include?('<main id="main-content">')

heading_levels = html.scan(/<h([1-6])\b/).flatten.map(&:to_i)
failures << "page must contain exactly one h1" unless heading_levels.count(1) == 1
failures << "heading levels are skipped" if heading_levels.each_cons(2).any? { |first, second| second > first + 1 }

failures << "positive tabindex creates an artificial focus order" if html.match?(/tabindex="[1-9]/)
failures << "visible focus treatment is missing" unless css.match?(/:focus-visible \{[^}]*outline: 3px solid var\(--focus\);/)
failures << "reduced-motion support is missing" unless css.include?("@media (prefers-reduced-motion: reduce)")
failures << "forced-colors heading fallback is missing" unless css.match?(/@media \(forced-colors: active\).*?\.hero h1 \{ background: none; color: CanvasText; \}/m)

failures << "mobile dialog semantics are incomplete" unless html.include?('role="dialog" aria-modal="true"') && html.include?('aria-hidden="true" hidden')
failures << "mobile dialog does not isolate background content" unless script.include?("element.inert = true") && script.include?("element.inert = false")
failures << "mobile dialog lacks Escape close" unless script.match?(/event\.key === "Escape" && menuOpen/)
failures << "mobile dialog lacks backdrop close" unless script.include?("event.target === mobileOverlay")
failures << "mobile dialog lacks focus containment or restoration" unless script.include?("function trapMenuFocus(event)") && script.include?("menuButton.focus({ preventScroll: true })")

failures << "critical target sizes are incomplete" unless css.match?(/\.wordmark \{[^}]*min-height: 44px;/) && css.match?(/\.site-navigation a \{[^}]*min-height: 44px;/) && css.include?("min-height: 48px") && css.include?("min-height: 52px")
failures << "Hero title prevents user text-spacing adaptation" if css.match?(/\.hero-title-line \{[^}]*white-space: nowrap;/)

hero_rule = css[/\.hero \{([^}]*)\}/, 1].to_s
failures << "approved Hero artwork is not exposed as decorative CSS imagery" unless hero_rule.include?('background-image: url("assets/brand/hero-sunrise.png");')
failures << "Hero artwork is dimmed or filtered" if hero_rule.match?(/linear-gradient|opacity|filter|background-blend-mode/)
failures << "Hero artwork has a redundant accessible image" if html.include?('src="assets/brand/hero-sunrise.png"')
hero_artwork = File.join(root, "app", "assets", "brand", "hero-sunrise.png")
approved_hero_checksum = "3a71e74dc8a8cc2e6c60e1ec17379679982007720c54f53e56bf93aba1a7454a"
failures << "approved Hero artwork changed" unless File.file?(hero_artwork) && Digest::SHA256.file(hero_artwork).hexdigest == approved_hero_checksum

failures << "ambiguous link wording remains" if html.match?(/>\s*(?:click here|read more|learn more)\s*</i)
contact_fields = {
  "contact-full-name" => true,
  "contact-company" => true,
  "contact-email" => true,
  "contact-phone" => false,
  "contact-subject" => true,
  "contact-message" => true
}
contact_fields.each do |id, required|
  failures << "contact field ##{id} has no explicit label" unless html.include?(%[for="#{id}"])
  control = html[/<(?:input|textarea)\b[^>]*id="#{Regexp.escape(id)}"[^>]*>/, 0].to_s
  failures << "contact field ##{id} is missing" if control.empty?
  failures << "contact field ##{id} required state is incorrect" unless control.include?(" required") == required
  failures << "contact field ##{id} lacks inline error association" unless control.include?(%[aria-describedby="#{id}-error"])
end
failures << "contact error summary is not focusable or announced" unless html.include?('id="contact-error-summary" role="alert" tabindex="-1" hidden') && script.include?("contactErrorSummary.focus()")
failures << "contact status is not announced" unless html.include?('id="contact-status" role="status" aria-live="polite"')
failures << "contact success state is not focusable or announced" unless html.include?('id="contact-success" role="status" tabindex="-1" hidden') && script.include?("contactSuccess.focus()")
failures << "contact inline validation does not expose invalid state" unless script.include?('field.setAttribute("aria-invalid", message ? "true" : "false")')
failures << "contact submission state is not accessible" unless script.include?('contactForm.setAttribute("aria-busy", String(isSubmitting))') && script.include?("contactSubmit.disabled = isSubmitting") && script.include?('"Sending..."')
failures << "Turnstile does not have an accessible visible label" unless html.include?('id="turnstile-label">Security verification') && html.include?('id="contact-turnstile" aria-labelledby="turnstile-label"')

failures << "Project Aurora accessibility guidance is incomplete" unless accessibility_standard.include?("## Project Aurora public website") && accessibility_standard.include?("actual rendered raster pixels") && accessibility_standard.include?("Hero accessibility strategy")
failures << "manual accessibility protocol is incomplete" unless %w[100% 125% 150% 200% 400%].all? { |zoom| manual_test.include?(zoom) } && manual_test.include?("Tab, Shift+Tab, Enter, Space, Escape")
failures << "Pages deployment is not gated by repository validation" unless pages_workflow.include?("quality:") && pages_workflow.include?("needs: quality") && pages_workflow.include?('for test_file in tests/*_test.rb') && pages_workflow.include?("pull_request:")

unless failures.empty?
  failures.each { |failure| warn "FAIL: #{failure}" }
  exit 1
end

puts "PASS: Solaris Lucerna WCAG architecture contracts"
puts "  semantics, headings, focus, targets, modal behavior, forced colors, motion, and decorative-image roles validated"
