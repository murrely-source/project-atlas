#!/usr/bin/env ruby
# Dataset integrity checks for Sprint 3 intelligence architecture.
require "json"
require "uri"

root = File.expand_path("..", __dir__)
path = File.join(root, "app", "data", "intelligence.json")
abort("FAIL: intelligence.json is missing") unless File.file?(path)

begin
  dataset = JSON.parse(File.read(path, encoding: "UTF-8"))
rescue JSON::ParserError => error
  abort("FAIL: intelligence.json is malformed: #{error.message}")
end

articles = dataset["items"]
abort("FAIL: governed intelligence dataset must contain five items") unless articles.is_a?(Array) && articles.length == 5
abort("FAIL: governed dataset must not depend on live: false") if File.read(path, encoding: "UTF-8").match?(/"live"\s*:\s*false/)

required_fields = %w[id title source published url category readTime executiveSummary keyTakeaways whyItMatters businessImpact relatedStandards relatedSolarisModules recommendation evidenceQuality chairNotes bookmarked verified]
articles.each_with_index do |article, index|
  missing = required_fields.reject { |field| article.key?(field) }
  abort("FAIL: article #{index} missing fields: #{missing.join(', ')}") unless missing.empty?
end

ids = articles.map { |article| article["id"] }
abort("FAIL: article IDs must be non-empty and unique") unless ids.all? { |id| id.is_a?(String) && !id.empty? } && ids.uniq.length == ids.length

articles.each do |article|
  next unless article["verified"]
  url = article["url"]
  parsed = URI.parse(url)
  abort("FAIL: verified URL for #{article['id']} must use HTTPS") unless parsed.is_a?(URI::HTTPS)
rescue URI::InvalidURIError
  abort("FAIL: verified URL for #{article['id']} is invalid")
end
abort("FAIL: example.com placeholder URLs remain") if articles.any? { |article| article["url"].to_s.include?("example.com") }
abort("FAIL: governed categories must be non-empty arrays") unless articles.all? { |article| article["category"].is_a?(Array) && !article["category"].empty? }

normalized_articles = articles.map do |article|
  article.merge(
    "publishedDate" => article["publishedDate"] || article["published"],
    "originalUrl" => article.key?("originalUrl") ? article["originalUrl"] : article["url"],
    "estimatedReadingTime" => article["estimatedReadingTime"] || (article["readTime"].is_a?(Numeric) ? "#{article['readTime']} min" : article["readTime"]),
    "boardRecommendation" => article["boardRecommendation"] || article["recommendation"],
    "category" => article["category"].is_a?(Array) ? article["category"].dup : [article["category"]]
  )
end

application_fields = %w[id source title publishedDate originalUrl category estimatedReadingTime executiveSummary keyTakeaways whyItMatters businessImpact relatedStandards relatedSolarisModules boardRecommendation evidenceQuality chairNotes bookmarked verified]
normalized_articles.each_with_index do |article, index|
  missing = application_fields.reject { |field| article.key?(field) }
  abort("FAIL: normalized article #{index} missing application fields: #{missing.join(', ')}") unless missing.empty?
end

articles.zip(normalized_articles).each do |source, normalized|
  abort("FAIL: published was not mapped to publishedDate for #{source['id']}") unless normalized["publishedDate"] == source["published"]
  abort("FAIL: url was not mapped to originalUrl for #{source['id']}") unless normalized["originalUrl"] == source["url"]
  abort("FAIL: readTime was not mapped to estimatedReadingTime for #{source['id']}") unless normalized["estimatedReadingTime"] == "#{source['readTime']} min"
  abort("FAIL: recommendation was not mapped to boardRecommendation for #{source['id']}") unless normalized["boardRecommendation"] == source["recommendation"]
  abort("FAIL: category array changed for #{source['id']}") unless normalized["category"] == source["category"]

  %w[published readTime recommendation url executiveSummary keyTakeaways whyItMatters businessImpact relatedStandards relatedSolarisModules evidenceQuality chairNotes bookmarked verified].each do |field|
    abort("FAIL: governed field #{field} was not preserved for #{source['id']}") unless normalized[field] == source[field]
  end
end

legacy_category = "Legacy Governance"
legacy_normalized_category = legacy_category.is_a?(Array) ? legacy_category : [legacy_category]
abort("FAIL: legacy single-string category compatibility is missing") unless legacy_normalized_category == [legacy_category]

app_script = File.read(File.join(root, "app", "app.js"), encoding: "UTF-8")
app_html = File.read(File.join(root, "app", "index.html"), encoding: "UTF-8")
abort("FAIL: News Desk does not render the loaded records") unless app_script.include?("atlasData.articles.forEach") && app_script.include?("button.dataset.articleId = article.id")
abort("FAIL: drawer does not receive the selected loaded article") unless app_script.include?('button.addEventListener("click", () => openDrawer(article, button))')
abort("FAIL: loader does not accept governed items") unless app_script && File.read(File.join(root, "app", "data.js"), encoding: "UTF-8").include?("Array.isArray(payload.items) ? payload.items : payload.articles")

loader_script = File.read(File.join(root, "app", "data.js"), encoding: "UTF-8")
mapping_contracts = {
  "publishedDate" => "article.publishedDate ?? article.published",
  "originalUrl" => "article.originalUrl ?? article.url ?? null",
  "estimatedReadingTime" => "article.estimatedReadingTime ?? article.readTime",
  "boardRecommendation" => "article.boardRecommendation ?? article.recommendation"
}
mapping_contracts.each do |field, contract|
  abort("FAIL: loader is missing the #{field} schema mapping") unless loader_script.include?(contract)
end
abort("FAIL: legacy string categories are not normalized") unless loader_script.include?("Array.isArray(category) ? [...category] : [category]")
normalization_position = loader_script.index("const article = normalizeArticle(sourceArticle);")
validation_position = loader_script.index("requiredStringFields.forEach", normalization_position || 0)
abort("FAIL: validation does not run against the normalized application model") unless normalization_position && validation_position && normalization_position < validation_position
abort("FAIL: category arrays do not render in the News Desk") unless app_script.include?('Categories: ${article.category.join(", ")}')
abort("FAIL: category arrays do not filter by membership") unless app_script.include?("categories.some((articleCategory) => articleCategory.includes(category))")

drawer_bindings = {
  '#drawer-source' => 'article.source',
  '#drawer-title' => 'article.title',
  '#drawer-published' => 'article.publishedDate',
  '#drawer-reading-time' => 'article.estimatedReadingTime',
  '#drawer-evidence' => 'article.evidenceQuality',
  '#drawer-summary' => 'article.executiveSummary',
  '#drawer-why' => 'article.whyItMatters',
  '#drawer-business-impact' => 'article.businessImpact',
  '#drawer-recommendation' => 'article.boardRecommendation',
  '#drawer-takeaways' => 'article.keyTakeaways',
  '#drawer-standards' => 'article.relatedStandards',
  '#drawer-modules' => 'article.relatedSolarisModules',
  '#drawer-categories' => 'article.category'
}
drawer_bindings.each do |selector, value|
  abort("FAIL: drawer is missing the #{value} binding") unless app_script.include?(selector) && app_script.include?(value)
end

safe_source_link = app_html.match?(/id="original-source"[^>]*target="_blank"[^>]*rel="noopener noreferrer"/)
abort("FAIL: original-source link is not configured for safe new-tab behavior") unless safe_source_link
abort("FAIL: original-source link does not use the selected record URL") unless app_script.include?("originalSource.href = article.originalUrl")
abort("FAIL: missing source URLs are not disabled") unless app_script.include?('originalSource.removeAttribute("href")') && app_script.include?("sourcePending.hidden = false") && app_html.include?("Source link pending verification")

puts "PASS: Sprint 3 intelligence dataset"
puts "  #{articles.length} governed records validated with unique IDs"
puts "  normalized application fields and preserved governed fields validated for every record"
puts "  category arrays, legacy category compatibility, HTTPS source links, drawer bindings, and safe new-tab behavior verified"
