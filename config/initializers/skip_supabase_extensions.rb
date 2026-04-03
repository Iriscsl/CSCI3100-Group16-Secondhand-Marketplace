# Supabase uses schema-qualified extensions (e.g. extensions.pgcrypto, vault.supabase_vault)
# that do not exist in a local PostgreSQL instance. This patch silently skips those errors
# when loading schema.rb for the test database, so that `bin/rails db:test:prepare` works
# against a plain local PostgreSQL while keeping schema.rb unchanged for Supabase.

if Rails.env.test? || Rails.env.development?
  ActiveSupport.on_load(:active_record) do
    require "active_record/connection_adapters/postgresql_adapter"

    module SilentExtensionErrors
      def enable_extension(name, **)
        super
      rescue ActiveRecord::StatementInvalid => e
        Rails.logger.warn "Skipping unavailable extension: #{name} (#{e.message.lines.first.strip})"
      end
    end

    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(SilentExtensionErrors)
  end
end
