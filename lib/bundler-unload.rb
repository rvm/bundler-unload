require "bundler"

module Bundler
  class RubygemsIntegration
    class Legacy
      def plain_specs
        Gem.source_index.gems
      end
      def plain_specs=(specs)
        Gem.source_index.instance_variable_set(:@gems, specs)
      end
    end

    class Modern
      def plain_specs
        Gem::Specification._all
      end
      def plain_specs=(specs)
        Gem::Specification.all = specs
      end
    end

    class Future
      def plain_specs
        Gem::Specification._all
      end
      def plain_specs=(specs)
        Gem::Specification.all = specs
      end
    end
  end

  class << self
    def unload!(rubygems_specs)
      @load = nil
      ENV.replace(ORIGINAL_ENV)
      Bundler.rubygems.plain_specs = rubygems_specs
    end

    def temporary_load(&block)
      rubygems_specs = Bundler.rubygems.plain_specs
      Bundler.load
      yield
    ensure
      unload!(rubygems_specs)
    end
  end
end
