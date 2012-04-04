require 'spree_core'
require 'spree_s3_hooks'

module SpreeS3
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    initializer 'my_engine.interact_with_routes', :after=> :disable_dependency_loading do |app|
      S3.load_s3_yaml

      Spree::Image.class_eval do
        extend S3::Attachment
        sends_files_to_s3 if S3.enabled?
      end

      Spree::Taxon.class_eval do
        extend S3::Attachment
        sends_files_to_s3 if S3.enabled?
      end
    end

    def self.activate
      # do nothing, I suck
    end

    config.to_prepare &method(:activate).to_proc
  end
end
