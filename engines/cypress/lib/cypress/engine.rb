module Cypress
  class Engine < ::Rails::Engine
    isolate_namespace Cypress

    config.cypress_engine = ActiveSupport::OrderedOptions.new
    initializer 'cypress_engine.configuration' do |app|
      if app.config.cypress_engine[:mounted_path]
        app.routes.append do
          mount Cypress::Engine => app.config.cypress_engine[:mounted_path]
        end
      end
    end

    initializer "cypress_engine.cypress_only" do
      unless Rails.env.cypress?
        abort <<-END.strip_heredoc
          Cypress Engine is activated in the #{Rails.env} environment. This is
          usually a mistake. To ensure it's only activated in cypress
          mode, move it to the cypress group of your Gemfile:

              gem 'cypress-engine', group: :cypress
        END
      end
    end
  end
end
