json.extract! app, :id, :nid, :name, :stack, :key_benefits, :categories, :tags, :tiny_description,
  :testimonials, :pictures, :pricing_plans, :rank, :support_url, :key_workflows, :key_features, :pricing_text

json.description markdown(app.sanitized_description)
json.known_limitations markdown(app.known_limitations)
json.getting_started markdown(app.getting_started)

json.is_responsive app.responsive?
json.is_star_ready app.star_ready?
json.is_connec_ready app.connec_ready?
json.is_coming_soon app.coming_soon?
json.single_billing app.single_billing?
json.multi_instantiable app.multi_instantiable
json.subcategories app.subcategories
json.average_rating app.average_rating
json.add_on app.add_on?
json.running_instances_count app.running_instances_count

json.shared_entities do
  json.array! app.shared_entities do |shared_entity|
    json.extract! shared_entity, :shared_entity_nid, :shared_entity_name, :write, :read
  end
end if app.shared_entities.any?

if app.logo
  json.logo app.logo.to_s
end
