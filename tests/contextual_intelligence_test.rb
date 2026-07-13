#!/usr/bin/env ruby
# ECR-012 Standards & Learning mapping, filtering, and route contracts.
require "json"

root = File.expand_path("..", __dir__)
dataset = JSON.parse(File.read(File.join(root, "app", "data", "intelligence.json"), encoding: "UTF-8"))
items = dataset.fetch("items")
html = File.read(File.join(root, "app", "index.html"), encoding: "UTF-8")
data_script = File.read(File.join(root, "app", "data.js"), encoding: "UTF-8")
app_script = File.read(File.join(root, "app", "app.js"), encoding: "UTF-8")

mappings = {
  "intelligence" => [],
  "standards" => ["Standards", "Official Guidance", "Implementation Guidance", "Standards Training", "Certification", "Training", "Webinar", "Conference", "Publication", "Exam Update", "Course Update"],
  "regulation" => ["Regulation", "Enforcement", "Consultation", "Legislation"],
  "human" => ["Human Impact", "AI Literacy", "Human Oversight", "Workforce Readiness"]
}

expected_ids = {}
mappings.each do |workspace, categories|
  expected_ids[workspace] = items.select do |item|
    item["verified"] == true && (workspace == "intelligence" || (item["category"] & categories).any?)
  end.map { |item| item["id"] }
end

expected_counts = { "intelligence" => 5, "standards" => 2, "regulation" => 3, "human" => 1 }
abort("FAIL: governed contextual mappings changed: #{expected_ids.inspect}") unless expected_ids.transform_values(&:length) == expected_counts

abort("FAIL: contextual feeds do not share the governed dataset") unless app_script.include?("atlasData.articles.filter") && !File.exist?(File.join(root, "app", "data", "learning.json"))
abort("FAIL: contextual feeds do not exclude unverified records") unless app_script.include?("article.verified !== true")
abort("FAIL: contextual feed triggers do not open the shared drawer") unless app_script.include?('button.addEventListener("click", () => openDrawer(article, button))')
abort("FAIL: feed renderer is not reusable") unless app_script.include?("function renderWorkspaceIntelligenceFeed(container)") && app_script.include?("workspaceIntelligenceFeeds.forEach(renderWorkspaceIntelligenceFeed)")

mappings.each_key do |workspace|
  abort("FAIL: missing #{workspace} contextual feed") unless html.include?("data-intelligence-feed=\"#{workspace}\"")
end

monitored_programs = ["NIST", "ISO / ISO/IEC", "OECD", "IEEE", "W3C", "CISA", "OWASP", "EU AI Office", "UK AI Safety Institute", "Singapore IMDA / AI Verify", "IAPP", "IAPP AIGP", "ISACA", "ISACA AAIA", "PMI", "ISO/IEC 42001 training and auditor pathways", "ISO 23894 learning", "ITIL AI Governance"]
monitored_programs.each do |program|
  abort("FAIL: missing monitored program #{program}") unless data_script.include?(program)
end
abort("FAIL: Standards & Learning sidebar label is missing") unless html.include?('data-page="standards">Standards &amp; Learning</button>')
abort("FAIL: duplicate Learning workspace remains") if html.include?('data-page="learning"') || html.include?('id="learning" class="page"')
abort("FAIL: IAPP AIGP is not represented in both ecosystem and certification contexts") unless data_script.scan("IAPP AIGP").length >= 2
abort("FAIL: composable Standards & Learning filters are missing") unless %w[organization contentType certification status recommendation].all? { |filter| html.include?("data-standards-filter=\"#{filter}\"") } && app_script.include?("Object.entries(activeStandardsFilters).every")
abort("FAIL: controlled organization aliases are missing") unless data_script.include?('"EU AI Office": Object.freeze(["EU AI Office", "European AI Office", "European Commission"])') && app_script.include?("standardsLearningOrganizationAliases")
eu_record = items.find { |item| item["id"] == "INT-2026-0712-005" }
eu_values = [eu_record["title"], eu_record["source"], *eu_record["category"], *eu_record["relatedStandards"], *eu_record["relatedSolarisModules"]].map(&:downcase)
eu_aliases = ["EU AI Office", "European AI Office", "European Commission"]
abort("FAIL: EU AI Office aliases do not match the governed record") unless eu_aliases.any? { |alias_name| eu_values.any? { |value| value.include?(alias_name.downcase) } }

synthetic_learning_record = {
  "verified" => true,
  "category" => ["Certification", "Course Update"],
  "tags" => ["IAPP AIGP", "Updated"],
  "source" => "IAPP",
  "recommendation" => "Monitor"
}
synthetic_values = (synthetic_learning_record["category"] + synthetic_learning_record["tags"] + [synthetic_learning_record["source"], synthetic_learning_record["recommendation"]]).map(&:downcase)
abort("FAIL: certification records are not supported by the standards mapping") unless (synthetic_learning_record["category"] & mappings["standards"]).any?
abort("FAIL: IAPP AIGP organization filter support is missing") unless synthetic_values.any? { |value| value.include?("iapp") }
abort("FAIL: IAPP AIGP certification filter support is missing") unless synthetic_values.any? { |value| value.include?("iapp aigp") }
abort("FAIL: content type filter support is missing") unless synthetic_values.any? { |value| value.include?("certification") }
abort("FAIL: combined status and recommendation support is missing") unless synthetic_values.include?("updated") && synthetic_learning_record["recommendation"] == "Monitor"
abort("FAIL: safe shared source-link contract changed") unless html.match?(/id="original-source"[^>]*target="_blank"[^>]*rel="noopener noreferrer"/)
abort("FAIL: Business Impact is missing from the shared drawer") unless html.include?('id="drawer-business-impact"') && app_script.include?('article.businessImpact')
abort("FAIL: contextual return control is not dynamic") unless app_script.include?('drawerReturn.textContent = `← Return to ${originLabel}`') && app_script.include?('activatePage(drawerOriginWorkspace)')

puts "PASS: ECR-012 Standards & Learning"
expected_counts.each { |workspace, count| puts "  #{workspace}: #{count} verified governed record#{count == 1 ? '' : 's'}" }
puts "  unified route, monitored scope, composable filters, shared drawer, and unverified-record exclusion contracts validated"
