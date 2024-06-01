namespace :product do
  desc "Update product slugs"
  task update_slugs: :environment do
    Product.find_each(&:save)
  end
end